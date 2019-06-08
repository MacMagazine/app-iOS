//
//  PostCell.swift
//  MacMagazine
//
//  Created by Cassio Rossi on 03/09/17.
//  Copyright © 2017 MacMagazine. All rights reserved.
//

import Kingfisher
import UIKit

class HeaderCell: UITableViewHeaderFooterView {

	// MARK: - Properties -

	@IBOutlet private weak var headerLabel: UILabel!

	// MARK: - Methods -

	func setHeader(_ text: String?) {
		headerLabel?.text = text
	}
}

class PostCell: AppTableViewCell {

	// MARK: - Properties -

	@IBOutlet private weak var headlineLabel: UILabel!
	@IBOutlet private weak var subheadlineLabel: UILabel!
	@IBOutlet private weak var lengthlineLabel: UILabel!
	@IBOutlet private weak var thumbnailImageView: UIImageView!
	@IBOutlet private weak var favoriteImageView: FavoriteImageView!

	// MARK: - Methods -

    func configurePost(_ object: Post) {
        headlineLabel?.text = object.title

		var defaultImage = "image_logo_feature\(Settings().isDarkMode() ? "_dark" : "")"
		if object.categorias?.contains("Destaques") == false {
			defaultImage = "image_logo\(Settings().isDarkMode() ? "_dark" : "")"
            if subheadlineLabel != nil {
                subheadlineLabel?.text = object.excerpt
            }
        }

		favoriteImageView.alpha = (object.favorite ? 1 : 0)

		guard let artworkURL = object.artworkURL else {
			return
		}
        thumbnailImageView.kf.indicatorType = .activity
		thumbnailImageView.kf.setImage(with: URL(string: artworkURL), placeholder: UIImage(named: defaultImage))
    }

	func configureSearchPost(_ object: XMLPost) {
		headlineLabel?.text = object.title

		var defaultImage = "image_logo_feature\(Settings().isDarkMode() ? "_dark" : "")"
		if object.categories.contains("Destaques") == false {
			defaultImage = "image_logo\(Settings().isDarkMode() ? "_dark" : "")"
			if subheadlineLabel != nil {
				subheadlineLabel?.text = object.excerpt
			}
		}

		thumbnailImageView.kf.indicatorType = .activity
		thumbnailImageView.kf.setImage(with: URL(string: object.artworkURL), placeholder: UIImage(named: defaultImage))

		favoriteImageView.isHidden = true
	}

	func configurePodcast(_ object: Post) {
        headlineLabel?.text = object.title
		subheadlineLabel?.text = object.pubDate?.cellDate()
        guard let duration = object.duration else {
            lengthlineLabel?.text = nil
            return
        }
        lengthlineLabel?.text = "duração: \(duration)"

		favoriteImageView.alpha = (object.favorite ? 1 : 0)

		guard let artworkURL = object.artworkURL else {
			return
		}
		thumbnailImageView.kf.indicatorType = .activity
		thumbnailImageView.kf.setImage(with: URL(string: artworkURL), placeholder: UIImage(named: "image_logo_feature\(Settings().isDarkMode() ? "_dark" : "")"))
	}

	func configureSearchPodcast(_ object: XMLPost) {
        headlineLabel?.text = object.title
		subheadlineLabel?.text = object.pubDate.toDate().cellDate()
		lengthlineLabel?.text = object.duration.isEmpty ? nil : "duração: \(object.duration)"

		thumbnailImageView.kf.indicatorType = .activity
		thumbnailImageView.kf.setImage(with: URL(string: object.artworkURL), placeholder: UIImage(named: "image_logo_feature\(Settings().isDarkMode() ? "_dark" : "")"))

		favoriteImageView.isHidden = true
	}

}
