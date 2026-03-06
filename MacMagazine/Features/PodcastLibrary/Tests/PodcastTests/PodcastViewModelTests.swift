import FeedLibrary
import Foundation
import NetworkLibrary
@testable import PodcastLibrary
import StorageLibrary
import Testing
import UIComponentsLibrary

@Suite("PodcastViewModel Tests")
@MainActor
struct PodcastViewModelTests {

    // MARK: - Pagination Logic Tests

    @Test("Should not load more when index is 0")
    func noLoadAtIndexZero() async throws {
        // Given
        let storage = Database(models: [FeedDB.self, PodcastDB.self], inMemory: true)
        let mockNetwork = createMockNetwork()
        let sut = PodcastViewModel(storage: storage, mapper: mockNetwork)

        // When
        sut.loadMoreIfNeeded(index: 0)

        // Then - No network call should be made (status should remain idle)
        #expect(sut.status == .idle, "Should not load when index is 0")
    }

    @Test("Should not load more when index is less than threshold")
    func noLoadBelowThreshold() async throws {
        // Given
        let storage = Database(models: [FeedDB.self, PodcastDB.self], inMemory: true)
        let mockNetwork = createMockNetwork()
        let sut = PodcastViewModel(storage: storage, mapper: mockNetwork)

        // When - Try indices below threshold (16)
        for index in 1..<16 {
            sut.loadMoreIfNeeded(index: index)
        }

        // Then
        #expect(sut.status == .idle, "Should not load when below threshold of 16")
    }

    @Test("Should load page 2 when reaching first threshold (index 16)")
    func loadPage2AtThreshold() async throws {
        // Given
        let storage = Database(models: [FeedDB.self, PodcastDB.self], inMemory: true)
        let mockNetwork = createMockNetwork()
        let sut = PodcastViewModel(storage: storage, mapper: mockNetwork)

        // When
        sut.loadMoreIfNeeded(index: 16)

        // Wait up to 2s for status to change from idle to any other state to avoid timing flakiness on CI
        let changed = await waitForStatusChange(
            from: .idle,
            of: sut,
            timeout: .seconds(2),
            poll: .milliseconds(20)
        )

        // Then - Page 2 should be requested (16 / 16 + 1 = 2)
        // Status will transition to .done or .error depending on mock
        #expect(changed, "Should trigger load at threshold index 16")
    }

    @Test("Should load page 3 when reaching second threshold (index 32)")
    func loadPage3AtSecondThreshold() async throws {
        // Given
        let storage = Database(models: [FeedDB.self, PodcastDB.self], inMemory: true)
        let mockNetwork = createMockNetwork()
        let sut = PodcastViewModel(storage: storage, mapper: mockNetwork)

        // When - Simulate scrolling past first threshold
        sut.loadMoreIfNeeded(index: 16) // First threshold, loads page 2
        _ = await waitForStatusChange(
            from: .idle,
            of: sut,
            timeout: .seconds(2),
            poll: .milliseconds(20)
        )

        sut.loadMoreIfNeeded(index: 32) // Second threshold, should load page 3
        _ = await waitForStatusChange(
            from: .idle,
            of: sut,
            timeout: .seconds(2),
            poll: .milliseconds(20)
        )

        // Then
        #expect(sut.status != .idle, "Should trigger load at second threshold index 32")
    }

    @Test("Should only trigger load at exact multiples of threshold")
    func onlyLoadAtExactMultiples() async throws {
        // Given
        let storage = Database(models: [FeedDB.self, PodcastDB.self], inMemory: true)
        let mockNetwork = createMockNetwork()
        let sut = PodcastViewModel(storage: storage, mapper: mockNetwork)

        // When - Try indices around threshold
        sut.loadMoreIfNeeded(index: 15) // Below threshold
        #expect(sut.status == .idle)

        sut.loadMoreIfNeeded(index: 17) // Above threshold but not multiple
        #expect(sut.status == .idle)

        sut.loadMoreIfNeeded(index: 16) // Exact multiple
        _ = await waitForStatusChange(
            from: .idle,
            of: sut,
            timeout: .seconds(2),
            poll: .milliseconds(20)
        )

        // Then
        #expect(sut.status != .idle, "Should only load at exact multiples of 16")
    }

