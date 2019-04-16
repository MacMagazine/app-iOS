//
//  VideosCollectionViewCell.swift
//  MacMagazine
//
//  Created by Cassio Rossi on 12/04/2019.
//  Copyright © 2019 MacMagazine. All rights reserved.
//

import Kingfisher
import UIKit

class VideosCollectionViewCell: UICollectionViewCell {

	// MARK: - Properties -

	@IBOutlet weak private var thumbnailImageView: UIImageView!
	@IBOutlet weak private var youtubeWebView: YouTubePlayer!
	@IBOutlet weak private var headlineLabel: UILabel!
	@IBOutlet weak private var subheadlineLabel: UILabel!
	@IBOutlet weak private var favorite: UIButton!
	@IBOutlet weak private var viewsLabel: UILabel!
	@IBOutlet weak private var likesLabel: UILabel!

	var videoId: String?
	let youTubeURL = "https://www.youtube.com/watch?v="

	// MARK: - Setup methods -

	func configureVideo(with object: Video) {
		videoId = object.videoId

		favorite.isSelected = object.favorite
		headlineLabel.text = object.title
		subheadlineLabel.text = object.pubDate?.watchDate()
		viewsLabel.text = object.views
		likesLabel.text = object.likes

		guard let artworkURL = object.artworkURL else {
			return
		}
		thumbnailImageView.kf.indicatorType = .activity
		thumbnailImageView.kf.setImage(with: URL(string: artworkURL), placeholder: UIImage(named: "image_Logo"))

		youtubeWebView?.videoId = object.videoId
		youtubeWebView?.scrollView.isScrollEnabled = false
	}

	// MARK: - Actions methods -

	@IBAction private func play(_ sender: Any) {
		youtubeWebView?.play()
	}

	@IBAction private func share(_ sender: Any) {
		guard let videoId = videoId,
			let title = headlineLabel.text
			else {
				return
		}
		let items: [Any] = [title, "\(youTubeURL)\(videoId)"]
		Share().present(at: self, using: items)
	}

	@IBAction private func favorite(_ sender: Any) {
		Favorite().updateVideoStatus(using: videoId) { isFavoriteOn in
			self.favorite.isSelected = isFavoriteOn
		}
	}

}
