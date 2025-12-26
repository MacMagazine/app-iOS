import SwiftUI

struct OnboardingFade: ViewModifier {
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

extension View {
    func onboardingFade(
        _ isVisible: Bool,
        delay: Double = 0,
        duration: Double = 0.6
    ) -> some View {
        modifier(OnboardingFade(isVisible: isVisible, delay: delay, duration: duration))
    }
}
