import SwiftUI
#if canImport(UIKit)
import UIKit
#endif

public struct FavoriteButton: View {
    let name: String
    let favorite: Bool
    let action: () -> Void

    public init(
        name: String,
        favorite: Bool,
        action: @escaping () -> Void
    ) {
        self.name = name
        self.favorite = favorite
        self.action = action
    }

    public var body: some View {
        Button(action: {
            action()
#if canImport(UIKit)
            UIAccessibility.post(
                notification: .announcement,
                argument: favorite ? "\(name) favoritado." : "\(name) não favoritado."
            )
#endif

        }, label: {
            Image(systemName: "star\(favorite ? ".fill" : "")")
                .padding(10)
                .contentShape(Circle())
        })
        .accessibilityLabel("Favoritar o \(name).")
        .accessibilityValue(favorite ? "Favoritado." : "Não favoritado.")
    }
}
