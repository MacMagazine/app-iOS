//
//  SFSafariViewControllerExtensions.swift
//  MacMagazine
//
//  Created by Cassio Rossi on 29/11/19.
//  Copyright © 2019 MacMagazine. All rights reserved.
//

import SafariServices

extension SFSafariViewController {
    func setup() {
        self.dismissButtonStyle = .close
        self.modalPresentationStyle = .overFullScreen
    }
}
