//
//  PlayerViewController.swift
//  MacMagazine
//
//  Created by Cassio Rossi on 03/04/2019.
//  Copyright © 2019 MacMagazine. All rights reserved.
//

import UIKit

struct Podcast {
    var title: String?
    var duration: String?
    var url: String?
	var frame: String?
}

class PlayerViewController: UIViewController {

    // MARK: - Properties -

	@IBOutlet private weak var scPlayer: SoundcloudPlayer!

	var show: ((Bool) -> Void)?
	var isHidden = true
	var frame: String?

    var podcast: Podcast? {
        didSet {
            scPlayer.soundEffect = nil

			if podcast?.frame == frame {
				if isHidden {
					show?(true)
					scPlayer?.play()
				} else {
					show?(false)
					scPlayer?.pause()
				}
				isHidden = !isHidden
			} else {
				if isHidden {
					show?(true)
					isHidden = false
				}
				frame = podcast?.frame
				loadPlayer()
			}
        }
    }

    // MARK: - Methods -

	fileprivate func loadPlayer() {
		if !self.isHidden {
			scPlayer.iFrame = podcast?.frame
		}
	}

}
