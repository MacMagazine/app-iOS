import AnalyticsLibrary
import Foundation
import MacMagazineLibrary
import Observation
import SwiftUI

@MainActor
@Observable
public final class OnboardingCoordinator: @MainActor Identifiable {
    public var id: String { "onboarding" }

    // Current screen state
    public var currentScreen: OnboardingScreen = .welcome

    // Completion callback
    public var onComplete: (() -> Void)?

    // Dependencies
    public let permissionManager: PermissionManager
    public let analytics: AnalyticsManager

    // UserDefaults keys
    private static let hasCompletedOnboardingKey = "hasCompletedOnboarding"
    private static let hasSeenFeaturesKey = "hasSeenOnboardingFeatures"

    public init(
        permissionManager: PermissionManager,
        analytics: AnalyticsManager
    ) {
        self.permissionManager = permissionManager
        self.analytics = analytics
    }

    // MARK: - Navigation

    func navigate(to screen: OnboardingScreen) {
        withAnimation(.easeInOut(duration: 0.3)) {
            currentScreen = screen
        }

        if screen == .permissions {
            markFeaturesAsSeen()
        }
    }

    func skipToPermissions() {
        analytics.track(.buttonTap(
            buttonId: AnalyticsConstants.ButtonID.onboardingWelcomeSkip.id,
            screen: currentScreen.analyticsName
        ))

        markFeaturesAsSeen()

        withAnimation(.easeInOut(duration: 0.3)) {
            currentScreen = .permissions
        }
    }

    func completeOnboarding() {
        // Track completion
        analytics.track(.buttonTap(
            buttonId: AnalyticsConstants.ButtonID.onboardingComplete.id,
            screen: AnalyticsConstants.Screen.onboardingPermissions.name
        ))

        // Mark as completed in UserDefaults
        UserDefaults.standard.set(true, forKey: Self.hasCompletedOnboardingKey)

        // Call completion handler
        onComplete?()
    }

    // MARK: - Features Seen State

    private func markFeaturesAsSeen() {
        UserDefaults.standard.set(true, forKey: Self.hasSeenFeaturesKey)
    }

    private static var hasSeenFeatures: Bool {
        UserDefaults.standard.bool(forKey: hasSeenFeaturesKey)
    }

    // MARK: - Onboarding State Management

    /// Create coordinator if onboarding is needed, returns nil if not needed
    public static func createIfNeeded(analytics: AnalyticsManager) async -> OnboardingCoordinator? {
        let permissionManager = PermissionManager(analytics: analytics)
        await permissionManager.refreshAllPermissionStatuses()

        // Check if onboarding was completed
        let hasCompleted = UserDefaults.standard.bool(forKey: hasCompletedOnboardingKey)

        // If never completed, create coordinator
        if !hasCompleted {
            let coordinator = OnboardingCoordinator(
                permissionManager: permissionManager,
                analytics: analytics
            )

            // If user already saw features, go directly to permissions
            if hasSeenFeatures {
                coordinator.currentScreen = .permissions
            }
            // Otherwise, start from welcome

            return coordinator
        }

        // If completed, check if push permission still needs to be handled
        if permissionManager.currentPushStatus == .notDetermined {
            let coordinator = OnboardingCoordinator(
                permissionManager: permissionManager,
                analytics: analytics
            )
            // Start at permissions screen (already completed before, no need to see features again)
            coordinator.currentScreen = .permissions
            return coordinator
        }

        // Onboarding not needed
        return nil
    }

    /// Reset onboarding state (for debug/testing)
    public static func resetOnboarding() {
        UserDefaults.standard.removeObject(forKey: hasCompletedOnboardingKey)
        UserDefaults.standard.removeObject(forKey: hasSeenFeaturesKey)
    }
}

// MARK: - Onboarding Screen Enum

public enum OnboardingScreen: Hashable {
    case welcome
    case features
    case permissions

    var analyticsName: String {
        switch self {
            case .welcome:
                return AnalyticsConstants.Screen.onboardingWelcome.name
            case .features:
                return AnalyticsConstants.Screen.onboardingFeatures.name
            case .permissions:
                return AnalyticsConstants.Screen.onboardingPermissions.name
        }
    }
}
