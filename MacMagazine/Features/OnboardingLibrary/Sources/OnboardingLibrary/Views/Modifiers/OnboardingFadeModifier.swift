import SwiftUI

struct OnboardingFadeModifier: ViewModifier {
    let isVisible: Bool
    let delay: Double
    let duration: Double

    func body(content: Content) -> some View {
        content
            .opacity(isVisible ? 1 : 0)
            .animation(
                .easeInOut(duration: duration).delay(delay),
                value: isVisible
            )
    }
}
