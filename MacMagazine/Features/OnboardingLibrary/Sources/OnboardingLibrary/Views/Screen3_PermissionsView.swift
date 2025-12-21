import AnalyticsLibrary
import MacMagazineLibrary
import SwiftUI
import UIComponentsLibrary

struct PermissionsView: View {
    let coordinator: OnboardingCoordinator

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Header
                VStack(spacing: 12) {
                    Text("Enhance Your Experience")
                        .font(.largeTitle.bold())
                        .multilineTextAlignment(.center)
                        .accessibilityAddTraits(.isHeader)

                    Text("These permissions help us provide you with the best experience")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                }
                .padding(.top, 40)
                .padding(.horizontal, 24)

                // Push notification section
                if coordinator.permissionManager.shouldShowPushSection {
                    PermissionSection(
                        title: "Push Notifications",
                        icon: "bell.badge.fill",
                        description: coordinator.permissionManager.pushSectionText,
                        onContinue: {
                            let granted = await coordinator.permissionManager.requestPushPermission()
                            await handlePushResponse(granted: granted)
                        },
                        onSkip: nil
                    )
                    .padding(.horizontal, 24)
                }

                // ATT section
                if coordinator.permissionManager.shouldShowATTSection {
                    PermissionSection(
                        title: "App Analytics",
                        icon: "chart.bar.fill",
                        description: coordinator.permissionManager.attSectionText,
                        onContinue: {
                            let granted = await coordinator.permissionManager.requestATTPermission()
                            await handleATTResponse(granted: granted)
                        },
                        onSkip: nil  // ATT doesn't have skip - user can deny in system prompt
                    )
                    .padding(.horizontal, 24)
                }

                // Completion button (if no more sections to show)
                if !coordinator.permissionManager.shouldShowPushSection &&
                   !coordinator.permissionManager.shouldShowATTSection {
                    VStack(spacing: 16) {
                        Text("You're all set!")
                            .font(.title2.bold())
                            .accessibilityAddTraits(.isHeader)

                        OnboardingButton(title: "Start the new MacMagazine App Experience", style: .primary) {
                            coordinator.completeOnboarding()
                        }
                        .padding(.horizontal, 24)
                    }
                    .padding(.top, 40)
                }

                Spacer(minLength: 40)
            }
        }
        .background(OnboardingBackground())
        .task {
            await coordinator.permissionManager.refreshAllPermissionStatuses()
        }
        .trackScreen(AnalyticsConstants.Screen.onboardingPermissions.name, analytics: coordinator.analytics)
    }

    private func handlePushResponse(granted: Bool) async {
        // Refresh permission status
        await coordinator.permissionManager.refreshAllPermissionStatuses()

        // If ATT section should not show, complete onboarding
        if !coordinator.permissionManager.shouldShowATTSection {
            coordinator.completeOnboarding()
        }
    }

    private func handlePushSkip() {
        // If ATT section should not show, complete onboarding
        if !coordinator.permissionManager.shouldShowATTSection {
            coordinator.completeOnboarding()
        }
    }

    private func handleATTResponse(granted: Bool) async {
        // Refresh permission status
        await coordinator.permissionManager.refreshAllPermissionStatuses()

        // Complete onboarding after ATT (it's the last permission)
        coordinator.completeOnboarding()
    }
}

// MARK: - Preview

#Preview("Permissions Screen") {
    PermissionsView(
        coordinator: OnboardingCoordinator(
            permissionManager: PermissionManager(analytics: AnalyticsManager()),
            analytics: AnalyticsManager()
        )
    )
}
