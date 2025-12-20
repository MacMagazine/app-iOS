import AnalyticsLibrary
import MacMagazineLibrary
import SwiftUI

struct WelcomeView: View {
    let coordinator: OnboardingCoordinator

    var body: some View {
        VStack(spacing: 40) {
            Spacer()
            logo
            message
            Spacer()
            actions
        }
        .background(OnboardingBackground())
        .trackScreen(AnalyticsConstants.Screen.onboardingWelcome.name, analytics: coordinator.analytics)
    }
}

private extension WelcomeView {
    var logo: some View {
        Image("normal", bundle: .module)
            .resizable()
            .scaledToFit()
            .frame(width: 160)
            .cornerRadius(20)
            .shadow(
                color: Color.black.opacity(0.2),
                radius: 24,
                x: 0,
                y: 8
            )
            .accessibilityHidden(true)
    }
}

private extension WelcomeView {
    var message: some View {
        Text("Welcome to the all new and greatest ever, MacMagazine App")
            .font(.title.bold())
            .multilineTextAlignment(.center)
            .padding(.horizontal, 32)
            .accessibilityAddTraits(.isHeader)
    }
}

private extension WelcomeView {
    var actions: some View {
        VStack(spacing: 16) {
            OnboardingButton(title: "Continuar", style: .primary) {
                coordinator.analytics.track(.buttonTap(
                    buttonId: AnalyticsConstants.ButtonID.onboardingWelcomeContinue.id,
                    screen: AnalyticsConstants.Screen.onboardingWelcome.name
                ))
                coordinator.navigate(to: .features)
            }

            OnboardingButton(title: "Pular", style: .skip) {
                coordinator.skipToPermissions()
            }
        }
        .padding(.horizontal, 24)
        .padding(.bottom, 40)
    }
}

// MARK: - Preview

#Preview {
    WelcomeView(
        coordinator: OnboardingCoordinator(
            permissionManager: PermissionManager(analytics: AnalyticsManager()),
            analytics: AnalyticsManager()
        )
    )
}
