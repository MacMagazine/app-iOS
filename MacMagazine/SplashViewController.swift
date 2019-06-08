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
		logo.image = UIImage(named: "logo\(Settings().isDarkMode() ? "_dark" : "")")
	}

	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)

		delay(0.6) {
			let storyboard = UIStoryboard(name: "Main", bundle: nil)
			guard let controller = storyboard.instantiateViewController(withIdentifier: "main") as? UITabBarController,
				let appDelegate = UIApplication.shared.delegate as? AppDelegate,
				let splitViewController = controller.viewControllers?.first as? UISplitViewController
				else {
					return
			}

			controller.delegate = appDelegate

			splitViewController.delegate = appDelegate
			splitViewController.preferredDisplayMode = .allVisible
			splitViewController.preferredPrimaryColumnWidthFraction = 0.33

			UIApplication.shared.keyWindow?.rootViewController = controller
		}
	}

}

extension SplashViewController {
	func delay(_ delay: Double, closure: @escaping () -> Void) {
		let when = DispatchTime.now() + delay
		DispatchQueue.main.asyncAfter(deadline: when, execute: closure)
	}
}