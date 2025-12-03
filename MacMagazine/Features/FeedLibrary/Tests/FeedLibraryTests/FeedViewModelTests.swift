import Testing
import Foundation
import NetworkLibrary
import StorageLibrary
@testable import FeedLibrary

@Suite("FeedViewModel Tests")
@MainActor
struct FeedViewModelTests {

    // MARK: - getNews Tests

    @Test("getNews should complete successfully with valid data")
    func getNewsSuccess() async throws {
        // Given
        let mockData = [
            NetworkMockData(api: "/feed/",
                            filename: "feed",
                            bundlePath: Bundle.module.resourcePath)
        ]
        let mockNetwork = NetworkFactory.make(mapper: mockData)
        let storage = Database(models: [PodcastDB.self], inMemory: true)
        let sut = FeedViewModel(network: mockNetwork, storage: storage)

        // When
        try await sut.getNews()

        // Then
        #expect(sut.status == .done)
        #expect(sut.status.reason == nil)
    }

    @Test("getNews should set error status on network failure")
    func getNewsNetworkFailure() async throws {
        // Given
        let failedNetwork = NetworkFailed()
        let storage = Database(models: [PodcastDB.self], inMemory: true)
        let sut = FeedViewModel(network: failedNetwork, storage: storage)

        // When
        try await sut.getNews()

        // Then
        #expect(sut.status != .done)
        if case .error(let reason) = sut.status {
            #expect(!reason.isEmpty)
        } else {
            Issue.record("Expected error status")
        }
    }

    @Test("getNews should transition from loading to done")
    func getNewsStatusTransitions() async throws {
        // Given
        let mockData = [
            NetworkMockData(api: "/feed/",
                            filename: "feed",
                            bundlePath: Bundle.module.resourcePath)
        ]
        let mockNetwork = NetworkFactory.make(mapper: mockData)
        let storage = Database(models: [PodcastDB.self], inMemory: true)
        let sut = FeedViewModel(network: mockNetwork, storage: storage)

        // Initial status should be loading
        #expect(sut.status == .loading)

        // When
        try await sut.getNews()

        // Then - should transition to done
        #expect(sut.status == .done)
    }

    // MARK: - getPodcast Tests

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
        #expect(savedPodcasts.count > 0)

        let firstPodcast = try #require(savedPodcasts.first)
        #expect(!firstPodcast.postId.isEmpty)
        #expect(!firstPodcast.title.isEmpty)
    }

    @Test("getPodcast should set error status on network failure")
    func getPodcastNetworkFailure() async throws {
        // Given
        let failedNetwork = NetworkFailed()
        let storage = Database(models: [PodcastDB.self], inMemory: true)
        let sut = FeedViewModel(network: failedNetwork, storage: storage)

        // When
        try await sut.getPodcast()

        // Then
        #expect(sut.status != .done)

        let savedPodcasts = storage.fetch(PodcastDB.self)
        #expect(savedPodcasts.isEmpty, "No podcasts should be saved on failure")
    }

    // MARK: - Status Tests

    @Test("Status reason should return nil for loading and done")
    func statusReasonReturnsNilForLoadingAndDone() {
        #expect(FeedViewModel.Status.loading.reason == nil)
        #expect(FeedViewModel.Status.done.reason == nil)
    }

    @Test("Status reason should return error message")
    func statusReasonReturnsErrorMessage() {
        let errorMessage = "Network error"
        let errorStatus = FeedViewModel.Status.error(reason: errorMessage)
        #expect(errorStatus.reason == errorMessage)
    }

    @Test("Status equality should work correctly")
    func statusEquality() {
        #expect(FeedViewModel.Status.loading == .loading)
        #expect(FeedViewModel.Status.done == .done)
        #expect(FeedViewModel.Status.error(reason: "test") == .error(reason: "test"))
        #expect(FeedViewModel.Status.error(reason: "test1") != .error(reason: "test2"))
    }
}
