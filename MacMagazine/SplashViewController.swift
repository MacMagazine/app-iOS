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

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        view.backgroundColor = Settings().isDarkMode ? .black : .white
        logo.image = UIImage(named: "splash\(Settings().isDarkMode ? "_dark" : "")")

        API.isMMLive { isLive in
            delay(0.6) {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)

                guard let controller = storyboard.instantiateViewController(withIdentifier: "main") as? UITabBarController,
                      let appDelegate = UIApplication.shared.delegate as? AppDelegate,
                      let splitViewController = controller.viewControllers?[1] as? UISplitViewController,
                      let window = UIApplication.shared.windows.first(where: { $0.isKeyWindow }) else {
                    return
                }

                splitViewController.delegate = appDelegate
                splitViewController.preferredDisplayMode = .allVisible
                splitViewController.preferredPrimaryColumnWidthFraction = 0.33

                UIView.transition(with: window,
                                  duration: 0.4,
                                  options: .transitionCrossDissolve,
                                  animations: {
                                    window.rootViewController = controller
                                    if !isLive {
                                        TabBarController.shared.removeIndexes([0])
                                    }
                                  })
            }
        }
	}

}
