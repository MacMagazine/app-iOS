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
