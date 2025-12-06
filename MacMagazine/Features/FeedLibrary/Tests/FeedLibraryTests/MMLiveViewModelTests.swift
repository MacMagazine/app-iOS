import Foundation
@testable import MMLiveLibrary
import NetworkLibrary
import StorageLibrary
import Testing

@Suite("MMLiveViewModel Tests")
@MainActor
struct MMLiveViewModelTests {

    @Test("getPodcast should complete successfully and save to database")
    func getPodcastSuccess() async throws {
        // Given
        let mockData = [
            NetworkMockData(api: "/feed/",
                            filename: "podcasts",
                            bundlePath: Bundle.module.resourcePath)
        ]
        let mockNetwork = NetworkFactory.make(mapper: mockData)
        let storage = Database(models: [PodcastDB.self], inMemory: true)
        let sut = FeedViewModel(network: mockNetwork, storage: storage)

        // When
        try await sut.getPodcast()

        // Then
        #expect(sut.status == .done)

        // Verify podcasts were saved
        let savedPodcasts = storage.fetch(PodcastDB.self)
        #expect(!savedPodcasts.isEmpty, "Podcasts should be saved to database")
    }

    @Test("getPodcast should save podcast details correctly")
    func getPodcastSavesToDatabase() async throws {
        // Given
        let mockData = [
            NetworkMockData(api: "/feed/",
                            filename: "podcasts",
                            bundlePath: Bundle.module.resourcePath)
        ]
        let mockNetwork = NetworkFactory.make(mapper: mockData)
        let storage = Database(models: [PodcastDB.self], inMemory: true)
        let sut = FeedViewModel(network: mockNetwork, storage: storage)

        // When
        try await sut.getPodcast()

        // Then
        let savedPodcasts = storage.fetch(PodcastDB.self)
        #expect(!savedPodcasts.isEmpty)

        let firstPodcast = try #require(savedPodcasts.first)
        #expect(!firstPodcast.postId.isEmpty)
        #expect(!firstPodcast.title.isEmpty)
    }
}
