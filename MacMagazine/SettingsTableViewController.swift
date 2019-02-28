//
//  SettingsTableViewController.swift
//  MacMagazine
//
//  Created by Cassio Rossi on 27/02/2019.
//  Copyright © 2019 MacMagazine. All rights reserved.
//

import UIKit

class SettingsTableViewController: UITableViewController {

    // MARK: - Properties -

    @IBOutlet private weak var darkMode: UISwitch!

    // MARK: - View lifecycle -

    override func viewDidLoad() {
        super.viewDidLoad()

        applyTheme()
    }

    // MARK: - View Methods -

    @IBAction private func changeDarkMode(_ sender: Any) {
        guard let darkModeSwitch = sender as? UISwitch else {
            return
        }

        UserDefaults.standard.set(darkModeSwitch.isOn, forKey: "darkMode")
        UserDefaults.standard.synchronize()

        applyTheme()
    }

    fileprivate func applyTheme() {
        guard let isDarkMode = UserDefaults.standard.object(forKey: "darkMode") as? Bool else {
            let theme: Theme = LightTheme()
            theme.apply(for: UIApplication.shared)

            return
        }

        let theme: Theme = isDarkMode ? DarkTheme() : LightTheme()
        theme.apply(for: UIApplication.shared)

        darkMode.isOn = isDarkMode
    }

//        self.tabBarController?.tabBar.tintColor = isDarkMode ? .darkTabBarTintColor : .lightTabBarTintColor
//        self.tabBarController?.tabBar.unselectedItemTintColor = isDarkMode ? .darkTabBarUnselectedItemTintColor : .lightTabBarUnselectedItemTintColor
//
//        self.tableView.backgroundColor = isDarkMode ? .darkTableColor : .lightTableColor
}
