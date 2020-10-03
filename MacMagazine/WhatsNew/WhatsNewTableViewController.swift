//
//  WhatsNewTableViewController.swift
//  MacMagazine
//
//  Created by Cassio Rossi on 03/10/20.
//  Copyright © 2020 MacMagazine. All rights reserved.
//

import UIKit

class WhatsNewTableViewController: UIViewController {

    // MARK: - Properties -

    @IBOutlet private var version: UILabel!
    @IBOutlet private var whatsnewLabel: UILabel!

    // MARK: - View lifecycle -

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        whatsnewLabel?.font = Settings().getMetricBoldFont(forTextStyle: .title2)

        version.text = "versão \(Settings().appVersion)"
    }

    // MARK: - Methods -

    @IBAction private func close(_ sender: Any) {
        var settings = Settings()
        settings.whatsNew = Settings().appVersion

        self.dismiss(animated: true, completion: nil)
    }
}
