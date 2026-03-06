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
    init(storage: Database) {
        self.feedViewModel = FeedViewModel(storage: storage)
    }

    @MainActor
    func search(term: String, page: Int = 0) async throws -> [SearchResult] {
        let (feedResults, podcastResults) = try await feedViewModel.searchAll(term: term, page: page)

        var results: [SearchResult] = []

        results += feedResults.map { feed in
            let type = resultType(for: feed.categories)
            let idPrefix = type == .video ? "remote_video" : "remote_news"
            return SearchResult(
                id: "\(idPrefix)_\(feed.postId)",
                type: type,
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

        results += podcastResults.map { podcast in
            SearchResult(
                id: "remote_podcast_\(podcast.postId)",
                type: .podcast,
                title: podcast.title,
                excerpt: podcast.subtitle,
                artworkURL: podcast.artworkURL,
                pubDate: podcast.pubDate,
                author: nil,
                link: podcast.link,
                categories: [],
                favorite: false,
                duration: podcast.duration,
                relevanceScore: 0,
                feedDB: nil,
                podcastDB: podcast,
                videoDB: nil
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
