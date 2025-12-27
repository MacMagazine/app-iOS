import FeedLibrary
import Foundation
import NetworkLibrary
@testable import NewsLibrary
import StorageLibrary
import Testing

@Suite("NewsViewModel Tests")
@MainActor
struct NewsViewModelTests {

    // MARK: - Status Tests

    @Test("Should start with idle status")
    func initialStatusIsIdle() async throws {
        // Given/When
        let storage = Database(models: [FeedDB.self, FeedDB.self], inMemory: true)
        let sut = NewsViewModel(storage: storage, mapper: [])

        // Then
        #expect(sut.status == .idle)
    }
}

// MARK: - Test Helpers

private func createMockNetwork() -> [NetworkMockData] {
    // Create mock network that returns valid podcast data
    // In a real scenario, you'd have a JSON fixture file
    [
        NetworkMockData(
            api: "/feed.xml",
            filename: "feed",
            bundlePath: Bundle.module.resourcePath
        )
    ]
}
