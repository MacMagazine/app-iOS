import Foundation
import MacMagazineLibrary

public enum CardStyle {
    case header
    case leadingImage
    case highlight
    case glass
}

extension NewsCategory {
    public var style: CardStyle? {
        switch self {
        case .highlights: .highlight
        case .podcast, .youtube: .glass
        default: .leadingImage
        }
    }
}
