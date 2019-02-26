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
		guard let splitViewController = window?.rootViewController as? UISplitViewController else {
			return true
		}
		guard let navigationController = splitViewController.viewControllers[splitViewController.viewControllers.count - 1] as? UINavigationController else {
			return true
		}
		navigationController.topViewController?.navigationItem.leftBarButtonItem = splitViewController.displayModeButtonItem
		splitViewController.delegate = self

		return true
	}

	// MARK: - Split view

	func splitViewController(_ splitViewController: UISplitViewController, collapseSecondary secondaryViewController: UIViewController, onto primaryViewController: UIViewController) -> Bool {

	    guard let secondaryAsNavController = secondaryViewController as? UINavigationController else {
			return false
		}
	    guard let topAsDetailController = secondaryAsNavController.topViewController as? PostsDetailViewController else {
			return false
		}

		// Return true to indicate that we have handled the collapse by doing nothing;
		// the secondary controller will be discarded.
	    if topAsDetailController.detailItem == nil {
	        return true
	    }

		return false
	}

}
