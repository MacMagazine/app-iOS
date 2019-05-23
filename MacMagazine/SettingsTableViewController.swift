//
//  SettingsTableViewController.swift
//  MacMagazine
//
//  Created by Cassio Rossi on 27/02/2019.
//  Copyright © 2019 MacMagazine. All rights reserved.
//

import CoreSpotlight
import Kingfisher
import MessageUI
import UIKit

class SettingsTableViewController: UITableViewController {

    // MARK: - Properties -

    @IBOutlet private weak var fontSize: UISlider!
    @IBOutlet private weak var darkMode: UISwitch!
    @IBOutlet private weak var reportProblem: UITableViewCell!

	@IBOutlet private weak var iconOption1: UIImageView!
	@IBOutlet private weak var iconOption2: UIImageView!

	@IBOutlet private weak var pushOptions: AppSegmentedControl!

    var version: String = ""

    // MARK: - View lifecycle -

    override func viewDidLoad() {
        super.viewDidLoad()

        version = getAppVersion()

        let sliderFontSize = Settings().getFontSize()
        fontSize.value = sliderFontSize == "fontemenor" ? 0.0 : sliderFontSize == "fontemaior" ? 2.0 : 1.0

		let iconName = UserDefaults.standard.string(forKey: Definitions.icon)
		self.iconOption1.alpha = iconName ?? IconOptions.option1 == IconOptions.option1 ? 1 : 0.6
		self.iconOption2.alpha = iconName ?? IconOptions.option1 == IconOptions.option2 ? 1 : 0.6

		pushOptions.selectedSegmentIndex = Settings().getPushPreference()

		guard MFMailComposeViewController.canSendMail() else {
			reportProblem.isHidden = true
			return
		}
	}

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)

		applyTheme()
	}

	// MARK: - TableView Methods -

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		let header = ["MACMAGAZINE \(version)", "RECEBER PUSHES PARA", "TAMANHO DA FONTE", "", "ÍCONE DO APLICATIVO", ""]
		return header[section] == "" ? nil : header[section]
    }

    // MARK: - View Methods -

	@IBAction private func clearCache(_ sender: Any) {
		// Delete all posts and podcasts
		CoreDataStack.shared.flush()

		// Delete all downloaded images
		ImageCache.default.clearDiskCache()

		// Clean Spotlight search indexes
		CSSearchableIndex.default().deleteAllSearchableItems(completionHandler: nil)

		// Feedback message
		let alertController = UIAlertController(title: "Cache limpo!", message: "Todo o conteúdo do app será agora recarregado.", preferredStyle: .alert)
		alertController.addAction(UIAlertAction(title: "OK", style: .default) { _ in
			self.dismiss(animated: true)
		})
		if let isDarkMode = UserDefaults.standard.object(forKey: "darkMode") as? Bool {
			alertController.view.tintColor = isDarkMode ? .black : UIColor(hex: "0097d4", alpha: 1)
		}
		self.present(alertController, animated: true)
	}

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

        UserDefaults.standard.set(fontSize, forKey: Definitions.fontSize)
        UserDefaults.standard.synchronize()

		applyTheme()
    }

    @IBAction private func changeDarkMode(_ sender: Any) {
        guard let darkModeSwitch = sender as? UISwitch else {
            return
        }

        UserDefaults.standard.set(darkModeSwitch.isOn, forKey: Definitions.darkMode)
        UserDefaults.standard.synchronize()

        applyTheme()
	}

	@IBAction private func setPushMode(_ sender: Any) {
		guard let segment = sender as? AppSegmentedControl else {
			return
		}
		Settings().updatePushPreferences(segment.selectedSegmentIndex)
    }

	// MARK: - Private Methods -

    fileprivate func applyTheme() {
        let isDarkMode = Settings().isDarkMode()

		let theme: Theme = isDarkMode ? DarkTheme() : LightTheme()
        theme.apply(for: UIApplication.shared)

		darkMode.isOn = isDarkMode
		NotificationCenter.default.post(name: .reloadWeb, object: nil)
    }

}

// MARK: - App Icon Methods -

extension SettingsTableViewController {

	struct IconOptions {
		static let option1 = "option_1"
		static let option2 = "option_2"
		static let phone1 = "phone_1"
		static let phone2 = "phone_2"
		static let tablet1 = "tablet_1"
		static let tablet2 = "tablet_2"

		func getIcon(for option: String) -> String? {
			var icon: String?

			switch option {
			case IconOptions.option1:
				icon = Settings().isPhone() ? IconOptions.phone1 : IconOptions.tablet1
			case IconOptions.option2:
				icon = Settings().isPhone() ? IconOptions.phone2 : IconOptions.tablet2
			default:
				break
			}

			return icon
		}
	}

	@IBAction private func changeAppIcon(_ sender: Any) {
		guard let button = sender as? UIButton,
			let option = button.restorationIdentifier else {
				return
		}
		changeIcon(to: option)
	}

	fileprivate func changeIcon(to iconName: String) {
		guard UIApplication.shared.supportsAlternateIcons,
			let icon = IconOptions().getIcon(for: iconName) else {
				return
		}

		// Temporary change the colors
		if let isDarkMode = UserDefaults.standard.object(forKey: "darkMode") as? Bool {
			UIApplication.shared.keyWindow?.tintColor = isDarkMode ? .black : UIColor(hex: "0097d4", alpha: 1)
		}

		UIApplication.shared.setAlternateIconName(icon) { error in
			if error == nil {
				// Return to theme settings
				DispatchQueue.main.async {
					self.applyTheme()
				}

				UserDefaults.standard.set(iconName, forKey: Definitions.icon)
				UserDefaults.standard.synchronize()

				self.iconOption1.alpha = iconName == IconOptions.option1 ? 1 : 0.6
				self.iconOption2.alpha = iconName == IconOptions.option2 ? 1 : 0.6
			}
		}
	}

}

// MARK: - Mail Methods -

extension SettingsTableViewController: MFMailComposeViewControllerDelegate {

	@IBAction private func reportProblem(_ sender: Any) {
		let composeVC = MFMailComposeViewController()
		composeVC.mailComposeDelegate = self
		composeVC.setSubject("Relato de problema no app MacMagazine \(version)")
		composeVC.setToRecipients(["contato@macmagazine.com.br"])
		self.present(composeVC, animated: true, completion: nil)
	}

	public func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
		controller.dismiss(animated: true, completion: nil)
	}

	fileprivate func getAppVersion() -> String {
		let bundle = Bundle(for: type(of: self))
		let appVersion = bundle.infoDictionary?["CFBundleShortVersionString"] as? String
		return "\(appVersion ?? "0")"
	}

}
