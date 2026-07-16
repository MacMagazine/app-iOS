import SwiftUI
#if canImport(UIKit)
import UIKit
#endif

public struct ReadButton: View {
    let name: String
    let read: Bool
    let action: (() -> Void)?

    public init(
        name: String,
        read: Bool,
        action: (() -> Void)?
    ) {
        self.name = name
        self.read = read
        self.action = action
    }

    public var body: some View {
        Button(action: {
            action?()
#if canImport(UIKit)
            UIAccessibility.post(
                notification: .announcement,
                argument: read ? "Marcar como não lido" : "Marcar como lido"
            )
#endif

        }, label: {
            Image(systemName: "circle\(read ? ".fill" : "")")
        })
        .accessibilityLabel("Marcar \(name).", isEnabled: action != nil)
        .accessibilityValue(read ? "Lido." : "Não lido.")
    }
}
