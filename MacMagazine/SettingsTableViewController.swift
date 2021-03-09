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

	@IBOutlet private weak var pushOptions: UISegmentedControl!

    @IBOutlet private weak var iconOption1Btn: UIButton!
    @IBOutlet private weak var iconOption2Btn: UIButton!
    @IBOutlet private weak var iconOption3Btn: UIButton!
    @IBOutlet private weak var iconOption4Btn: UIButton!
    @IBOutlet private weak var iconOption1: UIImageView!
    @IBOutlet private weak var iconOption2: UIImageView!
    @IBOutlet private weak var iconOption3: UIImageView!
    @IBOutlet private weak var iconOption4: UIImageView!
    @IBOutlet private weak var iconOption1Selected: UIImageView!
    @IBOutlet private weak var iconOption2Selected: UIImageView!
    @IBOutlet private weak var iconOption3Selected: UIImageView!
    @IBOutlet private weak var iconOption4Selected: UIImageView!

    @IBOutlet private weak var darkModeSegmentControl: UISegmentedControl!

    @IBOutlet private weak var intensityPostRead: UISwitch!
    @IBOutlet private weak var appearanceCellIntensity: UITableViewCell!
    @IBOutlet private weak var readTransparency: UISlider!
    @IBOutlet private weak var readTransparencyValue: UILabel!

    @IBOutlet private weak var patraoButton: UIButton!

    @IBOutlet private weak var buyBtn: UIButton!
    @IBOutlet private weak var buyMessage: UILabel!
    @IBOutlet private weak var purchasedMessage: UILabel!
    @IBOutlet private weak var spin: UIActivityIndicatorView!
    @IBOutlet private weak var restoreBtn: UIButton!

    enum IconOptionAccessibilityLabel: String {
        case whiteBackground = "Ícone do aplicativo com fundo branco."
        case blueBackground = "Ícone do aplicativo com fundo azul."
        case blueOverBlack = "Ícone azul do aplicativo com fundo preto."
        case whiteOverBlack = "Ícone claro do aplicativo com fundo preto."

        func accessibilityText(selected: Bool) -> String {
            return "\(self)\(selected ? " Selected." : "")"
        }
    }

    // MARK: - View lifecycle -

    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView?.register(UINib(nibName: "SettingsHeaderCell", bundle: nil), forHeaderFooterViewReuseIdentifier: "headerCell")
        self.tableView?.register(UINib(nibName: "SettingsSubHeaderCell", bundle: nil), forHeaderFooterViewReuseIdentifier: "subHeaderCell")
        self.tableView?.register(UINib(nibName: "SettingsDisclaimerFooter", bundle: nil), forHeaderFooterViewReuseIdentifier: "disclaimerFooter")

        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 50

        setInitialValues()
        setupInAppPurchase()
    }

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)

		guard let delegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        delegate.supportedInterfaceOrientation = Settings().orientations

        patraoButton.setTitle(Settings().loginPatrao, for: .normal)
	}

	override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        tableView.reloadData()
	}

	// MARK: - TableView Methods -

    fileprivate func getHeaders() -> [String] {
        var header = [String]()
		header.append("Notificações push")
		header.append("Aparência")
        header.append("Ícone do app")
        header.append("Assinaturas")
        header.append("Sobre")
        return header
    }

    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headers = getHeaders()
        let identifier = section == headers.count - 1 || section == getHeaders().count - 2 ? "subHeaderCell" : "headerCell"

        guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: identifier) as? SettingsHeaderCell else {
            return nil
        }

        if headers.isEmpty ||
            (headers.count - 1) < section ||
            headers[section] == "" {
            return nil
        }

        header.setHeader(headers[section], type: section == getHeaders().count - 1 ? .version : .subscription)
        return header
    }

    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == getHeaders().count - 1 {
            guard let footer = tableView.dequeueReusableHeaderFooterView(withIdentifier: "disclaimerFooter") as? SettingsHeaderCell else {
                return 18
            }
            let labelWidth = CGFloat(Int(tableView.bounds.size.width - 24.0))
            return footer.footerHeight(width: labelWidth)
        }
        return 18
    }

    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if section == getHeaders().count - 1 {
            guard let footer = tableView.dequeueReusableHeaderFooterView(withIdentifier: "disclaimerFooter") as? SettingsHeaderCell else {
                return nil
            }
            footer.showFooter()
            return footer
        }
        return nil
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        struct RowSize {
            static let zero: CGFloat = 0
            static let icons: CGFloat = 105
            static let intensity: CGFloat = 94
            static let automaticDimension: CGFloat = UITableView.automaticDimension
        }

        // "INTENSIDADE POST LIDO"
        if indexPath.section == 1 &&
            indexPath.row == 2 {
            if appearanceCellIntensity.isHidden {
                return RowSize.zero
            } else {
                return RowSize.automaticDimension
            }
        }
        // "ÍCONE DO APLICATIVO"
        if indexPath.section == 2 {
            return RowSize.icons
        }
        return RowSize.automaticDimension
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

