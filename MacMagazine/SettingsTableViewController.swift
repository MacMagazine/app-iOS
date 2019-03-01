//
//  SettingsTableViewController.swift
//  MacMagazine
//
//  Created by Cassio Rossi on 27/02/2019.
//  Copyright © 2019 MacMagazine. All rights reserved.
//

import MessageUI
import UIKit

class SettingsTableViewController: UITableViewController, MFMailComposeViewControllerDelegate {

    // MARK: - Properties -

    @IBOutlet private weak var fontSize: UISlider!
    @IBOutlet private weak var darkMode: UISwitch!
    @IBOutlet private weak var reportProblem: UITableViewCell!

    var version: String = ""

    // MARK: - View lifecycle -

    override func viewDidLoad() {
        super.viewDidLoad()

        version = getAppVersion()

        guard let sliderFontSize = UserDefaults.standard.object(forKey: "font-size-settings") as? String else {
            return
        }
        fontSize.value = sliderFontSize == "fontemenor" ? 0.0 : sliderFontSize == "fontemaior" ? 2.0 : 1.0

        guard MFMailComposeViewController.canSendMail() else {
            reportProblem.isHidden = true
            return
        }
    }

	override func viewWillAppear(_ animated: Bool) {
		clearsSelectionOnViewWillAppear = splitViewController?.isCollapsed ?? true
		super.viewWillAppear(animated)

		UILabel.appearance(whenContainedInInstancesOf: [UITableViewHeaderFooterView.self]).with {
			$0.textAlignment = .left
		}

		applyTheme()
	}

	// MARK: - TableView Methods -

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		return section == 0 ? "MACMAGAZINE \(version)" : nil
    }

    // MARK: - View Methods -

    @IBAction private func changeFontSize(_ sender: Any) {
        guard let slider = sender as? UISlider else {
            return
        }

        var fontSize = ""
        var roundedValue = 1
        if slider.value < 0.65 {
            roundedValue = 0
            fontSize = "fontemenor"
        }
        if slider.value > 1.4 {
            roundedValue = 2
            fontSize = "fontemaior"
        }
        slider.value = Float(roundedValue)

        UserDefaults.standard.set(fontSize, forKey: "font-size-settings")
        UserDefaults.standard.synchronize()

        applyTheme()
    }

    @IBAction private func changeDarkMode(_ sender: Any) {
        guard let darkModeSwitch = sender as? UISwitch else {
            return
        }

        UserDefaults.standard.set(darkModeSwitch.isOn, forKey: "darkMode")
        UserDefaults.standard.synchronize()

        applyTheme()
    }

    @IBAction private func reportProblem(_ sender: Any) {
        let composeVC = MFMailComposeViewController()
        composeVC.setSubject("Relato de problema no app MacMagazine \(version)")
        composeVC.setToRecipients(["contato@macmagazine.com.br"])
        self.present(composeVC, animated: true, completion: nil)
    }

    // MARK: - Private Methods -

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

    fileprivate func getAppVersion() -> String {
        let bundle = Bundle(for: type(of: self))
        let appVersion = bundle.infoDictionary?["CFBundleShortVersionString"] as? String
        let buildVersion = bundle.infoDictionary?["CFBundleVersion"] as? String
        return "v: \(appVersion ?? "0") (\(buildVersion ?? "0"))"
    }

    // MARK: - Mail Methods -

    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        self.dismiss(animated: true, completion: nil)
    }

}
