import SwiftUI

enum ToolbarType: Equatable {
    case compact
    case normal
}

extension View {
    func toolbar<Menu: View, Options: View>(
        type: ToolbarType,
        menu: Menu,
        options: Options
    ) -> some View {
        modifier(ToolbarModifier(
            type: type,
            menu: menu,
            options: options
        ))
    }
}

private struct ToolbarModifier<Menu: View, Options: View>: ViewModifier {
    let type: ToolbarType
    let menu: Menu
    let options: Options

    func body(content: Content) -> some View {
        switch type {
        case .compact:
            content
                .navigationTitle("Notícias")
                .navigationBarTitleDisplayMode(.large)
                .toolbar {
                    ToolbarItem(placement: .primaryAction) {
                        menu
                    }
                    .sharedBackgroundVisibility(.hidden)
                }

        case .normal:
            content
                .navigationTitle("Notícias")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigation) {
                        options
                    }
                    .sharedBackgroundVisibility(.hidden)
                    ToolbarItem(placement: .primaryAction) {
                        menu
                    }
                    .sharedBackgroundVisibility(.hidden)
                }
        }
    }
}
