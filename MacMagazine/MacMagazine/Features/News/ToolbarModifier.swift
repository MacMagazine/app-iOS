import SwiftUI

extension View {
    func toolbar<Menu: View, Options: View, Filter: View>(
        show: Bool,
        menu: Menu,
        options: Options,
        filter: Filter
    ) -> some View {
        modifier(ToolbarModifier(
            show: show,
            menu: menu,
            options: options,
            filter: filter
        ))
    }
}

private struct ToolbarModifier<Menu: View, Options: View, Filter: View>: ViewModifier {
    let show: Bool
    let menu: Menu
    let options: Options
    let filter: Filter

    func body(content: Content) -> some View {
        if show {
            content
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .primaryAction) {
                        menu
                    }
                    ToolbarItem(placement: .principal) {
                        filter
                    }
                    ToolbarItem(placement: .navigation) {
                        options
                    }
                }
        } else {
            content
                .navigationBarTitleDisplayMode(.large)
                .toolbar {
                    ToolbarItem(placement: .primaryAction) {
                        menu
                    }
                }
        }
    }
}
