//
//  DetailInterfaceController.swift
//  MacMagazine
//
//  Created by Cassio Rossi on 14/09/2025.
//  Copyright © 2025 MacMagazine. All rights reserved.
//

import WatchKit

class DetailInterfaceController: WKInterfaceController {

	// MARK: - Properties -

	@IBOutlet private weak var content: WKInterfaceLabel!

	var object: [String: Any]?

	// MARK: - App lifecycle -

	override func awake(withContext context: Any?) {
		super.awake(withContext: context)

		// Configure interface objects here.
		guard let object = context as? [String: Any] else {
			return
		}
		self.object = object
		self.setTitle("Fechar")
	}

	override func willActivate() {
		super.willActivate()

		if let object = self.object,
		   let item = object["post"] as? PostData {

			let style = NSMutableParagraphStyle()
			style.paragraphSpacing = 12

			let string = NSMutableAttributedString(string: item.fullContent ?? "")
			string.addAttribute(.paragraphStyle,
								value: style,
								range: NSRange(location: 0, length: string.length))

			content.setAttributedText(string)
		}
	}
}
