import AnalyticsLibrary
import Foundation
import MacMagazineLibrary

public enum CardContentType {
    case video(views: String, likes: String, duration: String)
    case podcast(duration: String)
    case news(categories: [NewsCategory], style: CardStyle?)

    public var duration: String {
        switch self {
        case let .video(_, _, duration): duration
        case let .podcast(duration): duration
        case .news: ""
        }
    }

    var categories: [NewsCategory] {
        switch self {
        case let .news(category, _): category
        case .podcast: [.podcast]
        case .video: [.youtube]
        }
    }

    var style: CardStyle? {
        switch self {
        case let .news(_, style): style
        case .podcast: .glass
        case .video: .glass
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
    public let author: String?
    public let artworkUrl: String
    public let urlToShare: String
    public let favorite: Bool
    public let read: Bool
    public let favoriteAction: () -> Void
    public let readAction: () -> Void

    /// The aspect ratio for the card thumbnail.
    /// When `nil`, the thumbnail fills its parent frame (useful for externally-sized cards like carousels).
    public let aspectRatio: CGFloat?

    public init(
        type: CardContentType,
        analytics: AnalyticsManager? = nil,
        title: String,
        pubDate: Date,
        author: String? = nil,
        artworkUrl: String,
        urlToShare: String,
        favorite: Bool,
        read: Bool,
        aspectRatio: CGFloat? = 16 / 9,
        favoriteAction: @escaping () -> Void,
        readAction: @escaping () -> Void
    ) {
        self.type = type
        self.title = title
        self.analytics = analytics
        self.pubDate = pubDate
        self.author = author
        self.urlToShare = urlToShare
        self.artworkUrl = artworkUrl
        self.favorite = favorite
        self.read = read
        self.aspectRatio = aspectRatio
        self.favoriteAction = favoriteAction
        self.readAction = readAction
    }
}
