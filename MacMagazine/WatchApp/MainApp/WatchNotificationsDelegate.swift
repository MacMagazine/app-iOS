import Foundation
import LoggerLibrary
import MacMagazineLibrary
import UserNotifications
import WatchKit
import WidgetKit

final class WatchNotificationsDelegate: NSObject, WKApplicationDelegate {
    let logger = Logger(category: "MacMagazineV5")
    var viewModel: FeedMainViewModel?

    func applicationDidFinishLaunching() {
        Task {
            let notificationCenter = UNUserNotificationCenter.current()
            notificationCenter.delegate = self

            let success = try await notificationCenter.requestAuthorization(options: [.badge, .sound, .alert])
            guard success else { return }

            await MainActor.run {
                WKApplication.shared().registerForRemoteNotifications()
            }
        }
    }

    func didRegisterForRemoteNotifications(withDeviceToken deviceToken: Data) {
        let token = deviceToken.reduce("") { $0 + String(format: "%02x", $1) }
        PushNotification.addDevice(with: token)
    }
}

extension WatchNotificationsDelegate: UNUserNotificationCenterDelegate {
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        didReceive response: UNNotificationResponse
    ) async {
        logger.debug(response)
        handlePush(userInfo: response.notification.request.content.userInfo)
    }

    private func handlePush(userInfo: [AnyHashable: Any]) {
        logger.debug(userInfo)
        WidgetCenter.shared.reloadAllTimelines()

        guard let custom = userInfo["custom"] as? [String: Any],
              let additionalData = custom["a"] as? [String: Any],
              let url = additionalData["url"] as? String, !url.isEmpty
        else { return }

        Task { @MainActor in
            viewModel?.pendingPushLink = url
        }
    }
}
