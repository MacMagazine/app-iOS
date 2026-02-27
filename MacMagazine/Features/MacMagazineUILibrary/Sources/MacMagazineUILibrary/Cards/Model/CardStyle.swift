import Foundation
import MacMagazineLibrary

public enum CardStyle {
    case leadingImage
    case topImage
    case bottomImage
    case highlight
    case simple
    case glass
}

extension NewsCategory {
    public var style: CardStyle? {
        switch self {
        case .highlights, .reviews: .highlight
        case .news, .all: .bottomImage
        case .podcast, .youtube: .glass
        case .appletv: .leadingImage
        case .tutorials, .rumors: .topImage
        }
    }
}
