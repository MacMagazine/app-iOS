//
//  Settings.swift
//  MacMagazine
//
//  Created by Cassio Rossi on 02/03/2019.
//  Copyright © 2019 MacMagazine. All rights reserved.
//

import UIKit

enum Definitions {
	static let darkMode = "darkMode"
	static let fontSize = "font-size-settings"
	static let icon = "icon"
	static let watch = "watch"
	static let videoNextToken = "videoNextToken"
	static let allVideosFetched = "allVideosFetched"
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

	func setVideoNextToken(_ token: String?) {
		guard let _ = UserDefaults.standard.object(forKey: Definitions.allVideosFetched) as? Bool else {
			UserDefaults.standard.set(token, forKey: Definitions.videoNextToken)
			if let _ = token {
				UserDefaults.standard.set(true, forKey: Definitions.allVideosFetched)
			}
			UserDefaults.standard.synchronize()

			return
		}
	}

	func getVideoNextToken() -> String? {
		guard let videoNextToken = UserDefaults.standard.object(forKey: Definitions.videoNextToken) as? String else {
			return nil
		}
		return videoNextToken
	}

}
