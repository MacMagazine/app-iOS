import Foundation
@testable import SearchLibrary
import StorageLibrary
import SwiftData
import Testing

@MainActor
private struct MockLocalSearchService: LocalSearchServiceProtocol {
    var resultsToReturn: [SearchResult] = []

    func search(intent: QueryIntent, context: ModelContext) -> [SearchResult] {
        resultsToReturn
    }
}

private struct MockRemoteSearchService: RemoteSearchServiceProtocol {
    var resultsToReturn: [SearchResult] = []
    var errorToThrow: Error?

    @MainActor
    func search(term: String, page: Int) async throws -> [SearchResult] {
        if let error = errorToThrow { throw error }
        return resultsToReturn
    }
}

private struct MockMerger: SearchResultMergerProtocol {
    func merge(existing: [SearchResult], incoming: [SearchResult], intent: QueryIntent) -> [SearchResult] {
        existing + incoming
    }
}

private func makeResult(
    id: String = "test_1",
    type: SearchResultType = .news,
    title: String = "Test Result",
    pubDate: Date = Date()
) -> SearchResult {
    SearchResult(
        id: id,
        type: type,
        pubDate: pubDate,
        relevanceScore: 0,
        feedDB: nil,
        podcastDB: nil,
        videoDB: nil
    )
}

@Suite("SearchViewModel Tests")
@MainActor
struct SearchViewModelTests {

    private func makeViewModel(
        localResults: [SearchResult] = [],
        remoteResults: [SearchResult] = [],
        remoteError: Error? = nil
    ) -> SearchViewModel {
        let storage = Database(
            models: [RecentSearchDB.self],
            inMemory: true
        )
        let localSearch = MockLocalSearchService(resultsToReturn: localResults)
        let remoteSearch = MockRemoteSearchService(
            resultsToReturn: remoteResults,
            errorToThrow: remoteError
        )
        return SearchViewModel(
            storage: storage,
            localSearch: localSearch,
            remoteSearch: remoteSearch,
            merger: MockMerger()
        )
    }

    private func waitForDebounce() async throws {
        try await Task.sleep(for: .milliseconds(600))
    }

    // MARK: - Search State

    @Test("Initial state is idle with empty results")
    func initialState() {
        let viewModel = makeViewModel()
        #expect(viewModel.status == .idle)
        #expect(viewModel.results.isEmpty)
        #expect(viewModel.searchText.isEmpty)
    }

    @Test("Empty search text resets to idle")
    func emptySearchResetsToIdle() {
        let viewModel = makeViewModel()
        viewModel.searchText = "   "
        viewModel.performSearch()
        #expect(viewModel.status == .idle)
        #expect(viewModel.results.isEmpty)
    }

    @Test("clearSearch resets all state")
    func clearSearchResetsState() {
        let viewModel = makeViewModel()
        viewModel.searchText = "iPhone"
        viewModel.clearSearch()
        #expect(viewModel.searchText.isEmpty)
        #expect(viewModel.results.isEmpty)
        #expect(viewModel.status == .idle)
    }

    @Test("Search with local results shows localResults then done")
    func searchShowsLocalThenDone() async throws {
        let localResults = [makeResult(title: "iPhone 17")]
        let viewModel = makeViewModel(localResults: localResults)

        viewModel.searchText = "iPhone"
        viewModel.performSearch()

        try await waitForDebounce()

        #expect(viewModel.status == .done)
        #expect(!viewModel.results.isEmpty)
    }

    @Test("Search with remote error sets error status")
    func searchWithRemoteError() async throws {
        let viewModel = makeViewModel(
            remoteError: URLError(.notConnectedToInternet)
        )

        viewModel.searchText = "iPhone"
        viewModel.performSearch()

        try await waitForDebounce()

        if case .error = viewModel.status {
            // expected
        } else {
            Issue.record("Expected .error status, got \(viewModel.status)")
        }
    }

    @Test("Search merges local and remote results")
    func searchMergesResults() async throws {
        let local = [makeResult(id: "local_1", title: "Local Result")]
        let remote = [makeResult(id: "remote_1", title: "Remote Result")]
        let viewModel = makeViewModel(localResults: local, remoteResults: remote)

        viewModel.searchText = "test"
        viewModel.performSearch()

        try await waitForDebounce()

        #expect(viewModel.results.count == 2)
        #expect(viewModel.status == .done)
    }

    // MARK: - Recent Searches

    @Test("Recent searches initially empty")
    func recentSearchesEmpty() {
        let viewModel = makeViewModel()
        #expect(viewModel.recentSearches.isEmpty)
    }

    @Test("Search saves to recent searches after completion")
    func searchSavesToRecent() async throws {
        let viewModel = makeViewModel()
        viewModel.searchText = "iPhone test"
        viewModel.performSearch()

        try await waitForDebounce()

        #expect(!viewModel.recentSearches.isEmpty)
        #expect(viewModel.recentSearches.first?.query == "iPhone test")
    }

    @Test("clearRecentSearches removes all history")
    func clearRecentSearches() async throws {
        let viewModel = makeViewModel()

        viewModel.searchText = "test query"
        viewModel.performSearch()
        try await waitForDebounce()
        #expect(!viewModel.recentSearches.isEmpty)

        viewModel.clearRecentSearches()
        #expect(viewModel.recentSearches.isEmpty)
    }

    @Test("removeRecentSearch removes specific entry")
    func removeSpecificRecentSearch() async throws {
        let viewModel = makeViewModel()

        viewModel.searchText = "first query"
        viewModel.performSearch()
        try await waitForDebounce()

        viewModel.searchText = "second query"
        viewModel.performSearch()
        try await waitForDebounce()

        let countBefore = viewModel.recentSearches.count
        #expect(countBefore >= 2)

        if let toRemove = viewModel.recentSearches.first(where: { $0.query == "first query" }) {
            viewModel.removeRecentSearch(toRemove)
        }

        #expect(viewModel.recentSearches.count == countBefore - 1)
        #expect(!viewModel.recentSearches.contains { $0.query == "first query" })
    }

    // MARK: - Debounce & Cancellation

    @Test("Rapid searches cancel previous tasks")
    func rapidSearchesCancelPrevious() async throws {
        let viewModel = makeViewModel()

        viewModel.searchText = "first"
        viewModel.performSearch()

        viewModel.searchText = "second"
        viewModel.performSearch()

        try await waitForDebounce()

        #expect(viewModel.recentSearches.contains { $0.query == "second" })
        #expect(!viewModel.recentSearches.contains { $0.query == "first" })
    }

    @Test("Search transitions to terminal status")
    func searchTransitionsToTerminalStatus() async throws {
        let viewModel = makeViewModel()
        viewModel.searchText = "test"
        viewModel.performSearch()

        try await waitForDebounce()

        switch viewModel.status {
        case .done, .error:
            break
        default:
            Issue.record("Expected .done or .error, got \(viewModel.status)")
        }
    }
}
