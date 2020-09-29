//
//  LightTheme.swift
//  MacMagazine
//
//  Created by Cassio Rossi on 28/02/2019.
//  Copyright © 2019 MacMagazine. All rights reserved.
//

import UIKit

struct LightTheme: Theme {
    let tint: UIColor = UIColor(named: "MMBlueWhite") ?? .systemBlue

    let videoLabelColor: UIColor = UIColor(hex: "0097d4", alpha: 1)

    let barTintColor: UIColor = .white

    let backgroundColor: UIColor = UIColor(hex: "efeef3", alpha: 1)
    let cellBackgroundColor: UIColor = .white
	let videoCellBackgroundColor: UIColor = .lightGray

	let headerFooterColor: UIColor = .darkGray
    let labelColor: UIColor = .black
    let secondaryLabelColor: UIColor = .darkGray
    let subtleLabelColor: UIColor = .lightGray
    let textColor: UIColor = .black
    let placeholderTextColor: UIColor = .gray
}
