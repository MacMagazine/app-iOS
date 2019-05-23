//
//  AppDelegateStub.swift
//  MacMagazineTests
//
//  Created by Cassio Rossi on 23/05/2019.
//  Copyright © 2019 MacMagazine. All rights reserved.
//

import UIKit

// MARK: - AppDelegate setup -

extension AppDelegate {
	func setup(_ launchOptions: [UIApplication.LaunchOptionsKey: Any]?) {
	}
}

// MARK: - Splitview Delegate -

extension AppDelegate: UISplitViewControllerDelegate {
	func splitViewController(_ splitViewController: UISplitViewController, collapseSecondary secondaryViewController: UIViewController, onto primaryViewController: UIViewController) -> Bool {
		return false
	}
}

// MARK: - TabController Delegate -

extension AppDelegate: UITabBarControllerDelegate {
	// Tap 2x to Top
	func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
	}
}
