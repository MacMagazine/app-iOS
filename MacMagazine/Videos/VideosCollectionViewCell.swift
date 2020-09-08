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
	@IBOutlet weak private var durationLabel: PaddingLabel!
    @IBOutlet weak private var share: AppButton!

	var videoId: String?
	let youTubeURL = "https://www.youtube.com/watch?v="

	// MARK: - Setup methods -

	func configureVideo(with object: Video) {
		videoId = object.videoId

		favorite.isSelected = object.favorite
		favorite.isEnabled = true
        setFavoriteButtonAccessibility(isEnabled: object.favorite)

		headlineLabel.text = object.title
        headlineLabel.accessibilityLabel = "Título: \(object.title ?? "Não especificado.")"
        setLines(for: headlineLabel)
		subheadlineLabel.text = object.pubDate?.watchDate()
        subheadlineLabel.isAccessibilityElement = true
        subheadlineLabel.accessibilityLabel = object.pubDate?.watchDate().setDateAndTimeAccessibility()
		viewsLabel.text = object.views
        viewsLabel.accessibilityLabel = "Total de visualizações: \(object.views ?? "Não informado.")."
		likesLabel.text = object.likes
        likesLabel.accessibilityLabel = "Total de curtidas: \(object.likes ?? "Não informado.")."
		durationLabel.text = object.duration?.toSubHeaderDate()
        durationLabel.accessibilityLabel = object.duration?.toSubHeaderDate().setTimeAccessibility()

		guard let artworkURL = object.artworkURL else {
			return
		}
		thumbnailImageView.kf.indicatorType = .activity
		thumbnailImageView.kf.setImage(with: URL(string: artworkURL), placeholder: UIImage(named: "image_logo_feature\(Settings().darkModeimage)"))

		youtubeWebView?.scrollView.isScrollEnabled = false
		youtubeWebView?.configuration.userContentController.removeScriptMessageHandler(forName: "videoPaused")
		youtubeWebView?.configuration.userContentController.add(self, name: "videoPaused")
        youtubeWebView.isAccessibilityElement = false

		youtubeWebView?.videoId = object.videoId

        accessibilityElements = [playButton as Any,
                                 durationLabel as Any,
                                 subheadlineLabel as Any,
                                 headlineLabel as Any,
                                 viewsLabel as Any,
                                 likesLabel as Any,
                                 favorite as Any,
                                 share as Any]
	}

	func configureVideo(with object: JSONVideo) {
		videoId = object.videoId

		favorite.isSelected = false
		favorite.isEnabled = false
        setFavoriteButtonAccessibility(isEnabled: false)

		headlineLabel.text = object.title
        headlineLabel.accessibilityLabel = "Título: \(object.title)"
        setLines(for: headlineLabel)
        subheadlineLabel.text = object.pubDate.toDate(Format.youtube).watchDate()
        subheadlineLabel.isAccessibilityElement = true
        subheadlineLabel.accessibilityLabel = object.pubDate.toDate(Format.youtube).watchDate().setDateAndTimeAccessibility()
		viewsLabel.text = object.views
        viewsLabel.accessibilityLabel = "Total de visualizações: \(object.views)."
		likesLabel.text = object.likes
        likesLabel.accessibilityLabel = "Total de curtidas: \(object.likes)."
		durationLabel.text = object.duration.toSubHeaderDate()
        durationLabel.accessibilityLabel = object.duration.toSubHeaderDate().setTimeAccessibility()

		thumbnailImageView.kf.indicatorType = .activity
		thumbnailImageView.kf.setImage(with: URL(string: object.artworkURL), placeholder: UIImage(named: "image_logo_feature\(Settings().darkModeimage)"))

		youtubeWebView?.scrollView.isScrollEnabled = false
		youtubeWebView?.configuration.userContentController.removeScriptMessageHandler(forName: "videoPaused")
		youtubeWebView?.configuration.userContentController.add(self, name: "videoPaused")

		youtubeWebView?.videoId = object.videoId
	}

    private func setFavoriteButtonAccessibility(isEnabled: Bool) {
        if isEnabled {
            favorite.accessibilityLabel = "Desfavoritar o video."
        } else {
            favorite.accessibilityLabel = "Favoritar o video."
        }
    }

    fileprivate func setLines(for label: UILabel) {
        let contentSize: UIContentSizeCategory = UIApplication.shared.preferredContentSizeCategory
        switch contentSize {
        case .extraExtraExtraLarge,
             .accessibilityMedium,
             .accessibilityLarge:
            label.numberOfLines = 3
        case .accessibilityExtraLarge:
            label.numberOfLines = 4
        case .accessibilityExtraExtraLarge:
            label.numberOfLines = 5
        case .accessibilityExtraExtraExtraLarge:
            label.numberOfLines = 4
        default:
            break
        }
    }

	// MARK: - Actions methods -

	@IBAction private func play(_ sender: Any) {
		thumbnailImageView.isHidden = true
		playButton.isHidden = true
		durationLabel.isHidden = true
		youtubeWebView?.play()

        // Handoff
        let handoff = NSUserActivity(activityType: "com.brit.macmagazine.details")
        handoff.title = headlineLabel.text
        handoff.webpageURL = URL(string: "https://www.youtube.com/watch?v=\(youtubeWebView?.videoId ?? "")")
        userActivity = handoff
        userActivity?.becomeCurrent()
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
            self.setFavoriteButtonAccessibility(isEnabled: isFavoriteOn)
		}
	}

}

extension VideosCollectionViewCell: WKScriptMessageHandler {
	func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
		if message.name == "videoPaused" {
			self.thumbnailImageView.isHidden = false
			self.playButton.isHidden = false
			self.durationLabel.isHidden = false
		}
	}
}
