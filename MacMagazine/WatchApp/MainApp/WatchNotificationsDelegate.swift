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
        guard
            let postId = userInfo["postId"] as? String,
            let title = userInfo["title"] as? String,
            !postId.isEmpty,
            !title.isEmpty
        else {
            return
        }

        let date: Date = {
            if let time = userInfo["date"] as? TimeInterval {
                return Date(timeIntervalSince1970: time)
            }
            if let iso = userInfo["date"] as? String,
               let date = ISO8601DateFormatter().date(from: iso) {
                return date
            }
            return Date()
        }()

        MacMagazineWidgetSharedStore.write(
            snapshot: .init(
                postId: postId,
                title: title,
                date: date
            )
        )

        // Atualiza as complicações
        WidgetCenter.shared.reloadTimelines(ofKind: "WidgetWatch")
    }
}
