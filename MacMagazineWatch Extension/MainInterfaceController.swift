//
//  MainInterfaceController.swift
//  MacMagazineWatch Extension
//
//  Created by Cassio Rossi on 08/04/2019.
//  Copyright © 2019 MacMagazine. All rights reserved.
//

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
        if let item = context as? PostData {
            titleLabel.setText(item.title)
            dateLabel.setText(item.pubDate)
            content.setText(item.excerpt)
        }
    }

}
