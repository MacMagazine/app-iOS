import Combine
import FeedLibrary
import Foundation
import NetworkLibrary
import StorageLibrary
import SwiftData
import UIComponentsLibrary

@Observable
class NewsViewModel {
    var options: Options = .home
    var status: APIStatus = .idle
    var selectedNews: FeedDB? = nil

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
    func getNews(status: APIStatus? = nil, page: Int = 0) async throws {
        do {
            if let status {
                self.status = status
            }
            try await feedService.getFeed(page: page)
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
                try await getNews(status: nil, page: page)
            }
        }
    }
}
