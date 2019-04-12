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
	@IBOutlet weak private var thumbnailImageView: UIImageView!
	@IBOutlet weak private var favoriteImageView: UIImageView!
	@IBOutlet weak private var headlineLabel: UILabel!

	func configureVideo(with object: Video) {
		headlineLabel?.text = object.title

//		favoriteImageView.alpha = (object.favorite ? 1 : 0)

		guard let artworkURL = object.artworkURL else {
			return
		}
		thumbnailImageView.kf.indicatorType = .activity
		thumbnailImageView.kf.setImage(with: URL(string: artworkURL), placeholder: UIImage(named: "image_Logo"))
	}
}
