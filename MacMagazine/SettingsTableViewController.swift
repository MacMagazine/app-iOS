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

    @IBOutlet private weak var reportProblem: AppTableViewCell!
	@IBOutlet private weak var pushOptions: AppSegmentedControl!

    // MARK: - View lifecycle -

    override func viewDidLoad() {
        super.viewDidLoad()

		pushOptions.selectedSegmentIndex = Settings().pushPreference

        guard MFMailComposeViewController.canSendMail() else {
			reportProblem.isHidden = true
			return
		}
    }

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)

        tableView.backgroundColor = Settings().theme.backgroundColor

        guard let delegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        delegate.supportedInterfaceOrientation = Settings().orientations
	}

	// MARK: - TableView Methods -

    fileprivate func getHeaders() -> [String] {
        let header = ["MACMAGAZINE \(getAppVersion())", "RECEBER PUSHES PARA", ""]
        return header
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let header = getHeaders()
        if header.isEmpty ||
            (header.count - 1) < section ||
            header[section] == "" {
            return nil
        }
		return header[section]
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
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
		if Settings().isDarkMode {
			alertController.view.tintColor = LightTheme().tint
		}
		self.present(alertController, animated: true)
	}

	@IBAction private func setPushMode(_ sender: Any) {
		guard let segment = sender as? AppSegmentedControl else {
			return
		}
		Settings().updatePushPreference(segment.selectedSegmentIndex)
    }

	// MARK: - Private Methods -

    fileprivate func getAppVersion() -> String {
        let bundle = Bundle(for: type(of: self))
        let appVersion = bundle.infoDictionary?["CFBundleShortVersionString"] as? String
        return "\(appVersion ?? "0")"
    }

}

// MARK: - Mail Methods -

extension SettingsTableViewController: MFMailComposeViewControllerDelegate {

	@IBAction private func reportProblem(_ sender: Any) {
		let composeVC = MFMailComposeViewController()
		composeVC.mailComposeDelegate = self
		composeVC.setSubject("Relato de problema no app MacMagazine \(getAppVersion())")
		composeVC.setToRecipients(["contato@macmagazine.com.br"])

		// Temporary change the colors
		Settings().applyLightTheme()

		self.present(composeVC, animated: true, completion: nil)
	}

	public func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
		controller.dismiss(animated: true) {
			Settings().applyDarkTheme()
		}
	}

}
