//
//  PodcastCell.swift
//  MacMagazine
//
//  Created by Cassio Rossi on 01/03/2019.
//  Copyright © 2019 MacMagazine. All rights reserved.
//

import AVFoundation
import UIKit

class PodcastCell: UITableViewCell {

	// MARK: - Properties -

	@IBOutlet private weak var playButton: UIButton!
	@IBOutlet private weak var headlineLabel: UILabel!
	@IBOutlet private weak var subheadlineLabel: UILabel!
	@IBOutlet private weak var lengthlineLabel: UILabel!

	fileprivate var player: AVPlayer?

	// MARK: - Methods -

	override func awakeFromNib() {
		super.awakeFromNib()
		// Initialization code
	}

	override func setSelected(_ selected: Bool, animated: Bool) {
		super.setSelected(selected, animated: animated)
		// Configure the view for the selected state
	}

	func configurePodcast(_ object: Posts) {
		headlineLabel?.text = object.title
		subheadlineLabel?.text = object.pubDate.cellDate()
		lengthlineLabel?.text = "duração: \(object.duration)"

		if !object.podcastURL.isEmpty {
			let podcastURL = object.podcastURL
			guard let url = URL(string: podcastURL) else {
				return
			}
			player = AVPlayer(playerItem: AVPlayerItem(url: url))
			let playerLayer = AVPlayerLayer(player: player)
			playerLayer.frame = CGRect(x: 0, y: 0, width: 10, height: 10)
			self.contentView.layoutSublayers(of: playerLayer)
		}
	}

	@IBAction private func play(_ sender: Any) {
		if player?.rate == 0 {
			player?.play()
			playButton.isSelected = true
		} else {
			player?.pause()
			playButton.isSelected = false
		}
	}

}
