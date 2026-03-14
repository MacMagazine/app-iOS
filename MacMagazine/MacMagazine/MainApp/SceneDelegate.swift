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
    }

    func windowScene(_ windowScene: UIWindowScene,
                     performActionFor shortcutItem: UIApplicationShortcutItem,
                     completionHandler: @escaping (Bool) -> Void) {
        ShortcutManager.shared.process(shortcut: shortcutItem)
        completionHandler(true)
    }
}
