import FeedLibrary
import Foundation
import MacMagazineLibrary
import StorageLibrary

protocol RemoteSearchServiceProtocol {
    @MainActor func search(term: String, page: Int) async throws -> [SearchResult]
}

struct RemoteFeedSearchService: RemoteSearchServiceProtocol {
    private let feedViewModel: FeedViewModel

    @MainActor
    init(feedViewModel: FeedViewModel) {
        self.feedViewModel = feedViewModel
    }

    @MainActor
    init(storage: Database) {
        self.init(feedViewModel: FeedViewModel(storage: storage))
    }

    @MainActor
    func search(term: String, page: Int = 0) async throws -> [SearchResult] {
        let (feedResults, podcastResults) = try await feedViewModel.search(term: term, page: page)

        var results: [SearchResult] = []

        results += feedResults.map { feed in
            let type = resultType(for: feed.categories)
            return SearchResult(
                id: feed.postId,
                type: type,
                pubDate: feed.pubDate,
                relevanceScore: 0,
                feedDB: feed,
                videoDB: nil
            )
        }

        results += podcastResults.map { podcast in
            SearchResult(
                id: podcast.postId,
                type: .podcast,
                pubDate: podcast.pubDate,
                relevanceScore: 0,
                podcastDB: podcast
            )
        }

        return results
    }
}

private extension RemoteFeedSearchService {
    func resultType(for categories: [String]) -> SearchResultType {
        let isVideo = categories.contains { category in
            category == NewsCategory.youtube.filterKey || category == NewsCategory.youtube.rawValue
        }
        if isVideo { return .video }

        return .news
    }
}
