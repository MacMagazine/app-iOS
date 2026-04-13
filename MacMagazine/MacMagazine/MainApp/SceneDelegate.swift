import LoggerLibrary
import MacMagazineLibrary
import SwiftUI
import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    let pushNotification = PushNotification()
    private var logger: LoggerProtocol = Logger(category: "MacMagazineV5")

    func scene(_ scene: UIScene,
               willConnectTo session: UISceneSession,
               options connectionOptions: UIScene.ConnectionOptions) {
        logger.debug("")
        guard let windowScene = (scene as? UIWindowScene) else { return }

        pushNotification.initialize(options: PushNotificationDefinition.options)
        (UIApplication.shared.delegate as? AppDelegate)?.pushNotification = pushNotification

        let viewModel = MainViewModel(pushNotification: pushNotification)

        window = UIWindow(windowScene: windowScene)
        window?.rootViewController = UIHostingController(rootView: SceneView(viewModel: viewModel))
        window?.makeKeyAndVisible()

        if let shortcutItem = connectionOptions.shortcutItem {
            ShortcutManager.shared.pendingShortcut = shortcutItem
        }

        if let pushNotification = (UIApplication.shared.delegate as? AppDelegate)?.pushNotification {
            logger.debug(pushNotification.shouldReloadContent)
        } else {
            logger.error("pushNotification not init")
        }
    }

    func windowScene(_ windowScene: UIWindowScene,
                     performActionFor shortcutItem: UIApplicationShortcutItem,
                     completionHandler: @escaping (Bool) -> Void) {
        ShortcutManager.shared.process(shortcut: shortcutItem)
        completionHandler(true)
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        pushNotification.resetBadge()
    }
}
