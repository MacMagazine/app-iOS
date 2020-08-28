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
    static let transparency = "transparency"
}

// MARK: -

enum Appearance: Int {
    case light = 0
    case dark
    case native
}

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

    var supportsNativeDarkMode: Bool {
        if #available(iOS 13.0, *) {
            return true
        }
        return false
    }

    var appearance: Appearance {
        guard let mode = UserDefaults.standard.object(forKey: Definitions.darkMode) as? Int else {
            guard let darkMode = UserDefaults.standard.object(forKey: Definitions.darkMode) as? Bool else {
                return .light
            }
            return darkMode ? .dark : .light
        }
        return Appearance(rawValue: mode) ?? .light
    }

    var isDarkMode: Bool {
        if #available(iOS 13.0, *) {
            if appearance == .native {
                return UIApplication.shared.keyWindow?.rootViewController?.traitCollection.userInterfaceStyle == .dark
            }
        }
        return appearance == .dark
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

	func changeTheme(based previousTraitCollection: UITraitCollection?) {
		if #available(iOS 13.0, *) {
            let state = UIApplication.shared.applicationState
			if let style = previousTraitCollection?.userInterfaceStyle,
                state == .active,
				appearance == .native &&
					((style == .dark && isDarkMode) ||
					(style == .light && !isDarkMode)) {
				applyTheme()
			}
		}
	}

    var transparency: CGFloat {
        guard let transparency = UserDefaults.standard.object(forKey: Definitions.transparency) as? CGFloat else {
            return 0.8
        }
        return transparency
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
		theme.apply(for: UIApplication.shared)
        NotificationCenter.default.post(name: .reloadWeb, object: nil)
	}

	func applyLightTheme() {
		if isDarkMode {
			UIApplication.shared.keyWindow?.tintColor = LightTheme().tint
		}
	}

	func applyDarkTheme() {
		if isDarkMode {
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
