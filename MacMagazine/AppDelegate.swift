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

		setup(launchOptions)

		return true
	}

}
