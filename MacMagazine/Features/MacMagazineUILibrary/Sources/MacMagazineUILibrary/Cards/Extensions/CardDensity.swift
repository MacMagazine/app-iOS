import SwiftUI
import UIComponentsLibrary

public extension CardDensity {
    var titleFont: Font {
        switch self {
        case .compact: .subheadline
        case .regular, .spacious: .headline
        }
    }

    var isVisible: Bool {
        self != .compact
    }

    var titleLineLimit: Int {
        switch self {
        case .compact, .regular: 1
        case .spacious: 2
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
