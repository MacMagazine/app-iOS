//
//  UIActivityExtensions.swift
//  MacMagazine
//
//  Created by Cassio Rossi on 30/03/2019.
//  Copyright © 2019 MacMagazine. All rights reserved.
//

import UIKit

class UIActivityExtensions: UIActivity {

	// MARK: - Properties -

	var _activityTitle: String
	var _activityImage: UIImage?
	var activityItems = [Any]()
	var action: ([Any]) -> Void

	init(title: String, image: UIImage?, performAction: @escaping ([Any]) -> Void) {
		_activityTitle = title
		_activityImage = image
		action = performAction
		super.init()
	}

	// MARK: - UIActivity override -

	override var activityTitle: String? {
		return _activityTitle
	}

	override var activityImage: UIImage? {
		return _activityImage
	}

	override var activityType: UIActivity.ActivityType? {
		return UIActivity.ActivityType(rawValue: "com.brit.macmagazine.activity")
	}

	override class var activityCategory: UIActivity.Category {
		return .action
	}

	override func canPerform(withActivityItems activityItems: [Any]) -> Bool {
		return true
	}

	override func prepare(withActivityItems activityItems: [Any]) {
		self.activityItems = activityItems
	}

	override func perform() {
		action(activityItems)
		activityDidFinish(true)
	}

}