// MARK: - Cache -

extension SettingsTableViewController {
	@IBAction private func clearCache(_ sender: Any) {
        self.flush(.keepAllStatus)
    }

    @IBAction private func clearCacheWithOptions(_ sender: Any) {
        guard let gesture = sender as? UILongPressGestureRecognizer,
            let button = gesture.view as? UIButton else {
            return
        }
        if gesture.state == .began {
            let alertController = UIAlertController(title: "Limpar cache", message: "Escolha uma opção", preferredStyle: .actionSheet)

            alertController.addAction(UIAlertAction(title: "Limpar tudo", style: .destructive) { _ in
                self.flush(.all)
            })

            alertController.addAction(UIAlertAction(title: "Limpar e manter favoritos", style: .default) { _ in
                self.flush(.keepFavorite)
            })

            alertController.addAction(UIAlertAction(title: "Limpar e manter status de leitura", style: .default) { _ in
                self.flush(.keepReadStatus)
            })

            alertController.addAction(UIAlertAction(title: "Limpar e manter favoritos e status de leitura", style: .default) { _ in
                self.flush(.keepAllStatus)
            })

            alertController.addAction(UIAlertAction(title: "Apagar somente imagens", style: .default) { _ in
                self.flush(.imagesOnly)
            })

            alertController.addAction(UIAlertAction(title: "Cancelar", style: .cancel) { _ in
                self.dismiss(animated: true)
            })

            if let popoverController = alertController.popoverPresentationController {
                popoverController.sourceView = button
                popoverController.sourceRect = CGRect(x: button.bounds.midX, y: button.bounds.midY, width: 0, height: 0)
            }

            self.present(alertController, animated: true)
        }
	}

    fileprivate func flush(_ type: FlushType) {
        // Delete all posts and podcasts
        CoreDataStack.shared.flush(type: type)

        // Delete all downloaded images
        ImageCache.default.clearDiskCache()

        // Clean Spotlight search indexes
        CSSearchableIndex.default().deleteAllSearchableItems(completionHandler: nil)

        // Clean cookies
        if type == .all {
            UserDefaults.standard.set(true, forKey: Definitions.deleteAllCookies)
            UserDefaults.standard.synchronize()
        }

        // Feedback message
        let alertController = UIAlertController(title: "Cache limpo!", message: "O conteúdo do app será recarregado.", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default) { _ in
            NotificationCenter.default.post(name: .refreshAfterBackground, object: nil)

            self.dismiss(animated: true)
        })
        self.present(alertController, animated: true)
    }
}

// MARK: - Push -

extension SettingsTableViewController {
	@IBAction private func setPushMode(_ sender: Any) {
		guard let segment = sender as? UISegmentedControl else {
			return
		}
		Settings().updatePushPreference(segment.selectedSegmentIndex)
    }
}

// MARK: - Login patrons -

extension SettingsTableViewController {
    @IBAction private func login(_ sender: Any) {
        if Settings().isPatrao {
            var settings = Settings()
            settings.isPatrao = false
        } else {
            if let url = URL(string: API.APIParams.patrao) {
                let storyboard = UIStoryboard(name: "WebView", bundle: nil)
                guard let controller = storyboard.instantiateViewController(withIdentifier: "PostDetail") as? WebViewController else {
                    return
                }
                controller.postURL = url

                controller.modalPresentationStyle = .overFullScreen
                show(controller, sender: self)
            }
        }
        patraoButton.setTitle(Settings().loginPatrao, for: .normal)
    }
}

// MARK: - Initial Values -

