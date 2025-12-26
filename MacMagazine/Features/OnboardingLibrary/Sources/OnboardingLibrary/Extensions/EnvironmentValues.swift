import SwiftUI

// MARK: - Landscape Detection Extension

public extension EnvironmentValues {
    var isLandscape: Bool {
        verticalSizeClass == .compact
    }
}
