//
//  AppDelegate.swift
//  MacMagazine
//
//  Created by Cassio Rossi on 18/08/17.
//  Copyright © 2017 MacMagazine. All rights reserved.
//

import OneSignal
import StoreKit
import UIKit

extension Notification.Name {
	static let shortcutAction = Notification.Name("shortcutAction")
	static let reloadWeb = Notification.Name("reloadWeb")
	static let scrollToTop = Notification.Name("scrollToTop")
	static let favoriteUpdated = Notification.Name("favoriteUpdated")
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

	// MARK: - Properties -

	var window: UIWindow?
	var previousController: UIViewController?

	// MARK: - Window lifecycle -

	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

		// Override point for customization after application launch.
        applyTheme()

		guard let tabBarViewController = window?.rootViewController as? UITabBarController else {
			return true
		}
		tabBarViewController.delegate = self

		guard let splitViewController = tabBarViewController.viewControllers?.first as? UISplitViewController else {
			return true
		}
		splitViewController.delegate = self
		splitViewController.preferredDisplayMode = .allVisible
		splitViewController.preferredPrimaryColumnWidthFraction = 0.33

		WatchSessionManager.shared.startSession()

		if Settings().shouldAskForReview() {
			SKStoreReviewController.requestReview()
		}

		// Prod
//		let key: [UInt8] = [114, 66, 66, 33, 7, 95, 7, 81, 76, 21, 6, 42, 97, 98, 86, 91, 80, 6, 89, 35, 20, 18, 116, 72, 14, 87, 1, 81, 18, 85, 123, 55, 120, 4, 89, 81]
		// Dev
		let key: [UInt8] = [119, 69, 68, 114, 4, 15, 81, 94, 76, 17, 84, 121, 98, 98, 86, 83, 6, 84, 89, 32, 18, 69, 118, 72, 8, 85, 85, 82, 77, 6, 124, 54, 41, 83, 83, 86]

		OneSignal.initWithLaunchOptions(launchOptions, appId: Obfuscator().reveal(key: key), handleNotificationAction: nil, settings: [kOSSettingsKeyAutoPrompt: false])
		OneSignal.inFocusDisplayType = OSNotificationDisplayType.notification
		OneSignal.promptForPushNotifications(userResponse: { accepted in
			logI("User accepted notifications: \(accepted)")
		})

		let _: OSHandleNotificationReceivedBlock = { notification in
			logD("Received Notification: \(notification!.payload.notificationID)")
			logD("launchURL = \(notification?.payload.launchURL ?? "None")")
			logD("content_available = \(notification?.payload.contentAvailable ?? false)")
		}

		return true
	}

}

// MARK: - Theme -

extension AppDelegate {
	fileprivate func applyTheme() {
		guard let isDarkMode = UserDefaults.standard.object(forKey: "darkMode") as? Bool else {
			let theme: Theme = LightTheme()
			theme.apply(for: UIApplication.shared)

			return
		}
		let theme: Theme = isDarkMode ? DarkTheme() : LightTheme()
		theme.apply(for: UIApplication.shared)
	}
}

// MARK: - Splitview Delegate -

extension AppDelegate: UISplitViewControllerDelegate {
	func splitViewController(_ splitViewController: UISplitViewController, collapseSecondary secondaryViewController: UIViewController, onto primaryViewController: UIViewController) -> Bool {
		guard let secondaryAsNavController = secondaryViewController as? UINavigationController,
			let topAsDetailController = secondaryAsNavController.topViewController as? PostsDetailViewController
			else {
				return false
		}
		return topAsDetailController.links.isEmpty
	}
}

// MARK: - TabController Delegate -

extension AppDelegate: UITabBarControllerDelegate {
	// Tap 2x to Top
	func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
		if let navVC = viewController as? UINavigationController,
			let vc = navVC.children[0] as? UITableViewController {
			if previousController == vc {
				vc.tableView.setContentOffset(.zero, animated: true)
			}
			previousController = vc
		} else if let navVC = viewController as? UINavigationController,
			let vc = navVC.children[0] as? PodcastViewController {
			if previousController == vc {
				NotificationCenter.default.post(name: .scrollToTop, object: nil)
			}
			previousController = vc
		} else if let splitVC = viewController as? UISplitViewController,
			let navVC = splitVC.children[0] as? UINavigationController,
			let vc = navVC.children[0] as? PostsMasterViewController {
			if previousController == vc || previousController == nil {
				vc.tableView.setContentOffset(.zero, animated: true)
			}
			previousController = vc
		}
	}
}

// MARK: - Shortcut -

extension AppDelegate {
	func application(_ application: UIApplication, performActionFor shortcutItem: UIApplicationShortcutItem, completionHandler: @escaping (Bool) -> Void) {
		if shortcutItem.type == "openLastPost" {
			NotificationCenter.default.post(name: .shortcutAction, object: nil)
		}
	}
}
