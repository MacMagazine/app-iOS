import AnalyticsLibrary
import MacMagazineLibrary
import SwiftUI

public struct OnboardingContainerView: View {
    @Environment(\.theme) private var theme: ThemeColor
    @State private var coordinator: OnboardingCoordinator

    public init(coordinator: OnboardingCoordinator) {
        _coordinator = State(initialValue: coordinator)
    }

    public var body: some View {
        ZStack {
            OnboardingBackground()

            Group {
                switch coordinator.currentScreen {
                case .welcome:
                    WelcomeView(coordinator: coordinator)
                case .features:
                    FeaturesView(coordinator: coordinator)
                case .permissions:
                    PermissionsView(coordinator: coordinator)
                }
            }
            .transition(.opacity)
        }
        .environment(\.theme, theme)
    }
}

// MARK: - Preview

#Preview("Onboarding Container") {
    OnboardingContainerView(
        coordinator: OnboardingCoordinator(
            permissionManager: PermissionManager(analytics: AnalyticsManager()),
            analytics: AnalyticsManager()
        )
    )
}
