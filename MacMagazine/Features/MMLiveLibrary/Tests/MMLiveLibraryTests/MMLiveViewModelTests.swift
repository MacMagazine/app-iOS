import Foundation
@testable import MMLiveLibrary
import NetworkLibrary
import StorageLibrary
import Testing

@Suite("MMLiveViewModel Tests")
@MainActor
struct MMLiveViewModelTests {
    @Test("MMLive should complete successfully and save to UserDefaults")
    func getPodcastSuccess() async throws {
        // Given
        let mockData = [
            NetworkMockData(api: "/mmlive.json",
                            filename: "live",
                            bundlePath: Bundle.module.resourcePath)
        ]
        let mockNetwork = NetworkFactory.make(mapper: mockData)
        let storage = DefaultStorage("MMLiveTest")
        let sut = MMLiveViewModel(network: mockNetwork, storage: storage)

        // When
        let isLive = await sut.isLive()

        // Then
        #expect(!isLive)

        let saved = storage.get(key: "mmLive")
        #expect(saved != nil, "MMLive should be saved to UserDefaults")

        let isSaved = storage.get()
        #expect(isSaved?.inicio != nil, "MMLive should be saved to UserDefaults and parsed")
    }
}
