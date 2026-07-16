import SwiftUI

public extension View {
    /// Expands an icon-only toolbar button's tap area to Apple's 44x44pt minimum
    /// touch target with an explicit circular glass shape. Pair with
    /// `.sharedBackgroundVisibility(.hidden)` on the enclosing `ToolbarItem` —
    /// the system's automatic toolbar chrome defaults to `.capsule` and isn't
    /// overridden by `buttonBorderShape` alone, so it must be hidden first.
    func minimumTouchTarget() -> some View {
        modifier(MinimumTouchTarget())
    }
}

private struct MinimumTouchTarget: ViewModifier {
    func body(content: Content) -> some View {
        content
            .buttonStyle(.plain)
            .frame(width: 44, height: 44)
            .contentShape(Circle())
            .glassEffect(.regular.interactive(), in: .circle)
    }
}
