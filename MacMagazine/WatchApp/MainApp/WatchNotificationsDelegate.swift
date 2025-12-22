import Foundation
import UserNotifications
import WatchKit
import WidgetKit

final class WatchNotificationsDelegate: NSObject, WKApplicationDelegate {

    func applicationDidFinishLaunching() {
        Task {
            let success = try await UNUserNotificationCenter.current().requestAuthorization(options: [.badge, .sound, .alert])
            guard success else { return }

            UNUserNotificationCenter.current().delegate = self
            await MainActor.run {
                WKApplication.shared().registerForRemoteNotifications()
            }
        }
    }
}

extension WatchNotificationsDelegate: UNUserNotificationCenterDelegate {
    func didRegisterForRemoteNotifications(withDeviceToken deviceToken: Data) {
        _ = deviceToken.reduce("") { $0 + String(format: "%02x", $1) }
        // OneSignalPushNotification.addDevice(token: token)
    }

    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        didReceive response: UNNotificationResponse
    ) async {
        handlePush(userInfo: response.notification.request.content.userInfo)
    }

    // MARK: - Push handling

    private func handlePush(userInfo: [AnyHashable: Any]) {
        // Atualiza as complicações
        WidgetCenter.shared.reloadTimelines(ofKind: "WatchWidget")
    }
}
