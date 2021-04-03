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
    var supportedInterfaceOrientation: UIInterfaceOrientationMask = .all

    var isMMLive: Bool = false

    var widgetSpotlightPost: String? {
        didSet {
            // Move to 2nd tab
            guard let tabController = UIApplication.shared.windows.first(where: { $0.isKeyWindow })?.rootViewController as? UITabBarController else {
                return
            }
            tabController.selectedIndex = isMMLive ? 1 : 0
        }
    }

    var shortcutAction: Notification.Name?

	// MARK: - Window lifecycle -

	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

		// Override point for customization after application launch.
		setup(launchOptions)

		return true
	}

    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return supportedInterfaceOrientation
    }

}
