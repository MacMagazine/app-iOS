import SwiftUI

public extension DynamicTypeSize {
    var usesPrimaryCardLayout: Bool {
        switch self {
        case .xSmall,
             .small,
             .medium,
             .large,
             .xLarge,
             .xxLarge,
             .xxxLarge:
            return true

        default:
            return false
        }
    }
}
