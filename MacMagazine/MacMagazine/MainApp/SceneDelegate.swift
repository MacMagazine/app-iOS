import LoggerLibrary
import MacMagazineLibrary
import SwiftUI
import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    func scene(_ scene: UIScene,
               willConnectTo session: UISceneSession,
               options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }

        let pushNotification = PushNotification()
        pushNotification.initialize(options: PushNotificationDefinition.options)

        let viewModel = MainViewModel(pushNotification: pushNotification)

        window = UIWindow(windowScene: windowScene)
        window?.rootViewController = UIHostingController(rootView: SceneView(viewModel: viewModel))
        window?.makeKeyAndVisible()

        if let shortcutItem = connectionOptions.shortcutItem {
            ShortcutManager.shared.pendingShortcut = shortcutItem
        }

        if let notificationResponse = connectionOptions.notificationResponse {
            let logger: LoggerProtocol = Logger(category: "MacMagazineV5")
            let additionalData = notificationResponse.notification.request.content.userInfo
            logger.debug(additionalData)
            if let url = additionalData["url"] as? String,
               !url.isEmpty {
                pushNotification.newContentAvailable = url
            }
        }
    }

    func windowScene(_ windowScene: UIWindowScene,
                     performActionFor shortcutItem: UIApplicationShortcutItem,
                     completionHandler: @escaping (Bool) -> Void) {
        ShortcutManager.shared.process(shortcut: shortcutItem)
        completionHandler(true)
    }
}
