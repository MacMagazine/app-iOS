import SwiftUI

extension View {
    func shadowed() -> some View {
        modifier(ShadowModifier())
    }
}

private struct ShadowModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .shadow(color: .white.opacity(0.6), radius: 2, x: 0, y: 1)
    }
}
