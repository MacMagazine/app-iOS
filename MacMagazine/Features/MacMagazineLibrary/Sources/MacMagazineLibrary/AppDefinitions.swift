import AnalyticsLibrary
import Foundation

public enum AppTabs: String, CaseIterable, Codable, Equatable {

    case live = "MM Live"
    case news = "Notícias"
    case social = "Mídias"
    case settings = "Ajustes"
    case search = "Busca"

    public var icon: String {
        switch self {
        case .live: "antenna.radiowaves.left.and.right"
        case .news: "newspaper"
        case .social: "point.3.filled.connected.trianglepath.dotted"
        case .settings: "gearshape"
        case .search: "magnifyingglass"
        }
    }

    public var analyticsScreen: AnalyticsConstants.Screen? {
        switch self {
        case .settings: return .settings
        case .live: return .live
        case .news, .social, .search: return nil
        }
    }
}

public enum News: String, CaseIterable, Codable, Equatable {
    case all = "Todas"
    case news = "Últimas Notícias"
    case highlights = "Destaques"
    case appletv = "Apple TV"
    case reviews = "Reviews"
    case rumors = "Rumores"
    case tutoriais = "Tutoriais"

    public var icon: String {
        switch self {
        case .news: "newspaper"
        case .highlights: "point.3.filled.connected.trianglepath.dotted"
        case .appletv: "appletv"
        case .reviews: "checklist"
        case .rumors: "person.fill.questionmark"
        case .tutoriais: "long.text.page.and.pencil"
        case .all: ""
        }
    }
}

public enum Social: String, CaseIterable, Codable, Equatable {
    case videos = "Vídeos"
    case podcast = "Podcast"
    case instagram = "Instagram"

    public var icon: String {
        switch self {
        case .videos: "play.tv"
        case .podcast: "play.rectangle"
        case .instagram: "photo.stack"
        }
    }

    public var analyticsScreen: AnalyticsConstants.Screen {
        switch self {
        case .videos: return .socialVideos
        case .podcast: return .socialPodcast
        case .instagram: return .socialInstagram
        }
    }
}

public func areEqual(_ lhs: any CaseIterable & Equatable,
                     _ rhs: any CaseIterable & Equatable) -> Bool {
    guard type(of: lhs) == type(of: rhs) else {
        return false
    }
    return lhs.isEqual(rhs)
}

extension Equatable {
    func isEqual(_ other: any Equatable) -> Bool {
        guard let other = other as? Self else {
            return false
        }
        return self == other
    }
}
