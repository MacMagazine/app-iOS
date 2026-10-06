import SwiftUI

public extension View {
    func toolbar<Close: View, Favourite: View, Share: View>(
        close: Close = EmptyView(),
        favourite: Favourite,
        share: Share
    ) -> some View {
        modifier(DetailToolbarModifier(
            close: close,
            favourite: favourite,
            share: share
        ))
    }
}

private struct DetailToolbarModifier<Close: View, Favourite: View, Share: View>: ViewModifier {
    let close: Close
    let favourite: Favourite
    let share: Share

    func body(content: Content) -> some View {
        if #available(iOS 27.1, *) {
            content
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) { close }
                    ToolbarItem(placement: .automatic) { favourite }
                        .sharedBackgroundVisibility(.hidden)
                        .axisBehavior(.verticalPreferred)
                    ToolbarItem(placement: .automatic) { share }
                        .sharedBackgroundVisibility(.hidden)
                        .axisBehavior(.verticalPreferred)
                }
        } else {
            content
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) { close }
                    ToolbarItem(placement: .topBarTrailing) { favourite }
                        .sharedBackgroundVisibility(.hidden)
                    ToolbarSpacer(.fixed, placement: .topBarTrailing)
                    ToolbarItem(placement: .topBarTrailing) { share }
                        .sharedBackgroundVisibility(.hidden)
                }
        }
    }
}
