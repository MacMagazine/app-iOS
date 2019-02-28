//
//  DarkTheme.swift
//  MacMagazine
//
//  Created by Cassio Rossi on 28/02/2019.
//  Copyright © 2019 MacMagazine. All rights reserved.
//

import UIKit

struct DarkTheme: Theme {
    let barStyle: UIBarStyle = .black
    let barTintColor: UIColor = UIColor(hex: "181818", alpha: 1)

    let tint: UIColor = .white
    let secondaryTint: UIColor = UIColor(hex: "808080", alpha: 1)
    let onTint: UIColor = UIColor(hex: "0097d4", alpha: 1)

    let backgroundColor: UIColor = .black
    let cellBackgroundColor: UIColor = UIColor(hex: "181818", alpha: 1)
    let separatorColor: UIColor = .lightGray
    let selectionColor: UIColor = .gray
    let headerFooterColor: UIColor = .white

    let labelColor: UIColor = .white
    let secondaryLabelColor: UIColor = .lightGray
    let subtleLabelColor: UIColor = .darkGray
}
