//
//  UIColorExtensions.swift
//  MacMagazine
//
//  Created by Cassio Rossi on 07/09/17.
//  Copyright © 2017 MacMagazine. All rights reserved.
//

import UIKit

extension UIColor {

    // MARK: - Light mode -

    static let lightCellSelectedColor = UIColor(hex: "008ACA", alpha: 0.3)
    static let lightNavigationBarColor = UIColor(named: "backgroundLightColor")
    static let lightTabBarColor = UIColor(named: "backgroundLightColor")
    static let lightTableColor = UIColor(named: "backgroundLighterColor")
    static let lightTabBarTintColor = UIColor(named: "blueColor")
    static let lightTabBarUnselectedItemTintColor = UIColor.lightGray

    // MARK: - Dark mode -

    static let darkCellSelectedColor = UIColor(named: "darkBlueColor")
    static let darkNavigationBarColor = UIColor(named: "backgroundDarkColor")
    static let darkTabBarColor = UIColor(named: "backgroundDarkColor")
    static let darkTableColor = UIColor(named: "backgroundDarkerColor")
    static let darkTabBarTintColor = UIColor.white
    static let darkTabBarUnselectedItemTintColor = UIColor.darkGray

	convenience init(hex: String, alpha: CGFloat = 1.0) {
		let scanner = Scanner(string: hex)
		scanner.scanLocation = 0

		var rgbValue: UInt64 = 0

		scanner.scanHexInt64(&rgbValue)

		let red = (rgbValue & 0xff0000) >> 16
		let green = (rgbValue & 0xff00) >> 8
		let blue = rgbValue & 0xff

		self.init(red: CGFloat(red) / 0xff, green: CGFloat(green) / 0xff, blue: CGFloat(blue) / 0xff, alpha: alpha)
	}

}
