import SwiftUI

public extension View {
    func minimumTouchTarget(
        selected: Bool = false,
        selectedColor: Color = .clear
    ) -> some View {
        modifier(MinimumTouchTarget(selected: selected, selectedColor: selectedColor))
    }
}

private struct MinimumTouchTarget: ViewModifier {
    let selected: Bool
    let selectedColor: Color

    func body(content: Content) -> some View {
        content
            .buttonStyle(MinimumTouchTargetButtonStyle())
            .glassEffect(.regular.tint(selected ? selectedColor.opacity(0.3) : .clear).interactive(), in: .circle)
    }
}

/// Expands the tappable area from inside the button so the full 44pt circle
/// receives taps — a `frame`/`contentShape` applied outside a `Button` only
/// resizes the visual glass, not the button's hit-test region (FB22155477).
private struct MinimumTouchTargetButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(width: 44, height: 44)
            .contentShape(Circle())
            .opacity(configuration.isPressed ? 0.4 : 1)
    }
}
