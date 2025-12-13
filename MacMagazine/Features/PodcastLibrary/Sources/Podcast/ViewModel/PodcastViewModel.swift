import Combine
import FeedLibrary
import Foundation
import NetworkLibrary
import StorageLibrary
import SwiftData
import UIComponentsLibrary

@Observable
class PodcastViewModel {
    var options: Options = .home
    var status: APIStatus = .idle

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
    func getPodcasts(status: APIStatus? = nil) async throws {
        do {
            if let status {
                self.status = status
            }
            try await feedService.getPodcast()
            self.status = .done
        } catch {
            self.status = .error(reason: error.localizedDescription)
        }
    }
}
