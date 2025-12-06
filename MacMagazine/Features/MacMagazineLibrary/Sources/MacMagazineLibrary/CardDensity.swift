import SwiftUI
import UIComponentsLibrary

extension CardDensity {
    public var titleFont: Font {
        switch self {
        case .compact: .subheadline
        case .regular, .spacious: .headline
        }
    }

    public var isVisible: Bool {
        self != .compact
    }

    public var titleLineLimit: Int {
        switch self {
        case .compact, .regular: 1
        case .spacious: 2
        }
    }

    public static func from(width: CGFloat) -> CardDensity {
        switch width {
        case ..<260: .compact
        case ..<340: .regular
        default: .spacious
        }
    }
}
