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

    static func from(width: CGFloat) -> CardDensity {
        switch width {
        case ..<260: .compact
        case ..<340: .regular
        default: .spacious
        }
    }
}
