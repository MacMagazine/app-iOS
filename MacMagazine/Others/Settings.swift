//
//  Settings.swift
//  MacMagazine
//
//  Created by Cassio Rossi on 02/03/2019.
//  Copyright © 2019 MacMagazine. All rights reserved.
//

import OneSignal
import UIKit

enum Definitions {
	static let darkMode = "darkMode"
	static let fontSize = "font-size-settings"
	static let icon = "icon"
	static let watch = "watch"
	static let askForReview = "askForReview"
	static let all_posts_pushes = "all_posts_pushes"
	static let pushPreferences = "pushPreferences"
}

struct Settings {

    func isPhone() -> Bool {
        return UIDevice.current.userInterfaceIdiom == .phone
    }

    func isPad() -> Bool {
        return UIDevice.current.userInterfaceIdiom == .pad
    }

    func isDarkMode() -> Bool {
		guard let isDarkMode = UserDefaults.standard.object(forKey: Definitions.darkMode) as? Bool else {
			return false
		}
		return isDarkMode
	}

	func getDarkModeUserAgent() -> String {
		return isDarkMode() ? "-modoescuro" : ""
	}

	func getFontSize() -> String {
		guard let sliderFontSize = UserDefaults.standard.object(forKey: Definitions.fontSize) as? String else {
			return ""
		}
		return sliderFontSize
	}

	func getFontSizeUserAgent() -> String {
		let sliderFontSize = getFontSize()
		var fontSize = ""
		if !sliderFontSize.isEmpty {
			fontSize = "-\(sliderFontSize)"
		}
		return fontSize
	}

	func shouldAskForReview() -> Bool {
		guard let askForReview = UserDefaults.standard.object(forKey: Definitions.askForReview) as? Int else {
			UserDefaults.standard.set(1, forKey: Definitions.askForReview)
			UserDefaults.standard.synchronize()

			return false
		}
		UserDefaults.standard.set(askForReview + 1, forKey: Definitions.askForReview)
		UserDefaults.standard.synchronize()

		return askForReview % 50 == 0
	}

}

enum PushPreferences {
	static let featured = "featured_posts"
	static let all = "all_posts"
}

extension Settings {
	func getPushPreference() -> Int {
		// 0 -> All posts
		// 1 -> Featured only

		guard let pushPreferences = UserDefaults.standard.object(forKey: Definitions.pushPreferences) as? Int else {
			// There is no Push Notification Preference or is old style
			guard let pushPreferences = UserDefaults.standard.object(forKey: Definitions.all_posts_pushes) as? Bool else {
				// There is no Push Notification Preference
				return 0
			}
			// Remove old preference
			UserDefaults.standard.removeObject(forKey: Definitions.all_posts_pushes)
			UserDefaults.standard.synchronize()

			return pushPreferences ? 0 : 1
		}
		return pushPreferences
	}

	func updatePushPreferences(_ segment: Int) {
		UserDefaults.standard.set(segment, forKey: Definitions.pushPreferences)
		UserDefaults.standard.synchronize()

		OneSignal.sendTag("notification_preferences", value: segment == 0 ? PushPreferences.all : PushPreferences.featured)
	}
}
