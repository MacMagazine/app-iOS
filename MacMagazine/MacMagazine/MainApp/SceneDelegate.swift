import LoggerLibrary
import MacMagazineLibrary
import SwiftUI
import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    let pushNotification = PushNotification()
    private var viewModel: MainViewModel?

    func scene(_ scene: UIScene,
               willConnectTo session: UISceneSession,
               options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }

        pushNotification.initialize(options: PushNotificationDefinition.options)
        (UIApplication.shared.delegate as? AppDelegate)?.pushNotification = pushNotification

        let viewModel = MainViewModel(pushNotification: pushNotification)
        self.viewModel = viewModel

        window = UIWindow(windowScene: windowScene)
        window?.rootViewController = UIHostingController(rootView: SceneView(viewModel: viewModel))
        window?.makeKeyAndVisible()

        if let shortcutItem = connectionOptions.shortcutItem {
            ShortcutManager.shared.pendingShortcut = shortcutItem
        }
        openDeepLink(from: connectionOptions.urlContexts)
    }

    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        openDeepLink(from: URLContexts)
    }

    private func openDeepLink(from contexts: Set<UIOpenURLContext>) {
        guard let url = contexts.first?.url else { return }
        viewModel?.openDeepLink(url)
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
