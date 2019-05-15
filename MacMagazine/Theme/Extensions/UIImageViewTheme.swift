//
//  UIImageViewTheme.swift
//  MacMagazine
//
//  Created by Cassio Rossi on 15/05/2019.
//  Copyright © 2019 MacMagazine. All rights reserved.
//

import UIKit

class AppImageView: UIImageView {}
class FavoriteImageView: UIImageView {}
class NavLogoImageView: UIImageView {}

extension NavLogoImageView {
	@objc dynamic var hightlightLogo: Bool {
		get { return isHighlighted }
		set {
			guard let isDarkMode = UserDefaults.standard.object(forKey: "darkMode") as? Bool else {
				isHighlighted = false
				return
			}
			isHighlighted = isDarkMode
		}
	}
}
