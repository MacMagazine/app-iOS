import AnalyticsLibrary
import Foundation
import MacMagazineLibrary

public enum CardContentType {
    case video(views: String, likes: String, duration: String)
    case podcast(duration: String)
    case news(category: NewsCategory)

    public var duration: String {
        switch self {
        case let .video(_, _, duration): duration
        case let .podcast(duration): duration
        case .news: ""
        }
    }

    var category: NewsCategory {
        switch self {
        case let .news(category): category
        case .podcast: .podcast
        case .video: .youtube
        }
    }

    var views: String? {
        switch self {
        case let .video(views, _, _): views
        case .podcast, .news: nil
        }
    }

    var likes: String? {
        switch self {
        case let .video(_, likes, _): likes
        case .podcast, .news: nil
        }
    }

    public var screenName: String {
        switch self {
        case .video: "Vídeo"
        case .podcast: "Podcast"
        case .news: "Notícias"
        }
    }

    public var accessibilityName: String {
        switch self {
        case .video: "Vídeo"
        case .podcast: "Podcast"
        case .news: "Notícias"
        }
    }
}

public struct CardContent {
    public let type: CardContentType
    public let analytics: AnalyticsManager?
    public let title: String
    public let pubDate: Date
    public let artworkUrl: String
    public let urlToShare: String
    public let favorite: Bool
    public let favoriteAction: () -> Void

    public init(
        type: CardContentType,
        analytics: AnalyticsManager? = nil,
        title: String,
        pubDate: Date,
        artworkUrl: String,
        urlToShare: String,
        favorite: Bool,
        favoriteAction: @escaping () -> Void
    ) {
        self.type = type
        self.title = title
        self.analytics = analytics
        self.pubDate = pubDate
        self.urlToShare = urlToShare
        self.artworkUrl = artworkUrl
        self.favorite = favorite
        self.favoriteAction = favoriteAction
    }
}
