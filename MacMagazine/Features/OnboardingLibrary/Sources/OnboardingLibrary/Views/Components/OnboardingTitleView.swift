import MacMagazineLibrary
import SwiftUI
import UIComponentsLibrary

// MARK: - Onboarding Title View

public struct OnboardingTitleView: View {
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    let title: String
    let animateIn: Bool
    let delay: Double

    public init(
        _ title: String,
        animateIn: Bool,
        delay: Double = 0.1
    ) {
        self.title = title
        self.animateIn = animateIn
        self.delay = delay
    }

    public var body: some View {
        Text(title)
            .font(.title2)
            .fontWeight(.bold)
            .multilineTextAlignment(.center)
            .onboardingAnimateIn(animateIn, delay: delay, reduceMotion: reduceMotion)
            .accessibilityAddTraits(.isHeader)
    }
}

// MARK: - Preview

#if DEBUG
#Preview("Title View") {
    OnboardingTitleView("Novidades no App", animateIn: true)
        .padding()
}
#endif
