import SwiftUI

extension AnyTransition {
    static var flipFromRight: AnyTransition {
        AnyTransition.modifier(
            active: FlipModifier(angle: -45, anchor: .trailing),
            identity: FlipModifier(angle: 0, anchor: .trailing)
        )
    }

    static var flipFromLeft: AnyTransition {
        AnyTransition.modifier(
            active: FlipModifier(angle: 45, anchor: .leading),
            identity: FlipModifier(angle: 0, anchor: .leading)
        )
    }
}

struct FlipModifier: ViewModifier {
    let angle: Double
    let anchor: UnitPoint

    func body(content: Content) -> some View {
        content
            .rotation3DEffect(
                .degrees(angle),
                axis: (x: 0, y: 1, z: 0),
                anchor: anchor,
                perspective: 0.1
            )
            .opacity(angle == 0 ? 1 : 0)
    }
}
