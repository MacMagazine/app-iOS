//
//  SplashViewController.swift
//  MacMagazine
//
//  Created by Cassio Rossi on 08/06/2019.
//  Copyright © 2019 MacMagazine. All rights reserved.
//

import UIKit

class SplashViewController: UIViewController {

	@IBOutlet private weak var logo: UIImageView!

	override func viewDidLoad() {
		super.viewDidLoad()
	}

	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)

        logo.image = UIImage(named: "logo\(Settings().darkModeimage)")

        delay(0.6) {
			let storyboard = UIStoryboard(name: "Main", bundle: nil)
            guard let controller = storyboard.instantiateViewController(withIdentifier: "main") as? UITabBarController,
                let appDelegate = UIApplication.shared.delegate as? AppDelegate,
                let splitViewController = controller.viewControllers?.first as? UISplitViewController,
                let window = UIApplication.shared.windows.first(where: { $0.isKeyWindow })
                else {
                    return
            }

			controller.delegate = appDelegate

			splitViewController.delegate = appDelegate
			splitViewController.preferredDisplayMode = .allVisible
			splitViewController.preferredPrimaryColumnWidthFraction = 0.33

            UIView.transition(with: window,
                              duration: 0.4,
                              options: .transitionCrossDissolve,
                              animations: {
                window.rootViewController = controller
            }, completion: { _ in
                guard let navVC = splitViewController.viewControllers.first as? UINavigationController,
                    let vc = navVC.viewControllers.first as? PostsMasterViewController
                    else {
                        return
                }
                vc.setup()
            })
		}
	}

}

extension SplashViewController {
	func delay(_ delay: Double, closure: @escaping () -> Void) {
		let when = DispatchTime.now() + delay
		DispatchQueue.main.asyncAfter(deadline: when, execute: closure)
	}
}
