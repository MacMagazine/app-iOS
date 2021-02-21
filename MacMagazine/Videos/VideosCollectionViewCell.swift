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
    @IBOutlet weak private var durationLabel: PaddingLabel!

    @IBOutlet weak private var headlineLabel: UILabel!
	@IBOutlet weak private var subheadlineLabel: UILabel!

    @IBOutlet weak private var favorite: UIButton!
    @IBOutlet weak private var share: UIButton!

    @IBOutlet weak private var viewsLabel: UILabel!
    @IBOutlet weak private var likesLabel: UILabel!

    var isPlaying: ((Bool) -> Void)?

	var videoId: String?
	let youTubeURL = "https://www.youtube.com/watch?v="

    struct VideoInfo {
        var videoId: String?
        var canFavorite: Bool
        var isFavorite: Bool
        var title: String?
        var subtitle: String?
        var views: String?
        var likes: String?
        var duration: String?
        var thumb: String?
    }

	// MARK: - Setup methods -

	func configureVideo(with object: Video, _ isPlaying: Bool = false) {
        let info = VideoInfo(videoId: object.videoId,
                             canFavorite: true,
                             isFavorite: object.favorite,
                             title: object.title,
                             subtitle: object.pubDate?.watchDate(),
                             views: object.views,
                             likes: object.likes,
                             duration: object.duration?.toSubHeaderDate(),
                             thumb: object.artworkURL)
        showVideoInfo(info, isPlaying)
    }

	func configureVideo(with object: JSONVideo, _ isPlaying: Bool = false) {
        let info = VideoInfo(videoId: object.videoId,
                             canFavorite: false,
                             isFavorite: false,
                             title: object.title,
                             subtitle: object.pubDate.toDate(Format.youtube).watchDate(),
                             views: object.views,
                             likes: object.likes,
                             duration: object.duration.toSubHeaderDate(),
                             thumb: object.artworkURL)
        showVideoInfo(info, isPlaying)
	}
}

// MARK: - Actions methods -
extension VideosCollectionViewCell {
	@IBAction private func play(_ sender: Any) {
		thumbnailImageView.isHidden = true
		playButton.isHidden = true
		durationLabel.isHidden = true
		youtubeWebView?.play()
        isPlaying?(true)

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

extension VideosCollectionViewCell {
    fileprivate func setFavoriteButtonAccessibility(isEnabled: Bool) {
        if isEnabled {
            favorite.accessibilityLabel = "Desfavoritar o video."
        } else {
            favorite.accessibilityLabel = "Favoritar o video."
        }
    }

    fileprivate func showVideoInfo(_ object: VideoInfo, _ isPlaying: Bool = false) {
        videoId = object.videoId

        favorite.isSelected = object.isFavorite
        favorite.isEnabled = object.canFavorite
        setFavoriteButtonAccessibility(isEnabled: object.isFavorite)

        headlineLabel.text = object.title
        headlineLabel.accessibilityLabel = "Video: \(object.title ?? "Não especificado.")"

        subheadlineLabel.text = object.subtitle
        subheadlineLabel.isAccessibilityElement = true
        subheadlineLabel.accessibilityLabel = object.subtitle?.toAccessibilityDateAndTime()

        viewsLabel.text = object.views?.formattedNumber()
        if let views = object.views {
            viewsLabel.accessibilityLabel = "\(views) visualizações."
        }

        likesLabel.text = object.likes?.formattedNumber()
        if let likes = object.likes {
            likesLabel.accessibilityLabel = "\(likes) curtidas."
        }

        durationLabel.text = object.duration
        durationLabel.alpha = 0.9
        if let duration = object.duration {
            durationLabel.accessibilityLabel = "duração: \(duration.toAccessibilityTime())"
        }

        youtubeWebView?.scrollView.isScrollEnabled = false
        youtubeWebView?.configuration.userContentController.removeScriptMessageHandler(forName: "videoPaused")
        youtubeWebView?.configuration.userContentController.add(self, name: "videoPaused")
        youtubeWebView?.isAccessibilityElement = false

        if !isPlaying {
            youtubeWebView?.videoId = object.videoId
        }

        guard let artworkURL = object.thumb else {
            return
        }
        thumbnailImageView.kf.indicatorType = .activity
        thumbnailImageView.kf.setImage(with: URL(string: artworkURL), placeholder: UIImage(named: "image_logo_feature"))

        accessibilityElements = [playButton as Any,
                                 durationLabel as Any,
                                 subheadlineLabel as Any,
                                 headlineLabel as Any,
                                 viewsLabel as Any,
                                 likesLabel as Any,
                                 favorite as Any,
                                 share as Any]
    }
}

extension VideosCollectionViewCell: WKScriptMessageHandler {
	func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
		if message.name == "videoPaused" {
			self.thumbnailImageView.isHidden = false
			self.playButton.isHidden = false
			self.durationLabel.isHidden = false
            self.isPlaying?(false)
		}
	}
}
