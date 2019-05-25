//
//  VideosCollectionViewCell.swift
//  MacMagazine
//
//  Created by Cassio Rossi on 12/04/2019.
//  Copyright © 2019 MacMagazine. All rights reserved.
//

import AVFoundation
import Kingfisher
import UIKit
import WebKit

class VideosCollectionViewCell: AppCollectionViewCell {

	// MARK: - Properties -

	@IBOutlet weak private var playButton: UIButton!
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
		favorite.isEnabled = true

		headlineLabel.text = object.title
		subheadlineLabel.text = object.pubDate?.watchDate()
		viewsLabel.text = object.views
		likesLabel.text = object.likes

		guard let artworkURL = object.artworkURL else {
			return
		}
		thumbnailImageView.kf.indicatorType = .activity
		thumbnailImageView.kf.setImage(with: URL(string: artworkURL), placeholder: UIImage(named: "image_logo_feature"))

		youtubeWebView?.scrollView.isScrollEnabled = false
		youtubeWebView?.configuration.userContentController.removeScriptMessageHandler(forName: "videoPaused")
		youtubeWebView?.configuration.userContentController.add(self, name: "videoPaused")

		youtubeWebView?.videoId = object.videoId
	}

	func configureVideo(with object: JSONVideo) {
		videoId = object.videoId

		favorite.isSelected = false
		favorite.isEnabled = false

		headlineLabel.text = object.title
		subheadlineLabel.text = object.pubDate.toDate(Format.youtube).watchDate()
		viewsLabel.text = object.views
		likesLabel.text = object.likes

		thumbnailImageView.kf.indicatorType = .activity
		thumbnailImageView.kf.setImage(with: URL(string: object.artworkURL), placeholder: UIImage(named: "image_logo_feature"))

		youtubeWebView?.scrollView.isScrollEnabled = false
		youtubeWebView?.configuration.userContentController.removeScriptMessageHandler(forName: "videoPaused")
		youtubeWebView?.configuration.userContentController.add(self, name: "videoPaused")

		youtubeWebView?.videoId = object.videoId
	}

	// MARK: - Actions methods -

	@IBAction private func play(_ sender: Any) {
		thumbnailImageView.isHidden = true
		playButton.isHidden = true
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

extension VideosCollectionViewCell: WKScriptMessageHandler {
	func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
		if message.name == "videoPaused" {
			self.thumbnailImageView.isHidden = false
			self.playButton.isHidden = false
		}
	}
}
