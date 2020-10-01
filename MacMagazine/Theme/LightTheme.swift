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

	let headerFooterColor: UIColor = .darkGray
    let labelColor: UIColor = .black
    let secondaryLabelColor: UIColor = .darkGray
    let subtleLabelColor: UIColor = .lightGray
    let textColor: UIColor = .black
}
