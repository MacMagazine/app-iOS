import SwiftUI

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    func scene(_ scene: UIScene, willConnectTo
               session: UISceneSession,
               options connectionOptions: UIScene.ConnectionOptions) {
        if let shortcutItem = connectionOptions.shortcutItem {
            ShortcutManager.shared.pendingShortcut = shortcutItem
        }
    }

    func windowScene(_ windowScene: UIWindowScene,
                     performActionFor shortcutItem: UIApplicationShortcutItem) async -> Bool {
        ShortcutManager.shared.process(shortcut: shortcutItem)
        return true
    }
}
