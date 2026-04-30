import AnalyticsLibrary
import AppTrackingTransparency
import Foundation
import MacMagazineLibrary
import Observation

@MainActor
@Observable
public final class PermissionManager {
    // Observable state for UI updates
    var currentPushStatus: PushPermissionStatus = .notDetermined
    var currentATTStatus: ATTPermissionStatus = .notDetermined

    private let analytics: AnalyticsManager
    private let pushNotification: PushNotification

    public init(analytics: AnalyticsManager, pushNotification: PushNotification) {
        self.analytics = analytics
        self.pushNotification = pushNotification
    }

    // MARK: - Push Notifications

    /// Check current push notification permission status from system
    func checkPushPermissionStatus() async {
        if ProcessInfo.processInfo.isiOSAppOnMac {
            currentPushStatus = .authorized
            return
        }

        let status = await PushNotification.authorizationStatus
        currentPushStatus = status
    }

    /// Request push notification permission and track analytics
    func requestPushPermission() async -> Bool {
        // Track that user tapped push notification permissions
        analytics.track(.buttonTap(
            buttonId: AnalyticsConstants.ButtonID.onboardingPushContinue.id,
            screen: AnalyticsConstants.Screen.onboardingPermissions.name
        ))

        let granted = await pushNotification.setup(options: PushNotificationDefinition.options)
        // Track the result
        if granted {
            analytics.track(.buttonTap(
                buttonId: AnalyticsConstants.ButtonID.onboardingPushAccepted.id,
                screen: AnalyticsConstants.Screen.onboardingPermissions.name
            ))
            currentPushStatus = .authorized
        } else {
            analytics.track(.buttonTap(
                buttonId: AnalyticsConstants.ButtonID.onboardingPushDenied.id,
                screen: AnalyticsConstants.Screen.onboardingPermissions.name
            ))
            currentPushStatus = .denied
        }

        return granted
    }

    /// User tapped skip on push permission
    func skipPushPermission() {
        analytics.track(.buttonTap(
            buttonId: AnalyticsConstants.ButtonID.onboardingPushSkip.id,
            screen: AnalyticsConstants.Screen.onboardingPermissions.name
        ))
        // Status remains .notDetermined since user skipped
    }

    /// Determine if we should show the push permission section
    var shouldShowPushSection: Bool {
        // Only show if not yet authorized
        return currentPushStatus != .authorized
    }

    /// Get appropriate text for push section based on current status
    var pushSectionText: String {
        if currentPushStatus == .denied {
            return """
            Stay updated with the latest Apple news! Enable notifications to:
            • Get instant alerts for breaking news
            • Sync your preferences across all your devices via iCloud
            • Never miss important updates

            You previously denied notifications. You can enable them in Settings.
            """
        } else {
            return """
            To improve your experience notifying you about new posts and to be able to sync \
            with devices that use your iCloud account.
            """
        }
    }

    // MARK: - ATT (App Tracking Transparency)

    /// Check current ATT permission status from system
    func checkATTPermissionStatus() {
        if ProcessInfo.processInfo.isiOSAppOnMac {
            // ATT doesn't work on macOS even for iPad apps - automatically mark as authorized
            currentATTStatus = .authorized
            return
        }

        let status: ATTPermissionStatus = switch ATTrackingManager.trackingAuthorizationStatus {
        case .notDetermined:
            .notDetermined
        case .authorized:
            .authorized
        case .denied:
            .denied
        case .restricted:
            .restricted
        @unknown default:
            .notDetermined
        }

        currentATTStatus = status
    }

    /// Request ATT permission and track analytics
    func requestATTPermission() async -> Bool {
        // Track that user tapped continue
        analytics.track(.buttonTap(
            buttonId: AnalyticsConstants.ButtonID.onboardingATTContinue.id,
            screen: AnalyticsConstants.Screen.onboardingPermissions.name
        ))

        let status = await ATTrackingManager.requestTrackingAuthorization()

        let permissionStatus: ATTPermissionStatus = switch status {
        case .authorized:
            .authorized
        case .denied:
            .denied
        case .restricted:
            .restricted
        case .notDetermined:
            .notDetermined
        @unknown default:
            .notDetermined
        }

        currentATTStatus = permissionStatus

        // Track the result
        if status == .authorized {
            analytics.track(.buttonTap(
                buttonId: AnalyticsConstants.ButtonID.onboardingATTAccepted.id,
                screen: AnalyticsConstants.Screen.onboardingPermissions.name
            ))
        } else {
            analytics.track(.buttonTap(
                buttonId: AnalyticsConstants.ButtonID.onboardingATTDenied.id,
                screen: AnalyticsConstants.Screen.onboardingPermissions.name
            ))
        }

        return status == .authorized
    }

    /// Determine if we should show the ATT section
    var shouldShowATTSection: Bool {
        // Don't show if already determined (authorized, denied, or restricted)
        return currentATTStatus == .notDetermined
    }

    /// Get text for ATT section
    var attSectionText: String {
        """
        Help us improve your experience by allowing anonymous usage metrics. \
        This data helps us understand how users interact with the app and guides our improvements.

        Your privacy is important to us - this data is used solely for UX improvements.
        """
    }

    // MARK: - Initialization

    /// Refresh all permission statuses from system
    func refreshAllPermissionStatuses() async {
        await checkPushPermissionStatus()
        checkATTPermissionStatus()
    }
}

// MARK: - Permission Status Enums

public enum ATTPermissionStatus: Equatable {
    case notDetermined
    case authorized
    case denied
    case restricted
}
