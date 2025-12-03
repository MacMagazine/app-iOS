import Foundation

public enum Category: String, CaseIterable, Sendable {
    case all = "Todas"
    case news = "Últimas Notícias"
    case highlights = "Destaques"
    case appletv = "Novidades Apple TV+"
    case reviews = "Reviews"
    case rumors = "Rumores"
    case tutoriais = "Tutoriais"
    case youtube = "Vídeos"
    case podcast = "MacMagazine no Ar"

    var query: (String, String)? {
        switch self {
        case .highlights: (APIDefinitions.cat, "674")
        case .news, .all: nil
        case .podcast: (APIDefinitions.cat, "101")
        case .youtube: (APIDefinitions.cat, "18")
        case .appletv: (APIDefinitions.tag, "apple-tv-plus")
        case .reviews: (APIDefinitions.tag, "review")
        case .tutoriais: (APIDefinitions.cat, "302")
        case .rumors: (APIDefinitions.cat, "12")
        }
    }
}
