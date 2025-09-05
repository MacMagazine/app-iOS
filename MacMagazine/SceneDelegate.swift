//
//  SceneDelegate.swift
//  MacMagazine
//
//  Created by Cassio Rossi on 20/08/2025.
//

import CoreSpotlight
import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    var shortcutAction: Notification.Name?
    var widgetSpotlightPost: String?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Ensure we have a valid UIWindowScene
        guard let windowScene = (scene as? UIWindowScene) else { return }

        window = UIWindow(windowScene: windowScene)
        let storyboard = UIStoryboard(name: "Splash", bundle: nil)
        let initialViewController = storyboard.instantiateInitialViewController()
        window?.rootViewController = initialViewController
        window?.makeKeyAndVisible()

        // Process any connection options (URLs, shortcuts, etc.)
        processConnectionOptions(connectionOptions)
    }

    // MARK: - Private Methods

    private func processConnectionOptions(_ options: UIScene.ConnectionOptions) {
        // Handle URL contexts (deep links, universal links)
        for urlContext in options.urlContexts {
            handleURL(urlContext.url)
        }

        // Handle shortcut items
        if let shortcutItem = options.shortcutItem {
            handleShortcutItem(shortcutItem)
        }

        // Handle user activities (Handoff, Spotlight, etc.)
        for userActivity in options.userActivities {
            handleUserActivity(userActivity)
        }

        // Handle notification responses
        if let notificationResponse = options.notificationResponse {
            handleNotificationResponse(notificationResponse)
        }
    }

    func sceneDidDisconnect(_ scene: UIScene) {}
    func sceneDidBecomeActive(_ scene: UIScene) {}
    func sceneWillResignActive(_ scene: UIScene) {}
    func sceneWillEnterForeground(_ scene: UIScene) {}
    func sceneDidEnterBackground(_ scene: UIScene) {}
}

// MARK: - URL and Shortcut Handling

extension SceneDelegate {
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        // Handle URLs when the app is already running
        for urlContext in URLContexts {
            handleURL(urlContext.url)
        }
    }

    func windowScene(_ windowScene: UIWindowScene, performActionFor shortcutItem: UIApplicationShortcutItem, completionHandler: @escaping (Bool) -> Void) {
        // Handle shortcut items when the app is already running
        handleShortcutItem(shortcutItem)
        completionHandler(true)
    }

    func scene(_ scene: UIScene, continue userActivity: NSUserActivity) {
        // Handle user activities when the app is already running
        handleUserActivity(userActivity)
    }
}

// MARK: - Shortcut -

extension SceneDelegate {
    private func handleShortcutItem(_ shortcutItem: UIApplicationShortcutItem) {
        // Handle app shortcut items (3D Touch shortcuts, etc.)
        if shortcutItem.type == "openLastSeenPost" ||
            shortcutItem.type == "openMostRecentPost" ||
            shortcutItem.type == "openSearchPost" {

            let shortcutItem = ShortcutActions(rawValue: shortcutItem.type) ?? .none

            guard let tabController = Settings.rootViewController as? UITabBarController else {
                shortcutAction = shortcutItem.notificationName
                return
            }
            tabController.selectedIndex = 0

            guard let notificationName = shortcutItem.notificationName else { return }
            NotificationCenter.default.post(name: notificationName, object: nil)
        }
    }
}

// MARK: - Spotlight search -

extension SceneDelegate {
    private func handleUserActivity(_ userActivity: NSUserActivity) {
        // Handle user activities (Handoff, Spotlight search, etc.)
        if userActivity.activityType == CSSearchableItemActionType,
            let identifier = userActivity.userInfo?[CSSearchableItemActivityIdentifier] as? String {
            if Settings.rootViewController is UITabBarController {
                showDetailController(with: identifier)
            } else {
                widgetSpotlightPost = identifier
            }
        }
    }
}

extension SceneDelegate {
    private func handleURL(_ url: URL) {
        // Handle incoming URLs (deep links, universal links)
        widgetSpotlightPost = url.absoluteString
        NotificationCenter.default.post(name: .showPostFromWidget, object: url.absoluteString)
    }

    private func handleNotificationResponse(_ notificationResponse: UNNotificationResponse) {
        // Handle notification responses
        logD(notificationResponse.notification.request.identifier)
        // Implement your notification handling logic here
    }
}
