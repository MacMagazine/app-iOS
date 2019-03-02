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

	var window: UIWindow?

	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

		// Override point for customization after application launch.
        applyTheme()

		guard let splitViewController = window?.rootViewController as? UISplitViewController else {
			return true
		}
		splitViewController.delegate = self
		splitViewController.preferredDisplayMode = .allVisible
		splitViewController.preferredPrimaryColumnWidthFraction = 0.33

		return true
	}

	// MARK: - Split view

	func splitViewController(_ splitViewController: UISplitViewController, collapseSecondary secondaryViewController: UIViewController, onto primaryViewController: UIViewController) -> Bool {
		return false
	}

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
