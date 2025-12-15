import SwiftUI

extension View {
    func navigation(
        shouldUseSidebar: Bool,
        title: String? = nil
    ) -> some View {
        modifier(NavigationModifier(
            shouldUseSidebar: shouldUseSidebar,
            title: title
        ))
    }
}

private struct NavigationModifier: ViewModifier {
    let shouldUseSidebar: Bool
    let title: String?

    @Environment(\.isSidebarVisible) private var isSidebarVisible

    func body(content: Content) -> some View {
        if shouldUseSidebar {
            if let title {
                content
                    .navigationTitle(title)
                    .navigationBarTitleDisplayMode(isSidebarVisible ? .inline : .large )
            } else {
                content
            }
        } else {
            content
                .navigationBarTitleDisplayMode(.inline)
        }
    }
}
