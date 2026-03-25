import FirebaseCore
import LoggerLibrary
import MacMagazineLibrary
import UIKit

final class AppDelegate: NSObject, UIApplicationDelegate {
    var pushNotification: PushNotification?
    private var logger: LoggerProtocol = Logger(category: "MacMagazineV5")

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        configureFirebaseIfAvailable()
        PushNotificationDefinition.options = launchOptions
        return true
    }

    private func applicationDidBecomeActive(_ notification: Notification) {
        pushNotification?.resetBadge()
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
        logger.debug(userInfo)
        guard let aps = userInfo["aps"] as? [String: Any],
              let contentAvailable = aps["content-available"] as? Int,
              contentAvailable == 1 else {
            completionHandler(.noData)
            return
        }

        pushNotification?.shouldReloadContent = true

        guard let custom = userInfo["custom"] as? [String: Any],
              let additionalData = custom["a"] as? [String: Any],
              let url = additionalData["url"] as? String,
              !url.isEmpty else {
            completionHandler(.newData)
            return
        }

        logger.debug(url)
        pushNotification?.newContentAvailable = url

        completionHandler(.newData)
    }
}
