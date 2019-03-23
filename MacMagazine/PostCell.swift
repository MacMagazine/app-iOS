//
//  PostCell.swift
//  MacMagazine
//
//  Created by Cassio Rossi on 03/09/17.
//  Copyright © 2017 MacMagazine. All rights reserved.
//

import AVFoundation
import Kingfisher
import UIKit

class PostCell: UITableViewCell {

	// MARK: - Properties -

	@IBOutlet private weak var playButton: UIButton!
	@IBOutlet private weak var headlineLabel: UILabel!
	@IBOutlet private weak var subheadlineLabel: UILabel!
	@IBOutlet private weak var lengthlineLabel: UILabel!
	@IBOutlet private weak var thumbnailImageView: UIImageView!
	@IBOutlet private weak var favoriteImageView: UIImageView!

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

    func configurePost(_ object: Posts) {
        headlineLabel?.text = object.title

        if object.categorias.contains("Destaques") == false {
            if subheadlineLabel != nil {
                subheadlineLabel?.text = object.excerpt
            }
        }

        thumbnailImageView.kf.indicatorType = .activity
        thumbnailImageView.kf.setImage(with: URL(string: object.artworkURL), placeholder: UIImage(named: "image_Logo"))

        favoriteImageView.alpha = (object.favorite ? 1 : 0)
    }

	func configureSearchPost(_ object: XMLPost) {
		headlineLabel?.text = object.title

		if object.categories.contains("Destaques") == false {
			if subheadlineLabel != nil {
				subheadlineLabel?.text = object.excerpt
			}
		}

		thumbnailImageView.kf.indicatorType = .activity
		thumbnailImageView.kf.setImage(with: URL(string: object.artworkURL), placeholder: UIImage(named: "image_Logo"))

		favoriteImageView.isHidden = true
	}

	func configurePodcast(_ object: Posts) {
		headlineLabel?.text = object.title
		subheadlineLabel?.text = object.pubDate.cellDate()
		lengthlineLabel?.text = "duração: \(object.duration)"

		favoriteImageView.isHidden = !object.favorite

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

	func configureSearchPodcast(_ object: XMLPost) {
		headlineLabel?.text = object.title
		subheadlineLabel?.text = object.pubDate.toDate(nil).cellDate()
		lengthlineLabel?.text = object.duration.isEmpty ? nil : "duração: \(object.duration)"

		favoriteImageView.isHidden = true

		playButton.isEnabled = !object.podcastURL.isEmpty
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
