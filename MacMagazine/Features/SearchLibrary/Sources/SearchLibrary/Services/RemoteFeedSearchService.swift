import FeedLibrary
import Foundation
import StorageLibrary

struct RemoteFeedSearchService {
    private let feedViewModel: FeedViewModel

    @MainActor
    init(storage: Database) {
        self.feedViewModel = FeedViewModel(storage: storage)
    }

    @MainActor
    func search(term: String, page: Int = 0) async throws -> [SearchResult] {
        let feedResults = try await feedViewModel.searchFeed(term: term, page: page)
        return feedResults.map { feed in
            SearchResult(
                id: "remote_news_\(feed.postId)",
                type: .news,
                title: feed.title,
                excerpt: feed.excerpt,
                artworkURL: feed.artworkURL,
                pubDate: feed.pubDate,
                author: feed.author,
                link: feed.link,
                categories: feed.categories,
                favorite: false,
                duration: nil,
                relevanceScore: 0,
                feedDB: nil,
                podcastDB: nil,
                videoDB: nil
            )
        }
    }
}
