import SwiftUI
#if canImport(UIKit)
import UIKit
#endif

public struct FavoriteButton: View {
    let favorite: Bool
    let action: () -> Void

    public init(
        favorite: Bool,
        action: @escaping () -> Void
    ) {
        self.favorite = favorite
        self.action = action
    }

    public var body: some View {
        Button(
            favorite ? "Desfavoritar" : "Favoritar",
            systemImage: "star\(favorite ? ".fill" : "")"
        ) {
            action()
#if canImport(UIKit)
            UIAccessibility.post(
                notification: .announcement,
                argument: favorite ? "Não favoritado." : "Favoritado."
            )
#endif
        }
        .accessibilityValue(favorite ? "Favoritado." : "Não favoritado.")
    }
}
