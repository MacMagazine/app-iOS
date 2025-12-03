import Combine
import FeedLibrary
import Foundation
import NetworkLibrary
import StorageLibrary

@Observable
class PodcastViewModel {
    var options: Options = .home
    var status: Status = .loading

    enum Status: Equatable {
        case loading
        case done
        case error(reason: String)

        var reason: String? {
            switch self {
            case .error(let reason): reason
            default: nil
            }
        }
    }

    enum Options: Equatable {
        case home
        case search(text: String)
    }

    private let feedService: FeedViewModel

    @MainActor
    init(storage: Database,
         mapper: [NetworkMockData]? = nil) {
        self.feedService = .init(
            network: NetworkFactory.make(mapper: mapper),
            storage: storage
        )
    }

    @MainActor
    func getPodcasts() async throws {
        try await feedService.getPodcast()
    }
}
