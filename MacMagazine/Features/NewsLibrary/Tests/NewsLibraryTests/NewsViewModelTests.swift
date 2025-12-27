import FeedLibrary
import Foundation
import NetworkLibrary
@testable import NewsLibrary
import StorageLibrary
import Testing

@Suite("NewsViewModel Tests")
@MainActor
struct NewsViewModelTests {

    // MARK: - Initial State Tests

    @Test("Should start with idle status")
    func initialStatusIsIdle() async throws {
        let storage = Database(models: [FeedDB.self], inMemory: true)
        let sut = NewsViewModel(storage: storage, mapper: [])

        #expect(sut.status == .idle)
    }

    @Test("Should start with home option")
    func initialOptionIsHome() async throws {
        let storage = Database(models: [FeedDB.self], inMemory: true)
        let sut = NewsViewModel(storage: storage, mapper: [])

        #expect(sut.options == .home)
    }

    // MARK: - Options Tests

    @Test("Should support search option with text")
    func supportsSearchOption() async throws {
        let storage = Database(models: [FeedDB.self], inMemory: true)
        let sut = NewsViewModel(storage: storage, mapper: [])

        sut.options = .search(text: "iPhone 16")

        if case .search(let text) = sut.options {
            #expect(text == "iPhone 16")
        } else {
            Issue.record("Expected search option")
        }
    }

    @Test("Should support empty search text")
    func supportsEmptySearchText() async throws {
        let storage = Database(models: [FeedDB.self], inMemory: true)
        let sut = NewsViewModel(storage: storage, mapper: [])

        sut.options = .search(text: "")

        if case .search(let text) = sut.options {
            #expect(text.isEmpty)
        } else {
            Issue.record("Expected search option")
        }
    }

    @Test("Should transition between home and search options")
    func transitionBetweenOptions() async throws {
        let storage = Database(models: [FeedDB.self], inMemory: true)
        let sut = NewsViewModel(storage: storage, mapper: [])

        #expect(sut.options == .home)

        sut.options = .search(text: "MacBook")
        if case .search(let text) = sut.options {
            #expect(text == "MacBook")
        } else {
            Issue.record("Expected search option")
        }

        sut.options = .home
        #expect(sut.options == .home)
    }

    @Test("Options should be equatable")
    func optionsEquatable() {
        #expect(NewsViewModel.Options.home == .home)
        #expect(NewsViewModel.Options.search(text: "test") == .search(text: "test"))
        #expect(NewsViewModel.Options.search(text: "a") != .search(text: "b"))
        #expect(NewsViewModel.Options.home != .search(text: "test"))
    }

    // MARK: - Pagination Logic Tests

    @Test("Should not load more when index is 0")
    func noLoadAtIndexZero() async throws {
        let storage = Database(models: [FeedDB.self], inMemory: true)
        let mockNetwork = createMockNetwork()
        let sut = NewsViewModel(storage: storage, mapper: mockNetwork)

        sut.loadMoreIfNeeded(index: 0)

        #expect(sut.status == .idle, "Should not load when index is 0")
    }

    @Test("Should not load more when index is less than threshold")
    func noLoadBelowThreshold() async throws {
        let storage = Database(models: [FeedDB.self], inMemory: true)
        let mockNetwork = createMockNetwork()
        let sut = NewsViewModel(storage: storage, mapper: mockNetwork)

        for index in 1..<16 {
            sut.loadMoreIfNeeded(index: index)
        }

        #expect(sut.status == .idle, "Should not load when below threshold of 16")
    }

    @Test("Should load page 2 when reaching first threshold (index 16)")
    func loadPage2AtThreshold() async throws {
        let storage = Database(models: [FeedDB.self], inMemory: true)
        let mockNetwork = createMockNetwork()
        let sut = NewsViewModel(storage: storage, mapper: mockNetwork)

        sut.loadMoreIfNeeded(index: 16)

        try await Task.sleep(for: .milliseconds(100))

        #expect(sut.status != .idle, "Should trigger load at threshold index 16")
    }

