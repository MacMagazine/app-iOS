import SwiftUI

public enum CardDensity {
    case compact
    case regular
    case spacious

    public static func from(width: CGFloat) -> CardDensity {
        switch width {
        case ..<260:  return .compact
        case ..<340:  return .regular
        default:      return .spacious
        }
    }

    public var titleFont: Font {
        switch self {
        case .compact:
            return .subheadline
        case .regular, .spacious:
            return .headline
        }
    }

    public var isVisible: Bool {
        self != .compact
    }

    public var titleLineLimit: Int {
        switch self {
        case .compact, .regular:
            return 1
        case .spacious:
            return 2
        }
    }
}
