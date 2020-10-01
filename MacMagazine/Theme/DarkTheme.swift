//
//  DarkTheme.swift
//  MacMagazine
//
//  Created by Cassio Rossi on 28/02/2019.
//  Copyright © 2019 MacMagazine. All rights reserved.
//

import UIKit

struct DarkTheme: Theme {
    let tint: UIColor = UIColor(named: "MMBlueWhite") ?? .white

	let headerFooterColor: UIColor = .white
    let labelColor: UIColor = .white
    let secondaryLabelColor: UIColor = .lightGray
    let subtleLabelColor: UIColor = .darkGray
    let textColor: UIColor = .black
}
