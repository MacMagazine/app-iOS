import Foundation
@testable import SearchLibrary
import StorageLibrary
import Testing

@Suite("SearchViewModel Tests")
@MainActor
struct SearchViewModelTests {

    func makeViewModel() -> SearchViewModel {
        let storage = Database(
            models: [RecentSearchDB.self],
            inMemory: true
        )
        return SearchViewModel(storage: storage)
    }

    /// Waits for the search task to finish (debounce + remote).
    private func waitForSearch() async throws {
        try await Task.sleep(for: .seconds(3))
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

        try await waitForSearch()

        #expect(!viewModel.recentSearches.isEmpty)
        #expect(viewModel.recentSearches.first?.query == "iPhone test")
    }

    @Test("clearRecentSearches removes all history")
    func clearRecentSearches() async throws {
        let viewModel = makeViewModel()

        viewModel.searchText = "test query"
        viewModel.performSearch()
        try await waitForSearch()
        #expect(!viewModel.recentSearches.isEmpty)

        viewModel.clearRecentSearches()
        #expect(viewModel.recentSearches.isEmpty)
    }

    @Test("removeRecentSearch removes specific entry")
    func removeSpecificRecentSearch() async throws {
        let viewModel = makeViewModel()

        viewModel.searchText = "first query"
        viewModel.performSearch()
        try await waitForSearch()

        viewModel.searchText = "second query"
        viewModel.performSearch()
        try await waitForSearch()

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

        // Immediately start another search before debounce finishes
        viewModel.searchText = "second"
        viewModel.performSearch()

        try await waitForSearch()

        // Only the second search should have completed
        #expect(viewModel.recentSearches.contains { $0.query == "second" })
        #expect(!viewModel.recentSearches.contains { $0.query == "first" })
    }

    @Test("Search transitions to terminal status")
    func searchTransitionsToTerminalStatus() async throws {
        let viewModel = makeViewModel()
        viewModel.searchText = "test"
        viewModel.performSearch()

        try await waitForSearch()

        // Should be done or error (error expected with no real API)
        switch viewModel.status {
        case .done, .error:
            break
        default:
            Issue.record("Expected .done or .error, got \(viewModel.status)")
        }
    }
}
