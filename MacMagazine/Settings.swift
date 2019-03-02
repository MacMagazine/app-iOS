//
//  Settings.swift
//  MacMagazine
//
//  Created by Cassio Rossi on 02/03/2019.
//  Copyright © 2019 MacMagazine. All rights reserved.
//

import Foundation

struct Settings {

	func isDarkMode() -> Bool {
		guard let isDarkMode = UserDefaults.standard.object(forKey: "darkMode") as? Bool else {
			return false
		}
		return isDarkMode
	}

	func getDarkModeUserAgent() -> String {
		return isDarkMode() ? "-modoescuro" : ""
	}

	func getFontSize() -> String {
		guard let sliderFontSize = UserDefaults.standard.object(forKey: "font-size-settings") as? String else {
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

}
