//
//  DarkTheme.swift
//  MacMagazine
//
//  Created by Cassio Rossi on 28/02/2019.
//  Copyright © 2019 MacMagazine. All rights reserved.
//

import UIKit

struct DarkTheme: Theme {
	let hightlightLogo: Bool = true

	let videoLabelColor: UIColor = .white

	let barStyle: UIBarStyle = .black
    let barTintColor: UIColor = UIColor(hex: "181818", alpha: 1)

    let tint: UIColor = .white
    let secondaryTint: UIColor = UIColor(hex: "808080", alpha: 1)
    let onTint: UIColor = UIColor(hex: "0097d4", alpha: 1)

    let selectedSegmentTintColor: UIColor = .darkGray

    let backgroundColor: UIColor = .black
    let cellBackgroundColor: UIColor = UIColor(hex: "181818", alpha: 1)
    let selectionColor: UIColor = .gray
	let videoCellBackgroundColor: UIColor = .gray

	let headerFooterColor: UIColor = .white
    let labelColor: UIColor = .white
    let secondaryLabelColor: UIColor = .lightGray
    let subtleLabelColor: UIColor = .darkGray
    let textColor: UIColor = .black
    let placeholderTextColor: UIColor = .gray

	let keyboardStyle: UIKeyboardAppearance = .dark
}
