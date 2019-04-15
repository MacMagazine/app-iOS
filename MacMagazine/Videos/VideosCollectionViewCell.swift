//
//  VideosCollectionViewCell.swift
//  MacMagazine
//
//  Created by Cassio Rossi on 12/04/2019.
//  Copyright © 2019 MacMagazine. All rights reserved.
//

import UIKit

class VideosCollectionViewCell: UICollectionViewCell {

	// MARK: - Properties -

	@IBOutlet weak private var youtubeWebView: YouTubePlayer!
	@IBOutlet weak private var headlineLabel: UILabel!
	@IBOutlet weak private var subheadlineLabel: UILabel!
	@IBOutlet weak private var favorite: UIButton!

	var videoId: String?
	let youTubeURL = "https://www.youtube.com/watch?v="

	// MARK: - Setup methods -

	func configureVideo(with object: Video) {
		videoId = object.videoId

		headlineLabel.text = object.title
		subheadlineLabel.text = object.pubDate?.watchDate()
		youtubeWebView?.videoId = object.videoId
		favorite.isSelected = object.favorite
	}

	// MARK: - Actions methods -

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
