import Foundation

public enum CardContentType {
    case video(views: String, likes: String, duration: String)
    case podcast(duration: String)

    var duration: String {
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

    var accessibilityName: String {
        switch self {
        case .video: "Vídeo"
        case .podcast: "Podcast"
        }
    }
}

public struct CardContent {
    let type: CardContentType
    let title: String
    let pubDate: Date
    let artworkUrl: String
    let urlToShare: String
    let favorite: Bool
    let favoriteAction: () -> Void

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
