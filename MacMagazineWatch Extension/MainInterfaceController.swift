//
//  MainInterfaceController.swift
//  MacMagazineWatch Extension
//
//  Created by Cassio Rossi on 08/04/2019.
//  Copyright © 2019 MacMagazine. All rights reserved.
//

import EMTLoadingIndicator
import Kingfisher
import WatchKit

class MainInterfaceController: WKInterfaceController {

    // MARK: - Properties -

	@IBOutlet private weak var spin: WKInterfaceImage!
	@IBOutlet private weak var image: WKInterfaceImage!
	@IBOutlet private weak var titleLabel: WKInterfaceLabel!
	@IBOutlet private weak var dateLabel: WKInterfaceLabel!
	@IBOutlet private weak var content: WKInterfaceLabel!

	private var indicator: EMTLoadingIndicator?
	var object: [String: Any]?

	// MARK: - App lifecycle -

	override func awake(withContext context: Any?) {
        super.awake(withContext: context)

		// Configure interface objects here.
		guard let object = context as? [String: Any] else {
			return
		}
		self.object = object
		self.setTitle("MacMagazine")
    }

	override func willActivate() {
		super.willActivate()

		if let object = self.object,
			let title = object["title"] as? String,
			let item = object["post"] as? PostData {

			self.setTitle(title)

			titleLabel.setText(item.title)
			dateLabel.setText(item.pubDate)
			content.setText(item.excerpt)

			indicator = EMTLoadingIndicator(interfaceController: self, interfaceImage: spin, width: 10, height: 10, style: .line)
			indicator?.showWait()

			guard let thumbnail = item.thumbnail,
				let url = URL(string: thumbnail) else {
					return
			}
			image.kf.setImage(with: url, placeholder: nil, options: nil, progressBlock: nil) { _ in
				self.indicator?.hide()
			}
		}
	}

	@IBAction private func reload() {
		WKInterfaceController.reloadRootPageControllers(withNames: ["loading"], contexts: nil, orientation: .horizontal, pageIndex: 0)
	}

	@IBAction private func clearCache() {
		ImageCache.default.clearDiskCache()
		reload()
	}

}