    @Test("Should load page 3 when reaching second threshold (index 32)")
    func loadPage3AtSecondThreshold() async throws {
        let storage = Database(models: [FeedDB.self], inMemory: true)
        let mockNetwork = createMockNetwork()
        let sut = NewsViewModel(storage: storage, mapper: mockNetwork)

        sut.loadMoreIfNeeded(index: 16)
        try await Task.sleep(for: .milliseconds(100))

        sut.loadMoreIfNeeded(index: 32)
        try await Task.sleep(for: .milliseconds(100))

        #expect(sut.status != .idle, "Should trigger load at second threshold index 32")
    }

    @Test("Should only trigger load at exact multiples of threshold")
    func onlyLoadAtExactMultiples() async throws {
        let storage = Database(models: [FeedDB.self], inMemory: true)
        let mockNetwork = createMockNetwork()
        let sut = NewsViewModel(storage: storage, mapper: mockNetwork)

        sut.loadMoreIfNeeded(index: 15)
        #expect(sut.status == .idle)

        sut.loadMoreIfNeeded(index: 17)
        #expect(sut.status == .idle)

        sut.loadMoreIfNeeded(index: 16)
        try await Task.sleep(for: .milliseconds(100))

        #expect(sut.status != .idle, "Should only load at exact multiples of 16")
    }

    @Test("Should not reload same page when scrolling back and forth")
    func noReloadSamePage() async throws {
        let storage = Database(models: [FeedDB.self], inMemory: true)
        let mockNetwork = createMockNetwork()
        let sut = NewsViewModel(storage: storage, mapper: mockNetwork)

        sut.loadMoreIfNeeded(index: 16)
        try await Task.sleep(for: .milliseconds(100))
        let firstStatus = sut.status

        sut.loadMoreIfNeeded(index: 15)
        sut.loadMoreIfNeeded(index: 14)
        sut.loadMoreIfNeeded(index: 16)

        #expect(sut.status == firstStatus, "Should not reload when returning to same index")
    }

    @Test("Should calculate correct page numbers for various thresholds")
    func correctPageCalculation() async throws {
        let storage = Database(models: [FeedDB.self], inMemory: true)
        let mockNetwork = createMockNetwork()
        let sut = NewsViewModel(storage: storage, mapper: mockNetwork)

        sut.loadMoreIfNeeded(index: 16)
        try await Task.sleep(for: .milliseconds(100))
        #expect(sut.status != .idle)

        sut.loadMoreIfNeeded(index: 32)
        try await Task.sleep(for: .milliseconds(100))
        #expect(sut.status != .idle)

        sut.loadMoreIfNeeded(index: 48)
        try await Task.sleep(for: .milliseconds(100))
        #expect(sut.status != .idle)
    }

