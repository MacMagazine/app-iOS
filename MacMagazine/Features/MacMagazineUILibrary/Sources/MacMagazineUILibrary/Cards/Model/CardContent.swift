import Foundation

public enum CardContentType {
    case video(views: String, likes: String, duration: String)
    case podcast(duration: String)

    public var duration: String {
        switch self {
        case let .video(_, _, duration): duration
        case let .podcast(duration): duration
        }
    }

    var views: String? {
        switch self {
        case let .video(views, _, _): views
        case .podcast: nil
        }
    }

    var likes: String? {
        switch self {
        case let .video(_, likes, _): likes
        case .podcast: nil
        }
    }

    public var accessibilityName: String {
        switch self {
        case .video: "Vídeo"
        case .podcast: "Podcast"
        }
    }
}

public struct CardContent {
    public let type: CardContentType
    public let title: String
    public let pubDate: Date
    public let artworkUrl: String
    public let urlToShare: String
    public let favorite: Bool
    public let favoriteAction: () -> Void

    public init(
        type: CardContentType,
        title: String,
        pubDate: Date,
        artworkUrl: String,
        urlToShare: String,
        favorite: Bool,
        favoriteAction: @escaping () -> Void
    ) {
        self.type = type
        self.title = title
        self.pubDate = pubDate
        self.urlToShare = urlToShare
        self.artworkUrl = artworkUrl
        self.favorite = favorite
        self.favoriteAction = favoriteAction
    }
}
