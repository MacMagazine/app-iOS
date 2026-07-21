import SwiftUI
#if canImport(UIKit)
import UIKit
#endif

public struct ReadButton: View {
    let read: Bool
    let action: (() -> Void)?

    public init(
        read: Bool,
        action: (() -> Void)?
    ) {
        self.read = read
        self.action = action
    }

    public var body: some View {
        Button(
            read ? "Marcar como não lido" : "Marcar como lido",
            systemImage: "circle\(read ? ".fill" : "")"
        ) {
            action?()
#if canImport(UIKit)
            UIAccessibility.post(
                notification: .announcement,
                argument: read ? "Marcar como não lido" : "Marcar como lido"
            )
#endif
        }
        .accessibilityValue(read ? "Lido." : "Não lido.")
    }
}
