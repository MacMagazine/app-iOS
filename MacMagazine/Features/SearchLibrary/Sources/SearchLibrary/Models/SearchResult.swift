import FeedLibrary
import Foundation
import YouTubeLibrary

enum SearchResultType: Sendable {
    case news
    case podcast
    case video
}

struct SearchResult: Identifiable {
    let id: String
    let type: SearchResultType
    let title: String
    let excerpt: String
    let artworkURL: String
    let pubDate: Date
    let author: String?
    let link: String
    let categories: [String]
    let favorite: Bool
    let duration: String?
    var relevanceScore: Double

    let feedDB: FeedDB?
    let podcastDB: PodcastDB?
    let videoDB: VideoDB?
}

extension FeedDB {
    func toSearchResult(relevanceScore: Double = 0) -> SearchResult {
        SearchResult(
            id: "news_\(postId)",
            type: .news,
            title: title,
            excerpt: excerpt,
            artworkURL: artworkURL,
            pubDate: pubDate,
            author: author,
            link: link,
            categories: categories,
            favorite: favorite,
            duration: nil,
            relevanceScore: relevanceScore,
            feedDB: self,
            podcastDB: nil,
            videoDB: nil
        )
    }
}

extension PodcastDB {
    func toSearchResult(relevanceScore: Double = 0) -> SearchResult {
        SearchResult(
            id: "podcast_\(postId)",
            type: .podcast,
            title: title,
            excerpt: subtitle,
            artworkURL: artworkURL,
            pubDate: pubDate,
            author: nil,
            link: link,
            categories: [],
            favorite: favorite,
            duration: duration,
            relevanceScore: relevanceScore,
            feedDB: nil,
            podcastDB: self,
            videoDB: nil
        )
    }
}

extension VideoDB {
    func toSearchResult(relevanceScore: Double = 0) -> SearchResult {
        SearchResult(
            id: "video_\(videoId)",
            type: .video,
            title: title,
            excerpt: "",
            artworkURL: artworkURL,
            pubDate: pubDate.toDate(),
            author: nil,
            link: "https://www.youtube.com/watch?v=\(videoId)",
            categories: [],
            favorite: favorite,
            duration: duration.formattedYTDuration,
            relevanceScore: relevanceScore,
            feedDB: nil,
            podcastDB: nil,
            videoDB: self
        )
    }
}
