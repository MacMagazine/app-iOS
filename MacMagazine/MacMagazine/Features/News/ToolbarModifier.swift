import SwiftUI

extension View {
    func toolbar<Menu: View, Options: View>(
        show: Bool,
        menu: Menu,
        options: Options
    ) -> some View {
        modifier(ToolbarModifier(
            show: show,
            menu: menu,
            options: options
        ))
    }
}

private struct ToolbarModifier<Menu: View, Options: View>: ViewModifier {
    let show: Bool
    let menu: Menu
    let options: Options

    func body(content: Content) -> some View {
        if show {
            content
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .primaryAction) {
                        menu
                    }
                    ToolbarItem(placement: .navigation) {
                        options
                    }
                }
        } else {
            content
                .navigationBarTitleDisplayMode(.large)
        }
    }
}
