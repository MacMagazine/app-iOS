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

    // MARK: - View lifecycle -

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        postURL = URL(string: "https://live.macmagazine.com.br/live.html\(Settings().isDarkMode ? "?theme=dark" : "")")
    }

    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        super.willTransition(to: newCollection, with: coordinator)

        coordinator.animate(alongsideTransition: nil) { _ in
            delay(0.8) {
                self.postURL = URL(string: "https://live.macmagazine.com.br/live.html\(Settings().isDarkMode ? "?theme=dark" : "")")
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
