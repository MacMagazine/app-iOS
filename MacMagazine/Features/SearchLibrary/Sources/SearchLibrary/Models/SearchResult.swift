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
    let pubDate: Date
    var relevanceScore: Double
    let feedDB: FeedDB?
    let podcastDB: PodcastDB?
    let videoDB: VideoDB?

    init(
        id: String,
        type: SearchResultType,
        pubDate: Date,
        relevanceScore: Double,
        feedDB: FeedDB? = nil,
        podcastDB: PodcastDB? = nil,
        videoDB: VideoDB? = nil
    ) {
        self.id = id
        self.type = type
        self.pubDate = pubDate
        self.relevanceScore = relevanceScore
        self.feedDB = feedDB
        self.podcastDB = podcastDB
        self.videoDB = videoDB
    }
}

extension FeedDB {
    func toSearchResult(relevanceScore: Double = 0) -> SearchResult {
        SearchResult(
            id: postId,
            type: .news,
            pubDate: pubDate,
            relevanceScore: relevanceScore,
            feedDB: self
        )
    }
}

extension PodcastDB {
    func toSearchResult(relevanceScore: Double = 0) -> SearchResult {
        SearchResult(
            id: postId,
            type: .podcast,
            pubDate: pubDate,
            relevanceScore: relevanceScore,
            podcastDB: self
        )
    }
}

extension VideoDB {
    func toSearchResult(relevanceScore: Double = 0) -> SearchResult {
        SearchResult(
            id: videoId,
            type: .video,
            pubDate: pubDate.toDate(),
            relevanceScore: relevanceScore,
            videoDB: self
        )
    }
}
