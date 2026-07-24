import SwiftUI
#if canImport(UIKit)
import UIKit
#endif

public struct FavoriteButton: View {
    let name: String?
    let favorite: Bool
    let action: () -> Void

    public init(
        name: String? = nil,
        favorite: Bool,
        action: @escaping () -> Void
    ) {
        self.name = name
        self.favorite = favorite
        self.action = action
    }

    public var body: some View {
        if let name {
            Button(action: {
                action(argument: name)
            }, label: {
                Image(systemName: "star\(favorite ? ".fill" : "")")
            })
            .accessibilityLabel("Favoritar o \(name).")
        } else {
            Button(
                favorite ? "Desfavoritar" : "Favoritar",
                systemImage: "star\(favorite ? ".fill" : "")"
            ) {
                action(argument: nil)
            }
            .accessibilityValue(favorite ? "Favoritado." : "Não favoritado.")
        }
    }
}

private extension FavoriteButton {
    func action(argument: String?) {
        action()
#if canImport(UIKit)
        UIAccessibility.post(
            notification: .announcement,
            argument: content(with: argument)
        )
#endif
    }

    func content(with name: String?) -> String {
        if let name {
            return favorite ? "\(name) favoritado." : "\(name) não favoritado."
        } else {
            return favorite ? "Não favoritado." : "Favoritado."
        }
    }
}
