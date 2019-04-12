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
		UserDefaults.standard.set(token, forKey: Definitions.videoNextToken)
		UserDefaults.standard.synchronize()
	}

	func getVideoNextToken() -> String? {
		guard let videoNextToken = UserDefaults.standard.object(forKey: Definitions.videoNextToken) as? String else {
			return nil
		}
		return videoNextToken
	}

}
