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
        case .highlights: .highlight
        case .podcast, .youtube: .glass
        default: .topImage
        }
    }
}
