import Foundation
import UserNotifications
import WatchKit
import WidgetKit

final class WatchNotificationsDelegate: NSObject,
                                        WKApplicationDelegate,
                                        UNUserNotificationCenterDelegate {

    func applicationDidFinishLaunching() {
        UNUserNotificationCenter.current().delegate = self
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
