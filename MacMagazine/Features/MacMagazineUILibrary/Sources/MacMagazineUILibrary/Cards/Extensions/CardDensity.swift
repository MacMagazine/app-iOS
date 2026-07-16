import SwiftUI
import UIComponentsLibrary

public extension CardDensity {
    var titleFont: Font {
        switch self {
        case .compact: .subheadline
        case .regular, .spacious: .headline
        }
    }

    var titleLineLimit: Int {
        switch self {
        case .compact: 1
        case .regular: 2
        case .spacious: 3
        }
    }

    func titleFont(style: CardStyle?, isHeader: Bool = false) -> Font {
        guard let style,
              style == .highlight else {
            return titleFont
        }
        return switch self {
        case .compact: isHeader ? .title3 : .headline
        case .regular, .spacious: isHeader ? .title2 : .title3
        }
    }

    func titleLineLimit(style: CardStyle?) -> Int {
        guard let style,
              style == .highlight else {
            return titleLineLimit
        }
        return switch self {
        case .compact: 1
        case .regular, .spacious: 3
        }
    }

    static func from(width: CGFloat) -> CardDensity {
        switch width {
        case ..<260: .compact
        case ..<340: .regular
        default: .spacious
        }
    }
}
