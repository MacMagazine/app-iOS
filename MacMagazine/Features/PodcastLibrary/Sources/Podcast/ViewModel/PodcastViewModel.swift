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
    private let threshold = 16
    private var lastIndex = 0

    @MainActor
    init(storage: Database,
         mapper: [NetworkMockData]? = nil) {
        self.feedService = .init(
            network: NetworkFactory.make(mapper: mapper),
            storage: storage
        )
    }

    @MainActor
    func getPodcasts(status: APIStatus? = nil, page: Int = 1) async throws {
        do {
            if let status {
                self.status = status
            }
            try await feedService.getPodcast(page: page)
            self.status = .done
        } catch {
            self.status = .error(reason: error.localizedDescription)
        }
    }

    @MainActor
    func loadMoreIfNeeded(index: Int) {
        if index > 0,
           lastIndex <= index,
           index % threshold == 0 {
            lastIndex = index
            let page = Int(index / threshold) + 1
            Task {
                try await getPodcasts(status: nil, page: page)
            }
        }
    }
}
