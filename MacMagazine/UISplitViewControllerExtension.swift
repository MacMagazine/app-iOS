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
        return Settings().isDarkMode ? .lightContent : .darkContent
    }
}
