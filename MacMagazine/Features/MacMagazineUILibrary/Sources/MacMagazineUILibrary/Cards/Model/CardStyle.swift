import Foundation
import MacMagazineLibrary

enum CardStyle {
    case leadingImage
    case topImage
    case bottomImage
    case highlight
    case simple
    case glass
}

extension NewsCategory {
    var style: CardStyle {
        switch self {
        case .highlights: .highlight
        case .news, .all: .bottomImage
        case .podcast: .glass
        case .youtube: .glass
        case .appletv: .leadingImage
        case .reviews: .highlight
        case .tutorials: .simple
        case .rumors: .simple
        }
    }
}
