//
//  Settings.swift
//  MacMagazine
//
//  Created by Cassio Rossi on 02/03/2019.
//  Copyright © 2019 MacMagazine. All rights reserved.
//

import OneSignal
import UIKit

// MARK: -

enum Definitions {
	static let darkMode = "darkMode"
	static let fontSize = "font-size-settings"
	static let icon = "icon"
	static let watch = "watch"
	static let askForReview = "askForReview"
	static let all_posts_pushes = "all_posts_pushes"
	static let pushPreferences = "pushPreferences"
}

// MARK: -

struct Settings {

	// MARK: - Device -

	var isPhone: Bool {
        return UIApplication.shared.keyWindow?.rootViewController?.traitCollection.horizontalSizeClass == .compact
    }

	var isPad: Bool {
        return UIApplication.shared.keyWindow?.rootViewController?.traitCollection.horizontalSizeClass == .regular
    }

	var orientations: UIInterfaceOrientationMask {
		return isPhone ? .portrait : .all
	}

	// MARK: - Dark Mode -

	var isDarkMode: Bool {
		guard let isDarkMode = UserDefaults.standard.object(forKey: Definitions.darkMode) as? Bool else {
			return false
		}
		return isDarkMode
	}

	var darkModeUserAgent: String {
		return isDarkMode ? "-modoescuro" : ""
	}

	var fontSize: String {
		guard let sliderFontSize = UserDefaults.standard.object(forKey: Definitions.fontSize) as? String else {
			return ""
		}
		return sliderFontSize
	}

	var fontSizeUserAgent: String {
		let sliderFontSize = fontSize
		var fontSize = ""
		if !sliderFontSize.isEmpty {
			fontSize = "-\(sliderFontSize)"
		}
		return fontSize
	}

	var darkModeimage: String {
		return isDarkMode ? "_dark" : ""
	}

	var darkModeColor: UIColor {
		return isDarkMode ? .white : .black
	}

	var theme: Theme {
		return isDarkMode ? DarkTheme() : LightTheme()
	}

	// MARK: - Review -

	var shouldAskForReview: Bool {
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

// MARK: -

extension Settings {
	func applyTheme() {
		guard let _ = UserDefaults.standard.object(forKey: "darkMode") as? Bool else {
			let theme: Theme = LightTheme()
			theme.apply(for: UIApplication.shared)
			return
		}
		theme.apply(for: UIApplication.shared)
	}

	func applyLightTheme() {
		if let isDarkMode = UserDefaults.standard.object(forKey: "darkMode") as? Bool, isDarkMode {
			UIApplication.shared.keyWindow?.tintColor = LightTheme().tint
		}
	}

	func applyDarkTheme() {
		if let isDarkMode = UserDefaults.standard.object(forKey: "darkMode") as? Bool, isDarkMode {
			UIApplication.shared.keyWindow?.tintColor = DarkTheme().tint
		}
	}
}

// MARK: - Push -

enum PushPreferences {
	static let featured = "featured_posts"
	static let all = "all_posts"
}

extension Settings {
	// 0 -> All posts
	// 1 -> Featured only
	var pushPreference: Int {
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

	func updatePushPreference(_ segment: Int) {
		UserDefaults.standard.set(segment, forKey: Definitions.pushPreferences)
		UserDefaults.standard.synchronize()

		OneSignal.sendTag("notification_preferences", value: segment == 0 ? PushPreferences.all : PushPreferences.featured)
	}
}
