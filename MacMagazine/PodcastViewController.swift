//
//  PodcastViewController.swift
//  MacMagazine
//
//  Created by Cassio Rossi on 03/04/2019.
//  Copyright © 2019 MacMagazine. All rights reserved.
//

import UIKit

class PodcastViewController: UIViewController {

    @IBOutlet private weak var playerHeight: NSLayoutConstraint!

    // MARK: - View lifecycle -

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        guard let vc = self.children[0] as? PodcastMasterViewController else {
            return
        }
        vc.showWebView = showWebView
        vc.play = play
    }

    // MARK: - Actions -

    @IBAction private func showFavorites(_ sender: Any) {
        guard let vc = self.children[0] as? PodcastMasterViewController else {
            return
        }
        vc.showFavoritesAction()
    }

    // MARK: - Methods -

    fileprivate func showWebView(_ show: Bool) {
        playerHeight.constant = show ? 200.0 : 0.0
        UIView.animate(withDuration: 0.4) {
            self.view.layoutIfNeeded()
        }
        if !show {
            play(nil)
        }
    }

    fileprivate func play(_ podcast: Podcast?) {
        guard let vc = self.children[1] as? PlayerViewController else {
            return
        }
        vc.podcast = podcast
    }

}
