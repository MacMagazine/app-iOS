import MacMagazineLibrary
import SwiftUI

public struct OnboardingBackground: View {
    @Environment(\.theme) private var theme: ThemeColor

    public init() {}

    public var body: some View {
        ZStack {
            // Base background color
            (theme.main.background.color ?? Color(.systemBackground))
                .ignoresSafeArea()

            // Subtle gradient overlay for depth
            LinearGradient(
                gradient: Gradient(stops: [
                    .init(color: .blue.opacity(0.1), location: 0.0),
                    .init(color: .purple.opacity(0.05), location: 0.5),
                    .init(color: .clear, location: 1.0)
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            .blendMode(.softLight)
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
