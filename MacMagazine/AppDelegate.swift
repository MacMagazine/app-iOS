//
//  AppDelegate.swift
//  MacMagazine
//
//  Created by Cassio Rossi on 18/08/17.
//  Copyright © 2017 MacMagazine. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UISplitViewControllerDelegate {

	// MARK: - Properties -
	var window: UIWindow?

	// MARK: - Window lifecycle -

	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

		// Override point for customization after application launch.
        applyTheme()

		guard let tabBarViewController = window?.rootViewController as? UITabBarController else {
			return true
		}

		guard let splitViewController = tabBarViewController.viewControllers?.first as? UISplitViewController else {
			return true
		}
		splitViewController.delegate = self
		splitViewController.preferredDisplayMode = .allVisible
		splitViewController.preferredPrimaryColumnWidthFraction = 0.33

		return true
	}

	// MARK: - Splitview Delegate -

	func splitViewController(_ splitViewController: UISplitViewController, collapseSecondary secondaryViewController: UIViewController, onto primaryViewController: UIViewController) -> Bool {
		guard let secondaryAsNavController = secondaryViewController as? UINavigationController,
			let topAsDetailController = secondaryAsNavController.topViewController as? PostsDetailViewController
			else {
				return false
		}
		if topAsDetailController.link == nil {
			// Return true to indicate that we have handled the collapse by doing nothing; the secondary controller will be discarded.
			return true
		}
		return false
	}

	// MARK: - Theme -

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
