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
            logD(widgetSpotlightPost)

            // Push Notification or Widget tapped
//            var appNotReady = true
//
//            while appNotReady {
//                DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
//                    let tabController = UIApplication.shared.windows.first(where: { $0.isKeyWindow })?.rootViewController as? UITabBarController
//                    if tabController != nil {
//                        appNotReady = false
//                        tabController?.selectedIndex = self.isMMLive ? 1 : 0
//                    } else {
//                        logE(tabController)
//                    }
//                }
//            }
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
