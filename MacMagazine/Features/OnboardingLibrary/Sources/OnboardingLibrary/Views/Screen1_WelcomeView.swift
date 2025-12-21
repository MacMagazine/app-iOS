import AnalyticsLibrary
import MacMagazineLibrary
import SwiftUI

struct WelcomeView: View {
    @Environment(\.theme) private var theme: ThemeColor
    let coordinator: OnboardingCoordinator

    var body: some View {
        NavigationStack {
            VStack(spacing: 40) {
                Spacer()
                logo
                message
                Spacer()
                actions
            }
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button(action: {
                        coordinator.skipToPermissions()
                    }, label: {
                        Image(systemName: "xmark")
                    })
                    .glassEffect(.identity, in: .circle)
                }
            }
            .background(OnboardingBackground())
        }
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
        OnboardingButton(title: "Continuar", style: .primary) {
            coordinator.analytics.track(.buttonTap(
                buttonId: AnalyticsConstants.ButtonID.onboardingWelcomeContinue.id,
                screen: AnalyticsConstants.Screen.onboardingWelcome.name
            ))
            coordinator.navigate(to: .features)
        }
        .padding(.horizontal, 20)
        .padding(.bottom)
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
    .environment(\.theme, ThemeColor())
}