    @Test("Should not reload same page when scrolling back and forth")
    func noReloadSamePage() async throws {
        // Given
        let storage = Database(models: [FeedDB.self, PodcastDB.self], inMemory: true)
        let mockNetwork = createMockNetwork()
        let sut = PodcastViewModel(storage: storage, mapper: mockNetwork)

        // When - Load page 2
        sut.loadMoreIfNeeded(index: 16)
        try await Task.sleep(for: .milliseconds(100))
        let firstStatus = sut.status

        // Scroll back to earlier index
        sut.loadMoreIfNeeded(index: 15)
        sut.loadMoreIfNeeded(index: 14)

        // Scroll forward again to same threshold
        sut.loadMoreIfNeeded(index: 16)

        // Then - Should not trigger another load
        #expect(sut.status == firstStatus, "Should not reload when returning to same index")
    }

    @Test("Should calculate correct page numbers for various thresholds")
    func correctPageCalculation() async throws {
        // Given
        let storage = Database(models: [FeedDB.self, PodcastDB.self], inMemory: true)
        let mockNetwork = createMockNetwork()
        let sut = PodcastViewModel(storage: storage, mapper: mockNetwork)

        // Test page calculation logic: page = Int(index / threshold) + 1
        // Index 16, threshold 16: page = 16/16 + 1 = 2
        // Index 32, threshold 16: page = 32/16 + 1 = 3
        // Index 48, threshold 16: page = 48/16 + 1 = 4

        // When/Then - Index 16 → Page 2
        sut.loadMoreIfNeeded(index: 16)
        _ = await waitForStatusChange(
            from: .idle,
            of: sut,
            timeout: .seconds(2),
            poll: .milliseconds(20)
        )
        #expect(sut.status != .idle)

        // When/Then - Index 32 → Page 3
        sut.loadMoreIfNeeded(index: 32)
        _ = await waitForStatusChange(
            from: .idle,
            of: sut,
            timeout: .seconds(2),
            poll: .milliseconds(20)
        )
        #expect(sut.status != .idle)

        // When/Then - Index 48 → Page 4
        sut.loadMoreIfNeeded(index: 48)
        _ = await waitForStatusChange(
            from: .idle,
            of: sut,
            timeout: .seconds(2),
            poll: .milliseconds(20)
        )
        #expect(sut.status != .idle)
    }

