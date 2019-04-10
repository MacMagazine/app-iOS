//
//  MainInterfaceController.swift
//  MacMagazineWatch Extension
//
//  Created by Cassio Rossi on 08/04/2019.
//  Copyright © 2019 MacMagazine. All rights reserved.
//

import Kingfisher
import WatchKit

class MainInterfaceController: WKInterfaceController {

    // MARK: - Properties -

	@IBOutlet private weak var image: WKInterfaceImage!
	@IBOutlet private weak var titleLabel: WKInterfaceLabel!
	@IBOutlet private weak var dateLabel: WKInterfaceLabel!
	@IBOutlet private weak var content: WKInterfaceLabel!

	// MARK: - App lifecycle -

	override func awake(withContext context: Any?) {
        super.awake(withContext: context)

        // Configure interface objects here.
		self.setTitle("MacMagazine")

		if let object = context as? [String: Any],
			let title = object["title"] as? String,
			let item = object["post"] as? PostData {

			self.setTitle(title)

			titleLabel.setText(item.title)
            dateLabel.setText(item.pubDate)
            content.setText(item.excerpt)

            guard let thumbnail = item.thumbnail,
                let url = URL(string: thumbnail) else {
                return
            }
			image.kf.setImage(with: url)
        }
    }

	@IBAction private func reload() {
		WKInterfaceController.reloadRootPageControllers(withNames: ["loading"], contexts: nil, orientation: .horizontal, pageIndex: 0)
	}
}
