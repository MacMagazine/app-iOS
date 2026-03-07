import Foundation
import StorageLibrary
import SwiftData

public enum SearchStatus: Equatable {
    case idle
    case searching
    case localResults
    case done
    case error(reason: String)
}

@MainActor @Observable
public final class SearchViewModel {
    public var searchText: String = ""
    public var status: SearchStatus = .idle
    var results: [SearchResult] = []
    var recentSearches: [RecentSearchDB] = []

    private let queryProcessor: QueryProcessor
    private let localSearch: any LocalSearchServiceProtocol
    private let merger: any SearchResultMergerProtocol
    private let storage: Database
    private var remoteSearch: (any RemoteSearchServiceProtocol)?
    private static let maxRecentSearches = 20
    private static let debounceDuration: Duration = .milliseconds(500)
    private var searchTask: Task<Void, Never>?

    public init(storage: Database) {
        self.storage = storage
        self.queryProcessor = QueryProcessor()
        self.localSearch = LocalSearchService()
        self.merger = SearchResultMerger()
        self.remoteSearch = RemoteFeedSearchService(storage: storage)
        loadRecentSearches()
    }

    init(
        storage: Database,
        localSearch: some LocalSearchServiceProtocol,
        remoteSearch: (some RemoteSearchServiceProtocol)?,
        merger: some SearchResultMergerProtocol
    ) {
        self.storage = storage
        self.queryProcessor = QueryProcessor()
        self.localSearch = localSearch
        self.merger = merger
        self.remoteSearch = remoteSearch
        loadRecentSearches()
    }

    public func performSearch(debounce: Bool = true) {
        searchTask?.cancel()

        let query = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !query.isEmpty else {
            status = .idle
            results = []
            return
        }

        searchTask = Task {
            if debounce {
                try? await Task.sleep(for: Self.debounceDuration)
                guard !Task.isCancelled else { return }
            }

            status = .searching

            let intent = queryProcessor.process(query)

            let localResults = localSearch.search(
                intent: intent,
                context: storage.sharedModelContainer.mainContext
            )

            guard !Task.isCancelled else { return }
            results = localResults
            if !localResults.isEmpty {
                status = .localResults
            }

            await searchRemote(intent: intent)

            guard !Task.isCancelled else { return }
            if case .error = status { return }
            status = .done

            saveRecentSearch(query)
        }
    }

    public func clearSearch() {
        searchText = ""
        results = []
        status = .idle
        searchTask?.cancel()
    }

    public func selectRecentSearch(_ search: RecentSearchDB) {
        searchText = search.query
        performSearch(debounce: false)
    }

    public func clearRecentSearches() {
        let context = storage.sharedModelContainer.mainContext
        for search in recentSearches {
            context.delete(search)
        }
        try? context.save()
        recentSearches = []
    }

    public func removeRecentSearch(_ search: RecentSearchDB) {
        let context = storage.sharedModelContainer.mainContext
        context.delete(search)
        try? context.save()
        recentSearches.removeAll { $0.query == search.query }
    }
}

// MARK: - Remote Search

private extension SearchViewModel {

    func searchRemote(intent: QueryIntent) async {
        guard !intent.remoteSearchTerm.isEmpty else { return }

        do {
            if let feedResults = try await remoteSearch?.search(term: intent.remoteSearchTerm, page: 0) {
                guard !Task.isCancelled else { return }
                results = merger.merge(existing: results, incoming: feedResults, intent: intent)
            }
        } catch {
            status = .error(reason: error.localizedDescription)
        }
    }
}

// MARK: - Recent Searches

private extension SearchViewModel {

    func loadRecentSearches() {
        let descriptor = FetchDescriptor<RecentSearchDB>(
            sortBy: [SortDescriptor(\RecentSearchDB.timestamp, order: .reverse)]
        )
        let context = storage.sharedModelContainer.mainContext
        recentSearches = (try? context.fetch(descriptor)) ?? []
    }

    func saveRecentSearch(_ query: String) {
        let context = storage.sharedModelContainer.mainContext
        let trimmed = query.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }

        if let existing = recentSearches.first(where: { $0.query == trimmed }) {
            context.delete(existing)
        }

        context.insert(RecentSearchDB(query: trimmed))
        try? context.save()

        loadRecentSearches()
        if recentSearches.count > Self.maxRecentSearches {
            for item in recentSearches.dropFirst(Self.maxRecentSearches) {
                context.delete(item)
            }
            try? context.save()
            loadRecentSearches()
        }
    }
}
