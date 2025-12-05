import Foundation

public enum AppTabs: String, CaseIterable, Codable, Hashable {

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
}

public enum News: String, CaseIterable, Codable, Hashable {
    case all = "Todas"
    case news = "Últimas Notícias"
    case highlights = "Destaques"
    case appletv = "Novidades Apple TV"
    case reviews = "Reviews"
    case rumors = "Rumores"
    case tutoriais = "Tutoriais"

    public var icon: String {
        switch self {
        case .all, .news: "antenna.radiowaves.left.and.right"
        case .highlights: "point.3.filled.connected.trianglepath.dotted"
        case .appletv: "gearshape"
        case .reviews: "magnifyingglass"
        case .rumors: "magnifyingglass"
        case .tutoriais: "magnifyingglass"
        }
    }
}

public enum Social: String, CaseIterable, Codable, Hashable {
    case videos = "Videos"
    case podcast = "MM no Ar"
    case instagram = "Instagram"

    public var icon: String {
        switch self {
        case .videos: "antenna.radiowaves.left.and.right"
        case .podcast: "newspaper"
        case .instagram: "point.3.filled.connected.trianglepath.dotted"
        }
    }
}
