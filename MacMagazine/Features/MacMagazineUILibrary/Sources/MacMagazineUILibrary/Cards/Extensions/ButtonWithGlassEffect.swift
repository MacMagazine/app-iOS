import SwiftUI

extension View {
    func buttonWithGlassEffect() -> some View {
        modifier(ButtonWithGlassEffect())
    }
}

private struct ButtonWithGlassEffect: ViewModifier {
    func body(content: Content) -> some View {
        content
            .buttonStyle(.plain)
            .frame(width: 44, height: 44)
            .contentShape(Circle())
            .tint(.primary)
            .font(.system(size: 16))
            .glassEffect(.regular.interactive(), in: .circle)
    }
}
