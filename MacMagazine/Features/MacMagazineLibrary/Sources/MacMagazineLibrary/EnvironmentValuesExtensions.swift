import SwiftUI

extension EnvironmentValues {
    public var shouldUseSidebar: Bool {
        horizontalSizeClass == .regular
    }
}
