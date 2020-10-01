//
//  SettingsHeaderCell.swift
//  MacMagazine
//
//  Created by Cassio Rossi on 28/09/20.
//  Copyright © 2020 MacMagazine. All rights reserved.
//

import UIKit

class SettingsHeaderCell: UITableViewHeaderFooterView {

    // MARK: - Properties -

    @IBOutlet private weak var headerLabel: UILabel!
    @IBOutlet private weak var subHeaderLabel: UILabel!

    // MARK: - Methods -

    func setHeader(_ text: String?) {
        let font = UIFont.boldSystemFont(ofSize: 22)
        let fontMetrics = UIFontMetrics(forTextStyle: .title2)
        headerLabel?.font = fontMetrics.scaledFont(for: font)

        headerLabel?.text = text
        subHeaderLabel?.text = "VERSÃO \(Settings().appVersion)"
    }
}
