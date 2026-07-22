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
            .buttonStyle(.plain)
            .frame(width: 44, height: 44)
            .contentShape(Circle())
            .glassEffect(.regular.tint(selected ? selectedColor.opacity(0.3) : .clear).interactive(), in: .circle)
    }
}
