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
        headerLabel?.text = text
        subHeaderLabel?.text = "versão \(Settings().appVersion)"
    }
}
