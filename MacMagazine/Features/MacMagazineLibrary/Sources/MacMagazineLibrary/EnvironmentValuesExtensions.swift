import SwiftUI

extension EnvironmentValues {
    @MainActor
    public var shouldUseSidebar: Bool {
#if os(watchOS)
        false
#else
        horizontalSizeClass == .regular && UIDevice.current.userInterfaceIdiom == .pad
#endif
    }

    @MainActor
    public var iPad: Bool {
#if os(watchOS)
        false
#else
        UIDevice.current.userInterfaceIdiom == .pad
#endif
    }
}
