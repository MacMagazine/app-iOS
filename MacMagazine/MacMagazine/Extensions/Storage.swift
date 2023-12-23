import CommonLibrary
import CoreLibrary
import SwiftUI

extension DefaultStorage {
	static var colorScheme: SwiftUI.ColorScheme? {
		guard let colorScheme = DefaultStorage().get(key: "colorScheme") as? String else {
			return nil
		}
		return colorScheme == ".light" ? .light : .dark
	}

	static func update(_ colorScheme: SwiftUI.ColorScheme?) {
		guard let value = colorScheme else {
			DefaultStorage().delete(key: "colorScheme")
			return
		}
		DefaultStorage().save(object: value == .light ? ".light" : ".dark", key: "colorScheme")
	}
}
