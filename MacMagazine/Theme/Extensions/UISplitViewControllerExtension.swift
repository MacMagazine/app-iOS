//
//  UISplitViewControllerExtension.swift
//  MacMagazine
//
//  Created by Cassio Rossi on 28/02/2019.
//  Copyright © 2019 MacMagazine. All rights reserved.
//

import UIKit

extension UISplitViewController {
    override open var preferredStatusBarStyle: UIStatusBarStyle {
        guard let isDarkMode = UserDefaults.standard.object(forKey: "darkMode") as? Bool else {
            return .default
        }
        return isDarkMode ? .lightContent : .default
    }
}
