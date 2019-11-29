//
//  UIAlertControllerExtensions.swift
//  MacMagazine
//
//  Created by Cassio Rossi on 29/11/19.
//  Copyright © 2019 MacMagazine. All rights reserved.
//

import UIKit

extension UIAlertController {
    func setup() {
        if Settings().appearance != .native &&
            Settings().isDarkMode {
            self.view.tintColor = LightTheme().tint
        }
    }
}
