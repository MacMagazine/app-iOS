import SwiftUI

public struct FavoriteShareContainer<FavoriteView: View, ShareView: View>: View {
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
        HStack {
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
            .buttonStyle(.glass)
            .tint(.primary)
            .font(.system(size: 16))
    }
}
