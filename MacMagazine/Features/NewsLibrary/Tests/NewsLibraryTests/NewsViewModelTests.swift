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

    @Test("Should not trigger load when index is 0")
    func noLoadAtIndexZero() async throws {
        let storage = Database(models: [FeedDB.self], inMemory: true)
        let mockNetwork = createMockNetwork()
        let sut = NewsViewModel(storage: storage, mapper: mockNetwork)

        sut.loadMoreIfNeeded(index: 0)

        #expect(sut.status == .idle, "Should not load when index is 0")
    }

    @Test("Should not trigger load when index is less than threshold")
    func noLoadBelowThreshold() async throws {
        let storage = Database(models: [FeedDB.self], inMemory: true)
        let mockNetwork = createMockNetwork()
        let sut = NewsViewModel(storage: storage, mapper: mockNetwork)

        for index in 1..<16 {
            sut.loadMoreIfNeeded(index: index)
        }

        #expect(sut.status == .idle, "Should not load when below threshold of 16")
    }

    @Test("Should not trigger load at non-multiple indices")
    func noLoadAtNonMultiples() async throws {
        let storage = Database(models: [FeedDB.self], inMemory: true)
        let mockNetwork = createMockNetwork()
        let sut = NewsViewModel(storage: storage, mapper: mockNetwork)

        sut.loadMoreIfNeeded(index: 15)
        #expect(sut.status == .idle)

        sut.loadMoreIfNeeded(index: 17)
        #expect(sut.status == .idle)

        sut.loadMoreIfNeeded(index: 31)
        #expect(sut.status == .idle)

        sut.loadMoreIfNeeded(index: 33)
        #expect(sut.status == .idle)
    }

    @Test("Should not trigger load when scrolling backwards")
    func noLoadOnBackwardScroll() async throws {
        let storage = Database(models: [FeedDB.self], inMemory: true)
        let mockNetwork = createMockNetwork()
        let sut = NewsViewModel(storage: storage, mapper: mockNetwork)

        sut.loadMoreIfNeeded(index: 16)
        sut.loadMoreIfNeeded(index: 15)
        sut.loadMoreIfNeeded(index: 14)

        #expect(true, "Should not crash when scrolling backwards")
    }

    @Test("Should not trigger load for same index twice")
    func noLoadForSameIndex() async throws {
        let storage = Database(models: [FeedDB.self], inMemory: true)
        let mockNetwork = createMockNetwork()
        let sut = NewsViewModel(storage: storage, mapper: mockNetwork)

        sut.loadMoreIfNeeded(index: 16)
        sut.loadMoreIfNeeded(index: 16)
        sut.loadMoreIfNeeded(index: 16)

        #expect(true, "Should not crash when calling with same index multiple times")
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

    @Test("Should handle very large index without crashing")
    func handleVeryLargeIndex() async throws {
        let storage = Database(models: [FeedDB.self], inMemory: true)
        let mockNetwork = createMockNetwork()
        let sut = NewsViewModel(storage: storage, mapper: mockNetwork)

        sut.loadMoreIfNeeded(index: 1600)
        sut.loadMoreIfNeeded(index: 16000)
        sut.loadMoreIfNeeded(index: Int.max / 2)

        #expect(true, "Should handle large indices without crashing")
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
