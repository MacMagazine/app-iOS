import SwiftUI

public struct FavoriteShareGlassContainer<FavoriteView: View, ShareView: View>: View {
    let favoriteView: FavoriteView
    let shareView: ShareView

    public init(
        favoriteView: FavoriteView,
        shareView: ShareView
    ) {
        self.favoriteView = favoriteView
        self.shareView = shareView
    }

    public var body: some View {
        HStack(spacing: 10) {
            favoriteView.buttonWithGlassEffect()
            shareView.buttonWithGlassEffect()
        }
        .padding(.top, 10)
        .padding(.trailing, 10)
    }
}

extension View {
    func buttonWithGlassEffect() -> some View {
        modifier(ButtonWithGlassEffect())
    }
}

private struct ButtonWithGlassEffect: ViewModifier {
    func body(content: Content) -> some View {
        content
            .buttonStyle(.plain)
            .frame(width: 34, height: 34)
            .tint(.primary)
            .font(.system(size: 16))
            .glassEffect(.regular.interactive(), in: .circle)
    }
}