extension SettingsTableViewController {
    fileprivate func setInitialValues() {
        pushOptions.selectedSegmentIndex = Settings().pushPreference

        let iconName = UserDefaults.standard.string(forKey: Definitions.icon)
        setIconOptionsSelection(selected: iconName ?? "option_1")

        let transparency = Settings().transparency
        intensityPostRead.isOn = transparency < 1
        readTransparency.value = Float(transparency * 100.0)
        readTransparencyValue.text = "\(String(describing: Int(readTransparency.value)))%"

        appearanceCellIntensity.isHidden = true

        darkModeSegmentControl.selectedSegmentIndex = Settings().appearance.rawValue
    }
}

// MARK: - Mail Methods -

extension SettingsTableViewController: MFMailComposeViewControllerDelegate {
	@IBAction private func reportProblem(_ sender: Any) {
        guard MFMailComposeViewController.canSendMail() else {
            if let url = URL(string: "mailto:contato@macmagazine.com.br?subject=Relato de problema no app MacMagazine \(Settings().appVersion)"),
               UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }

            return
        }

        let composeVC = MFMailComposeViewController()
        composeVC.mailComposeDelegate = self
        composeVC.setSubject("Relato de problema no app MacMagazine \(Settings().appVersion)")
        composeVC.setToRecipients(["contato@macmagazine.com.br"])

        self.present(composeVC, animated: true, completion: nil)
	}

	public func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
		controller.dismiss(animated: true)
	}
}

// MARK: - Appearance Methods -

extension SettingsTableViewController {

    @IBAction private func changeDarkMode(_ sender: Any) {
        guard let darkMode = sender as? UISegmentedControl else {
            return
        }
        UserDefaults.standard.set(darkMode.selectedSegmentIndex, forKey: Definitions.darkMode)
        UserDefaults.standard.synchronize()

        Settings().applyTheme()

        NotificationCenter.default.post(name: .updateCookie, object: Definitions.darkMode)
    }

    @IBAction private func enableReadIntensity(_ sender: Any) {
        guard let intensity = sender as? UISwitch else {
            return
        }

        let value: Float = intensity.isOn ? 50.0 : 100.0

        setIntensity(value)
        readTransparency.setValue(value, animated: true)

        if !intensity.isOn {
            appearanceCellIntensity.isHidden = true
            self.tableView.reloadData()
        }
    }

    @IBAction private func showReadIntensitySlider(_ sender: Any) {
        guard let gesture = sender as? UILongPressGestureRecognizer else {
            return
        }
        if gesture.state == .began {
            let transparency = Settings().transparency
            readTransparency.value = Float(transparency * 100.0)
            readTransparencyValue.text = "\(String(describing: Int(readTransparency.value)))%"

            appearanceCellIntensity.isHidden = !appearanceCellIntensity.isHidden
            self.tableView.reloadData()
        }
    }

    @IBAction private func changeReadTransparencyIntensity(_ sender: Any) {
        guard let slider = sender as? UISlider else {
            return
        }
        setIntensity(slider.value)
    }

    fileprivate func setIntensity(_ intensity: Float) {
        readTransparencyValue.text = "\(String(describing: Int(intensity)))%"

        UserDefaults.standard.set(intensity / 100.0, forKey: Definitions.transparency)
        UserDefaults.standard.synchronize()

        NotificationCenter.default.post(name: .reloadData, object: nil)
    }

}

// MARK: - App Icon Methods -

extension SettingsTableViewController {

    struct IconOptions {
        static let option1 = "option_1"
        static let option2 = "option_2"
        static let option3 = "option_3"
        static let option4 = "option_4"
        static let type = Settings().isPhone ? "phone" : "tablet"
        static let icon1 = "\(type)_1"
        static let icon2 = "\(type)_2"
        static let icon3 = "\(type)_3"
        static let icon4 = "\(type)_4"

