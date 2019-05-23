//
//  AppDelegate.swift
//  MacMagazine
//
//  Created by Cassio Rossi on 18/08/17.
//  Copyright © 2017 MacMagazine. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

	// MARK: - Properties -

	var window: UIWindow?
	var previousController: UIViewController?

	// MARK: - Window lifecycle -

	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

		// Override point for customization after application launch.
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

		// Apply custom thmee (Dark/Light)
//		applyTheme()

		// Apple Watch Session
//		WatchSessionManager.shared.startSession()

		// AppStore Review
//		if Settings().shouldAskForReview() {
//			SKStoreReviewController.requestReview()
//		}

		// Push Notification
//		PushNotification().setup(options: launchOptions)

		return true
	}

}
