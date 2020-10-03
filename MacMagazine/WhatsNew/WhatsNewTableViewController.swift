//
//  WhatsNewTableViewController.swift
//  MacMagazine
//
//  Created by Cassio Rossi on 03/10/20.
//  Copyright © 2020 MacMagazine. All rights reserved.
//

import UIKit

class WhatsNewTableViewController: UITableViewController {

    @IBAction private func close(_ sender: Any) {
        var settings = Settings()
        settings.whatsNew = Settings().appVersion

        self.dismiss(animated: true, completion: nil)
    }
}
