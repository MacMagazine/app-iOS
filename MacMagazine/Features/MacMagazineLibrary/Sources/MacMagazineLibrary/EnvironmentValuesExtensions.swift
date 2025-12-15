import SwiftUI

public extension EnvironmentValues {
    @MainActor
    var shouldUseSidebar: Bool {
#if os(watchOS)
        false
#else
        horizontalSizeClass == .regular && UIDevice.current.userInterfaceIdiom == .pad
#endif
    }

    @MainActor
    var iPad: Bool {
#if os(watchOS)
        false
#else
        UIDevice.current.userInterfaceIdiom == .pad
#endif
    }

    @MainActor @Entry
    var isSidebarVisible: Bool = false
}
