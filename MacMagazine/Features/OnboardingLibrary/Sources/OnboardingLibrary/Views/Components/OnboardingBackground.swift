import MacMagazineLibrary
import SwiftUI

public struct OnboardingBackground: View {
    @Environment(\.theme) private var theme: ThemeColor
    @Environment(\.colorScheme) private var colorScheme

    public var body: some View {
        ZStack {
            (theme.main.background.color ?? Color.secondary)
                .ignoresSafeArea()

            Image("normal_without_background", bundle: .module)
                .resizable()
                .scaledToFit()
                .frame(width: 520)
                .rotationEffect(.degrees(-12))
                .offset(x: 170, y: -140)
                .opacity(0.14)
                .blur(radius: 5)
                .accessibilityHidden(true)

            Image("alternativa_without_background", bundle: .module)
                .resizable()
                .scaledToFit()
                .frame(width: 360)
                .rotationEffect(.degrees(18))
                .offset(x: -170, y: 220)
                .opacity(colorScheme == .dark ? 0.14 : 0.14)
                .blur(radius: 5)
                .accessibilityHidden(true)

            LinearGradient(
                colors: [
                    .black.opacity(0.25),
                    .clear,
                    .black.opacity(0.35)
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            .blendMode(.overlay)
            .ignoresSafeArea()
        }
    }
}

// MARK: - Preview

#Preview("Onboarding Background") {
    VStack {
        Text("Preview with Onboarding Background")
            .font(.title)
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(OnboardingBackground())
}
