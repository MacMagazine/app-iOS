//
//  MMLiveViewController.swift
//  MacMagazine
//
//  Created by Cassio Rossi on 08/03/21.
//  Copyright © 2021 MacMagazine. All rights reserved.
//

import SafariServices
import UIKit
import WebKit

class MMLiveViewController: WebViewController {

    let liveURL = "https://macmagazine.com.br/live"

    // MARK: - View lifecycle -

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        postURL = URL(string: liveURL)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        if (UIApplication.shared.delegate as? AppDelegate)?.widgetSpotlightPost != nil {
            TabBarController.shared.selectIndex(1)
        }
    }

    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        super.willTransition(to: newCollection, with: coordinator)

        coordinator.animate(alongsideTransition: nil) { [weak self] _ in
            delay(0.8) {
                guard let self = self else { return }
                self.postURL = URL(string: self.liveURL)
                NotificationCenter.default.post(name: .reloadWeb, object: nil)
            }
        }
    }

    @IBAction private func refresh(_ sender: Any) {
        reload()
    }

    // MARK: - Override -

    override func setRightButtomItems(_ buttons: [RightButtons]) {}
    override func webView(_ webView: WKWebView, didFinish navigation: WKNavigation) {}
}
