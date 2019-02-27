//
//  SettingsTableViewController.swift
//  MacMagazine
//
//  Created by Cassio Rossi on 27/02/2019.
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

class SettingsTableViewController: UITableViewController {

    // MARK: - Properties -

    @IBOutlet private weak var darkMode: UISwitch!

    var isDarkMode = false

    // MARK: - View lifecycle -

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - View Methods -

    @IBAction private func changeDarkMode(_ sender: Any) {
        guard let darkModeSwitch = sender as? UISwitch else {
            return
        }

        isDarkMode = darkModeSwitch.isOn
        UserDefaults.standard.set(isDarkMode, forKey: "darkMode")
        UserDefaults.standard.synchronize()

        setDarkMode()
    }

    fileprivate func setDarkMode() {
        setNeedsStatusBarAppearanceUpdate()

        self.navigationController?.navigationBar.barStyle = .black
        self.navigationController?.navigationBar.barTintColor = isDarkMode ? .darkNavigationBarColor : .lightNavigationBarColor

        self.tabBarController?.tabBar.barTintColor = isDarkMode ? .darkTabBarColor : .lightTabBarColor
        self.tabBarController?.tabBar.tintColor = isDarkMode ? .darkTabBarTintColor : .lightTabBarTintColor
        self.tabBarController?.tabBar.unselectedItemTintColor = isDarkMode ? .darkTabBarUnselectedItemTintColor : .lightTabBarUnselectedItemTintColor

        self.tableView.backgroundColor = isDarkMode ? .darkTableColor : .lightTableColor
    }

}
