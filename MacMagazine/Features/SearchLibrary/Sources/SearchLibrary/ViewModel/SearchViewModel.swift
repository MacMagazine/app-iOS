import Foundation
import StorageLibrary
import SwiftData

enum SearchStatus: Equatable {
    case idle
    case searching
    case localResults
    case done
    case error(reason: String)
}

@MainActor @Observable
class SearchViewModel {
    var searchText: String = ""
    var status: SearchStatus = .idle
    var results: [SearchResult] = []
    var recentSearches: [RecentSearchDB] = []

    private let queryProcessor: QueryProcessor
    private let localSearch: LocalSearchService
    private let merger: SearchResultMerger
    private let storage: Database
    private var remoteFeedSearch: RemoteFeedSearchService?
    private var searchTask: Task<Void, Never>?

    init(
        storage: Database,
        queryProcessor: QueryProcessor = QueryProcessor(),
        localSearch: LocalSearchService = LocalSearchService(),
        merger: SearchResultMerger = SearchResultMerger()
    ) {
        self.storage = storage
        self.queryProcessor = queryProcessor
        self.localSearch = localSearch
        self.merger = merger
        self.remoteFeedSearch = RemoteFeedSearchService(storage: storage)
        loadRecentSearches()
    }

    func performSearch() {
        searchTask?.cancel()

        let query = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !query.isEmpty else {
            status = .idle
            results = []
            return
        }

        searchTask = Task {
            // Debounce 300ms
            try? await Task.sleep(for: .milliseconds(300))
            guard !Task.isCancelled else { return }

            status = .searching

            let intent = queryProcessor.process(query)

            // Phase 1: Local search (instant)
            let localResults = localSearch.search(
                intent: intent,
                context: storage.sharedModelContainer.mainContext
            )

            guard !Task.isCancelled else { return }
            results = localResults
            if !localResults.isEmpty {
                status = .localResults
            }

            // Phase 2: Remote search
            await searchRemote(intent: intent)

            guard !Task.isCancelled else { return }
            if case .error = status {} else {
                status = .done
            }

            // Save to recent searches
            saveRecentSearch(query)
        }
    }

    func clearSearch() {
        searchText = ""
        results = []
        status = .idle
        searchTask?.cancel()
    }

    func selectRecentSearch(_ search: RecentSearchDB) {
        searchText = search.query
        performSearch()
    }

    func clearRecentSearches() {
        let context = storage.sharedModelContainer.mainContext
        for search in recentSearches {
            context.delete(search)
        }
        try? context.save()
        recentSearches = []
    }

    func removeRecentSearch(_ search: RecentSearchDB) {
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
            if let feedResults = try await remoteFeedSearch?.search(term: intent.remoteSearchTerm) {
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

        // Remove duplicate if exists
        if let existing = recentSearches.first(where: { $0.query == trimmed }) {
            context.delete(existing)
        }

        context.insert(RecentSearchDB(query: trimmed))
        try? context.save()

        // Reload fresh data, then trim excess
        loadRecentSearches()
        let maxRecent = 20
        if recentSearches.count > maxRecent {
            for item in recentSearches.dropFirst(maxRecent) {
                context.delete(item)
            }
            try? context.save()
            loadRecentSearches()
        }
    }
}
