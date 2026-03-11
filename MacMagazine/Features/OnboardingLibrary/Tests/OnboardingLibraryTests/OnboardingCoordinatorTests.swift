import AnalyticsLibrary
import Foundation
import MacMagazineLibrary
@testable import OnboardingLibrary
import Testing

@Suite("OnboardingCoordinator Tests")
@MainActor
struct OnboardingCoordinatorTests {

    // MARK: - Setup/Teardown

    init() {
        OnboardingCoordinator.resetOnboarding()
    }

    // MARK: - Initial State Tests

    @Test("Should start with welcome screen")
    func initialScreenIsWelcome() {
        let analytics = AnalyticsManager()
        let permissionManager = PermissionManager(analytics: analytics, pushNotification: PushNotification())
        let sut = OnboardingCoordinator(permissionManager: permissionManager, analytics: analytics)

        #expect(sut.currentScreen == .welcome)
    }

    @Test("Should have stable identifier")
    func hasStableIdentifier() {
        let analytics = AnalyticsManager()
        let permissionManager = PermissionManager(analytics: analytics, pushNotification: PushNotification())
        let sut = OnboardingCoordinator(permissionManager: permissionManager, analytics: analytics)

        #expect(sut.id == "onboarding")
    }

    @Test("Should start with nil completion handler")
    func initialCompletionIsNil() {
        let analytics = AnalyticsManager()
        let permissionManager = PermissionManager(analytics: analytics, pushNotification: PushNotification())
        let sut = OnboardingCoordinator(permissionManager: permissionManager, analytics: analytics)

        #expect(sut.onComplete == nil)
    }

    // MARK: - Navigation Tests

    @Test("Should navigate to features screen")
    func navigateToFeatures() {
        let analytics = AnalyticsManager()
        let permissionManager = PermissionManager(analytics: analytics, pushNotification: PushNotification())
        let sut = OnboardingCoordinator(permissionManager: permissionManager, analytics: analytics)

        sut.navigate(to: .features)

        #expect(sut.currentScreen == .features)
    }

    @Test("Should navigate to permissions screen")
    func navigateToPermissions() {
        let analytics = AnalyticsManager()
        let permissionManager = PermissionManager(analytics: analytics, pushNotification: PushNotification())
        let sut = OnboardingCoordinator(permissionManager: permissionManager, analytics: analytics)

        sut.navigate(to: .permissions)

        #expect(sut.currentScreen == .permissions)
    }

    @Test("Should navigate back to welcome screen")
    func navigateBackToWelcome() {
        let analytics = AnalyticsManager()
        let permissionManager = PermissionManager(analytics: analytics, pushNotification: PushNotification())
        let sut = OnboardingCoordinator(permissionManager: permissionManager, analytics: analytics)

        sut.navigate(to: .features)
        sut.navigate(to: .welcome)

        #expect(sut.currentScreen == .welcome)
    }

    @Test("Should skip directly to permissions from welcome")
    func skipToPermissions() {
        let analytics = AnalyticsManager()
        let permissionManager = PermissionManager(analytics: analytics, pushNotification: PushNotification())
        let sut = OnboardingCoordinator(permissionManager: permissionManager, analytics: analytics)

        sut.skipToPermissions()

        #expect(sut.currentScreen == .permissions)
    }

    @Test("Should skip directly to permissions from features")
    func skipToPermissionsFromFeatures() {
        let analytics = AnalyticsManager()
        let permissionManager = PermissionManager(analytics: analytics, pushNotification: PushNotification())
        let sut = OnboardingCoordinator(permissionManager: permissionManager, analytics: analytics)

        sut.navigate(to: .features)
        sut.skipToPermissions()

        #expect(sut.currentScreen == .permissions)
    }

    // MARK: - Completion Tests

    @Test("Should call completion handler when completing onboarding")
    func completionHandlerCalled() {
        let analytics = AnalyticsManager()
        let permissionManager = PermissionManager(analytics: analytics, pushNotification: PushNotification())
        let sut = OnboardingCoordinator(permissionManager: permissionManager, analytics: analytics)

        var completionCalled = false
        sut.onComplete = { completionCalled = true }

        sut.completeOnboarding()

        #expect(completionCalled)
    }

    @Test("Should not crash when completing with nil handler")
    func completionWithNilHandler() {
        let analytics = AnalyticsManager()
        let permissionManager = PermissionManager(analytics: analytics, pushNotification: PushNotification())
        let sut = OnboardingCoordinator(permissionManager: permissionManager, analytics: analytics)

        sut.completeOnboarding()

        #expect(true, "Should not crash")
    }

    @Test("Should mark onboarding as completed in UserDefaults")
    func marksOnboardingAsCompleted() {
        OnboardingCoordinator.resetOnboarding()

        let analytics = AnalyticsManager()
        let permissionManager = PermissionManager(analytics: analytics, pushNotification: PushNotification())
        let sut = OnboardingCoordinator(permissionManager: permissionManager, analytics: analytics)

        sut.completeOnboarding()

        let hasCompleted = UserDefaults.standard.bool(forKey: "hasCompletedOnboarding")
        #expect(hasCompleted)
    }

    // MARK: - Reset Tests

    @Test("Should reset onboarding state")
    func resetOnboardingState() {
        let analytics = AnalyticsManager()
        let permissionManager = PermissionManager(analytics: analytics, pushNotification: PushNotification())
        let sut = OnboardingCoordinator(permissionManager: permissionManager, analytics: analytics)

        sut.completeOnboarding()

        OnboardingCoordinator.resetOnboarding()

        let hasCompleted = UserDefaults.standard.bool(forKey: "hasCompletedOnboarding")
        #expect(!hasCompleted)
    }

    // MARK: - Screen Navigation Flow Tests

    @Test("Should follow typical welcome -> features -> permissions flow")
    func typicalNavigationFlow() {
        let analytics = AnalyticsManager()
        let permissionManager = PermissionManager(analytics: analytics, pushNotification: PushNotification())
        let sut = OnboardingCoordinator(permissionManager: permissionManager, analytics: analytics)

        #expect(sut.currentScreen == .welcome)

        sut.navigate(to: .features)
        #expect(sut.currentScreen == .features)

        sut.navigate(to: .permissions)
        #expect(sut.currentScreen == .permissions)
    }

    @Test("Should follow skip flow: welcome -> permissions")
    func skipNavigationFlow() {
        let analytics = AnalyticsManager()
        let permissionManager = PermissionManager(analytics: analytics, pushNotification: PushNotification())
        let sut = OnboardingCoordinator(permissionManager: permissionManager, analytics: analytics)

        #expect(sut.currentScreen == .welcome)

        sut.skipToPermissions()
        #expect(sut.currentScreen == .permissions)
    }
}

@Suite("OnboardingScreen Tests")
struct OnboardingScreenTests {

    @Test("All screens should be usable in Set")
    func screensAreHashable() {
        var screenSet: Set<OnboardingScreen> = []
        screenSet.insert(.welcome)
        screenSet.insert(.features)
        screenSet.insert(.permissions)

        #expect(screenSet.count == 3)
    }

    @Test("All screens should have non-empty analytics name")
    func screensHaveAnalyticsNames() {
        #expect(!OnboardingScreen.welcome.analyticsName.isEmpty)
        #expect(!OnboardingScreen.features.analyticsName.isEmpty)
        #expect(!OnboardingScreen.permissions.analyticsName.isEmpty)
    }
}
