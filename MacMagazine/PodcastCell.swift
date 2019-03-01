//
//  PodcastCell.swift
//  MacMagazine
//
//  Created by Cassio Rossi on 01/03/2019.
//  Copyright © 2019 MacMagazine. All rights reserved.
//

import UIKit

class PodcastCell: UITableViewCell {

	// MARK: - Properties -

	@IBOutlet private weak var headlineLabel: UILabel!
	@IBOutlet private weak var subheadlineLabel: UILabel!
	@IBOutlet private weak var lengthlineLabel: UILabel!

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
	}

}