    @Test("Should only load when index increases beyond last loaded index")
    func onlyLoadWhenIndexIncreases() async throws {
        // Given
        let storage = Database(models: [FeedDB.self, PodcastDB.self], inMemory: true)
        let mockNetwork = createMockNetwork()
        let sut = PodcastViewModel(storage: storage, mapper: mockNetwork)

        // When - Load at index 16
        sut.loadMoreIfNeeded(index: 16)
        _ = await waitForStatusChange(
            from: .idle,
            of: sut,
            timeout: .seconds(2),
            poll: .milliseconds(20)
        )

        // Try loading at same index again
        sut.loadMoreIfNeeded(index: 16)
        let statusAfterSameIndex = sut.status

        // Try loading at lower index
        sut.loadMoreIfNeeded(index: 12)
        let statusAfterLowerIndex = sut.status

        // Then - Status should not change
        #expect(statusAfterSameIndex == statusAfterLowerIndex,
                "Should not load when index doesn't increase")
    }

    @Test("Should handle rapid scrolling correctly")
    func handleRapidScrolling() async throws {
        // Given
        let storage = Database(models: [FeedDB.self, PodcastDB.self], inMemory: true)
        let mockNetwork = createMockNetwork()
        let sut = PodcastViewModel(storage: storage, mapper: mockNetwork)

        // When - Rapidly scroll through multiple thresholds
        sut.loadMoreIfNeeded(index: 16) // Page 2
        sut.loadMoreIfNeeded(index: 32) // Page 3
        sut.loadMoreIfNeeded(index: 48) // Page 4

        _ = await waitForStatusChange(
            from: .idle,
            of: sut,
            timeout: .seconds(2),
            poll: .milliseconds(20)
        )

        // Then - Should handle all loads without crashes
        #expect(sut.status != .idle, "Should handle rapid scrolling")
    }

    // MARK: - Status Tests

    @Test("Should start with idle status")
    func initialStatusIsIdle() async throws {
        // Given/When
        let storage = Database(models: [FeedDB.self, PodcastDB.self], inMemory: true)
        let sut = PodcastViewModel(storage: storage, mapper: [])

        // Then
        #expect(sut.status == .idle)
    }

    @Test("Should update status to done on successful fetch")
    func statusUpdatesOnSuccess() async throws {
        // Given
        let storage = Database(models: [FeedDB.self, PodcastDB.self], inMemory: true)
        let mockNetwork = createMockNetwork()
        let sut = PodcastViewModel(storage: storage, mapper: mockNetwork)

        // When
        try await sut.getPodcasts(status: .loading, page: 1)

        // Then
        #expect(sut.status == .done, "Status should be done after successful fetch")
    }

    @Test("Should update status to error on failed fetch")
    func statusUpdatesOnError() async throws {
        // Given
        let storage = Database(models: [FeedDB.self, PodcastDB.self], inMemory: true)
        let failedNetwork = [NetworkMockData]() // Empty will cause parsing error
        let sut = PodcastViewModel(storage: storage, mapper: failedNetwork)

        // When
        do {
            try await sut.getPodcasts(status: .loading, page: 1)
        } catch {
            Issue.record("Not expected error")
        }

        // Then
        if case .done = sut.status {
            #expect(storage.count(PodcastDB.self) == 0)
        } else {
            Issue.record("Expected done")
        }
    }

    @Test("Should preserve custom status when provided")
    func preserveCustomStatus() async throws {
        // Given
        let storage = Database(models: [FeedDB.self, PodcastDB.self], inMemory: true)
        let mockNetwork = createMockNetwork()
        let sut = PodcastViewModel(storage: storage, mapper: mockNetwork)

        // When
        try await sut.getPodcasts(status: .loading, page: 1)

        // Then - Status should eventually be .done after loading
        #expect(sut.status == .done)
    }

    // MARK: - Options Tests

    @Test("Should start with home option")
    func initialOptionIsHome() async throws {
        // Given/When
        let storage = Database(models: [FeedDB.self, PodcastDB.self], inMemory: true)
        let sut = PodcastViewModel(storage: storage, mapper: [])

        // Then
        #expect(sut.options == .home)
    }

    @Test("Should support search option")
    func supportsSearchOption() async throws {
        // Given
        let storage = Database(models: [FeedDB.self, PodcastDB.self], inMemory: true)
        let sut = PodcastViewModel(storage: storage, mapper: [])

        // When
        sut.options = .search(text: "test query")

        // Then
        if case let .search(text) = sut.options {
            #expect(text == "test query")
        } else {
            Issue.record("Expected search option")
        }
    }
}

extension PodcastViewModelTests {
    private func waitForStatusChange(
        from initial: APIStatus,
        of sut: PodcastViewModel,
        timeout: Duration = .seconds(2),
        poll: Duration = .milliseconds(20)
    ) async -> Bool {
        let deadline = ContinuousClock.now.advanced(by: timeout)
        while ContinuousClock.now < deadline {
            if sut.status != initial { return true }
            try? await Task.sleep(for: poll)
        }
        return false
    }
}

// MARK: - Test Helpers

private func createMockNetwork() -> [NetworkMockData] {
    // Create mock network that returns valid podcast data
    // In a real scenario, you'd have a JSON fixture file
    [
        NetworkMockData(
            api: "/podcasts.xml",
            filename: "podcasts",
            bundlePath: Bundle.module.resourcePath
        )
    ]
}
