import FirebaseCore
import LoggerLibrary
import MacMagazineLibrary
import UIKit

final class AppDelegate: NSObject, UIApplicationDelegate {
    private var logger: LoggerProtocol = Logger(category: "MacMagazineV5")

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        configureFirebaseIfAvailable()
        PushNotificationDefinition.options = launchOptions
        return true
    }

    // MARK: - Scene Configuration

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession,
                     options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        if let shortcutItem = options.shortcutItem {
            ShortcutManager.shared.pendingShortcut = shortcutItem
        }

        let config = UISceneConfiguration(name: nil,
                                          sessionRole: connectingSceneSession.role)
        config.delegateClass = SceneDelegate.self
        return config
    }
}

// MARK: - Analytics -

private extension AppDelegate {
    func configureFirebaseIfAvailable() {
        guard let plistPath = Bundle.main.path(forResource: "GoogleService-Info", ofType: "plist"),
              FileManager.default.fileExists(atPath: plistPath) else {
            return
        }

        if let plistDict = NSDictionary(contentsOfFile: plistPath),
           let apiKey = plistDict["API_KEY"] as? String,
           apiKey.contains("YOUR_API_KEY_HERE") {
            return
        }

        FirebaseApp.configure()
    }
}

// MARK: - Push Notifications -

extension AppDelegate {
    func application(_ application: UIApplication,
                     didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        logger.debug(deviceToken)
    }

    func application(_ application: UIApplication,
                     didFailToRegisterForRemoteNotificationsWithError error: Error) {
        logger.error(error.localizedDescription)
    }

    func application(_ application: UIApplication,
                     didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        logger.debug(userInfo["aps"] ?? "")
        completionHandler(.noData)
    }
}