        func getIcon(for option: String) -> String? {
            var icon: String?

            switch option {
            case IconOptions.option1:
                icon = IconOptions.icon1
            case IconOptions.option2:
                icon = IconOptions.icon2
            case IconOptions.option3:
                icon = IconOptions.icon3
            case IconOptions.option4:
                icon = IconOptions.icon4
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

    fileprivate func setIconOptionsSelection(selected iconName: String) {
        let selectedImage = UIImage(systemName: "checkmark.circle.fill")
        let normal = UIImage(systemName: "circle")

        let tintSelectedColor = UIColor(named: "MMBlue")
        let tintColor = UIColor.systemGray

        iconOption1Selected.image = iconName == IconOptions.option1 ? selectedImage : normal
        iconOption1Selected.tintColor = iconName == IconOptions.option1 ? tintSelectedColor : tintColor
        iconOption1Btn.accessibilityLabel = IconOptionAccessibilityLabel.whiteBackground.accessibilityText(selected: iconName == IconOptions.option1)

        iconOption2Selected.image = iconName == IconOptions.option2 ? selectedImage : normal
        iconOption2Selected.tintColor = iconName == IconOptions.option2 ? tintSelectedColor : tintColor
        iconOption2Btn.accessibilityLabel = IconOptionAccessibilityLabel.blueBackground.accessibilityText(selected: iconName == IconOptions.option2)

        iconOption3Selected.image = iconName == IconOptions.option3 ? selectedImage : normal
        iconOption3Selected.tintColor = iconName == IconOptions.option3 ? tintSelectedColor : tintColor
        iconOption3Btn.accessibilityLabel = IconOptionAccessibilityLabel.blueOverBlack.accessibilityText(selected: iconName == IconOptions.option3)

        iconOption4Selected.image = iconName == IconOptions.option4 ? selectedImage : normal
        iconOption4Selected.tintColor = iconName == IconOptions.option4 ? tintSelectedColor : tintColor
        iconOption4Btn.accessibilityLabel = IconOptionAccessibilityLabel.whiteOverBlack.accessibilityText(selected: iconName == IconOptions.option4)
    }

    fileprivate func changeIcon(to iconName: String) {
        guard UIApplication.shared.supportsAlternateIcons,
            let icon = IconOptions().getIcon(for: iconName) else {
                return
        }

        UIApplication.shared.setAlternateIconName(icon) { error in
            if error == nil {
                UserDefaults.standard.set(iconName, forKey: Definitions.icon)
                UserDefaults.standard.synchronize()

                self.setIconOptionsSelection(selected: iconName)
            }
        }
    }

}

// MARK: - Subscriptions -

extension SettingsTableViewController {
    @IBAction private func recover(_ sender: Any) {
        Subscriptions.shared.restore()
    }

    @IBAction private func buy(_ sender: Any) {
        Subscriptions.shared.purchase()
    }

    fileprivate func setupInAppPurchase() {
        spin.stopAnimating()
        buyBtn.isHidden = false
        buyBtn.setTitle("-", for: .normal)
        buyBtn.isEnabled = false
        buyBtn.backgroundColor = UIColor(named: "MMGrayWhite")
        purchasedMessage.isHidden = true
        restoreBtn.isEnabled = false

        Subscriptions.shared.status = { [weak self] status in
            self?.spin.stopAnimating()
            self?.buyBtn.isHidden = false
            self?.buyMessage.isHidden = false
            self?.restoreBtn.isEnabled = true

            switch status {
                case .canPurchase,
                     .expired:
                    self?.buyBtn.isEnabled = true
                    self?.buyBtn.backgroundColor = UIColor(named: "MMBlue")
                    self?.restoreBtn.isEnabled = true
                    self?.purchasedMessage.isHidden = true

                    var settings = Settings()
                    settings.purchased = false

                case .processing:
                    self?.spin.startAnimating()
                    self?.buyBtn.isHidden = true
                    self?.restoreBtn.isEnabled = false

                case .gotProductPrice(let price):
                    self?.buyBtn.setTitle(price, for: .normal)

                case .purchasedSuccess:
                    self?.buyBtn.isHidden = true
                    self?.buyMessage.isHidden = true
                    self?.purchasedMessage.isHidden = false
                    self?.restoreBtn.isEnabled = false
                    self?.patraoButton.isEnabled = false

                    var settings = Settings()
                    settings.purchased = true

                case .fail:
                    self?.buyBtn.isEnabled = false
                    self?.buyBtn.backgroundColor = UIColor(named: "MMGrayWhite")
                    self?.buyBtn.setTitle("-", for: .normal)

                    var settings = Settings()
                    settings.purchased = false
            }

            if status == .expired {
                let alertController = UIAlertController(title: "MacMagazine",
                                                        message: "Sua assinatura está expirada.",
                                                        preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "OK", style: .default) { _ in
                    self?.dismiss(animated: true)
                })
                self?.present(alertController, animated: true)
            }
        }

        Subscriptions.shared.getProducts()
    }
}
