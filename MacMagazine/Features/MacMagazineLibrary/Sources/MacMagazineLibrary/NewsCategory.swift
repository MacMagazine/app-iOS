import Foundation

public enum NewsCategory: String, CaseIterable, Sendable {
    case all = "Todas"
    case news = "Últimas Notícias"
    case highlights = "Destaques"
    case appletv = "Apple TV"
    case reviews = "Reviews"
    case rumors = "Rumores"
    case tutorials = "Tutoriais"
    case youtube = "Vídeos"
    case podcast = "MacMagazine no Ar"

    public var filterKey: String {
        switch self {
        case .all: "NewsCategoryAll"
        case .news: "NewsCategoryNews"
        case .highlights: "NewsCategoryHighlights"
        case .appletv: "NewsCategoryAppleTV"
        case .reviews: "NewsCategoryReviews"
        case .rumors: "NewsCategoryRumors"
        case .tutorials: "NewsCategoryTutorials"
        case .youtube: "NewsCategoryMMTV"
        case .podcast: "NewsCategoryPodcast"
        }
    }

}