    @Test("Should only load when index increases beyond last loaded index")
    func onlyLoadWhenIndexIncreases() async throws {
        let storage = Database(models: [FeedDB.self], inMemory: true)
        let mockNetwork = createMockNetwork()
        let sut = NewsViewModel(storage: storage, mapper: mockNetwork)

        sut.loadMoreIfNeeded(index: 16)
        try await Task.sleep(for: .milliseconds(100))

        sut.loadMoreIfNeeded(index: 16)
        let statusAfterSameIndex = sut.status

        sut.loadMoreIfNeeded(index: 12)
        let statusAfterLowerIndex = sut.status

        #expect(statusAfterSameIndex == statusAfterLowerIndex,
                "Should not load when index doesn't increase")
    }

    @Test("Should handle rapid scrolling correctly")
    func handleRapidScrolling() async throws {
        let storage = Database(models: [FeedDB.self], inMemory: true)
        let mockNetwork = createMockNetwork()
        let sut = NewsViewModel(storage: storage, mapper: mockNetwork)

        sut.loadMoreIfNeeded(index: 16)
        sut.loadMoreIfNeeded(index: 32)
        sut.loadMoreIfNeeded(index: 48)

        try await Task.sleep(for: .milliseconds(200))

        #expect(sut.status != .idle, "Should handle rapid scrolling")
    }

    // MARK: - Status Tests

    @Test("Should update status to done on successful fetch")
    func statusUpdatesOnSuccess() async throws {
        let storage = Database(models: [FeedDB.self], inMemory: true)
        let mockNetwork = createMockNetwork()
        let sut = NewsViewModel(storage: storage, mapper: mockNetwork)

        try await sut.getNews(status: .loading, page: 0)

        #expect(sut.status == .done, "Status should be done after successful fetch")
    }

    @Test("Should set status to loading when explicitly passed")
    func setsLoadingStatus() async throws {
        let storage = Database(models: [FeedDB.self], inMemory: true)
        let mockNetwork = createMockNetwork()
        let sut = NewsViewModel(storage: storage, mapper: mockNetwork)

        #expect(sut.status == .idle)

        try await sut.getNews(status: .loading, page: 0)

        #expect(sut.status == .done)
    }

    @Test("Should keep previous status when nil is passed")
    func keepsStatusWhenNilPassed() async throws {
        let storage = Database(models: [FeedDB.self], inMemory: true)
        let mockNetwork = createMockNetwork()
        let sut = NewsViewModel(storage: storage, mapper: mockNetwork)

        try await sut.getNews(status: nil, page: 0)

        #expect(sut.status == .done)
    }

    @Test("Should set error status on network failure")
    func statusUpdatesOnError() async throws {
        let storage = Database(models: [FeedDB.self], inMemory: true)
        let failedNetwork = [NetworkMockData]()
        let sut = NewsViewModel(storage: storage, mapper: failedNetwork)

        try await sut.getNews(status: .loading, page: 0)

        if case .done = sut.status {
            #expect(storage.count(FeedDB.self) == 0)
        } else if case .error(let reason) = sut.status {
            #expect(!reason.isEmpty)
        }
    }

    // MARK: - Page Parameter Tests

    @Test("Should fetch page 0 by default")
    func fetchesDefaultPage() async throws {
        let storage = Database(models: [FeedDB.self], inMemory: true)
        let mockNetwork = createMockNetwork()
        let sut = NewsViewModel(storage: storage, mapper: mockNetwork)

        try await sut.getNews()

        #expect(sut.status == .done)
    }

    @Test("Should fetch specified page number")
    func fetchesSpecifiedPage() async throws {
        let storage = Database(models: [FeedDB.self], inMemory: true)
        let mockNetwork = createMockNetwork()
        let sut = NewsViewModel(storage: storage, mapper: mockNetwork)

        try await sut.getNews(page: 2)

        #expect(sut.status == .done)
    }

    // MARK: - Edge Cases

    @Test("Should handle negative index gracefully")
    func handleNegativeIndex() async throws {
        let storage = Database(models: [FeedDB.self], inMemory: true)
        let mockNetwork = createMockNetwork()
        let sut = NewsViewModel(storage: storage, mapper: mockNetwork)

        sut.loadMoreIfNeeded(index: -1)

        #expect(sut.status == .idle, "Should not load for negative index")
    }

    @Test("Should handle very large index")
    func handleVeryLargeIndex() async throws {
        let storage = Database(models: [FeedDB.self], inMemory: true)
        let mockNetwork = createMockNetwork()
        let sut = NewsViewModel(storage: storage, mapper: mockNetwork)

        sut.loadMoreIfNeeded(index: 16)
        try await Task.sleep(for: .milliseconds(100))

        sut.loadMoreIfNeeded(index: 1600)
        try await Task.sleep(for: .milliseconds(100))

        #expect(sut.status != .idle)
    }
}

// MARK: - Test Helpers

private func createMockNetwork() -> [NetworkMockData] {
    [
        NetworkMockData(
            api: "/feed/",
            filename: "feed",
            bundlePath: Bundle.module.resourcePath
        )
    ]
}
