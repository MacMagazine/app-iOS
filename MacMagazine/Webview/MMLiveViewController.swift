//
//  MMLiveViewController.swift
//  MacMagazine
//
//  Created by Cassio Rossi on 08/03/21.
//  Copyright © 2021 MacMagazine. All rights reserved.
//

import SafariServices
import UIKit
import WebKit

class MMLiveViewController: WebViewController {

    // MARK: - View lifecycle -

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        postURL = URL(string: "https://live.macmagazine.com.br/live.html")
    }

    // MARK: - Override -

    override func setRightButtomItems(_ buttons: [RightButtons]) {}
}
