import SwiftUI

public struct FavoriteShareContainer<FavoriteView: View, ShareView: View>: View {
    @Namespace var namespace

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
        VStack {
            GlassEffectContainer {
                HStack(spacing: 0) {
                    favoriteView.buttonWithGlassEffect()
                    shareView.buttonWithGlassEffect()
                }
                .glassEffectUnion(id: 1, namespace: namespace)
            }
        }
        .padding(10)
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
            .tint(.primary)
            .font(.system(size: 16))
            .padding(.horizontal, 14)
            .padding(.vertical, 10)
            .padding(.bottom, 2)
            .glassEffect()
    }
}
