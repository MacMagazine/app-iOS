//
//  LookTableViewController.swift
//  MacMagazine
//
//  Created by Cassio Rossi on 28/11/19.
//  Copyright © 2019 MacMagazine. All rights reserved.
//

import UIKit

class LookTableViewController: UITableViewController {

    // MARK: - Properties -

    @IBOutlet private weak var fontSize: UISlider!

    @IBOutlet private weak var iconOption1: UIImageView!
    @IBOutlet private weak var iconOption2: UIImageView!
    @IBOutlet private weak var iconOption3: UIImageView!

    @IBOutlet private weak var appearanceCell1: AppTableViewCell!
    @IBOutlet private weak var appearanceCell2: AppTableViewCell!
    @IBOutlet private weak var darkModeSystem: UISwitch!
    @IBOutlet private weak var darkModeSegmentControl: AppSegmentedControl!

    // MARK: - View lifecycle -

    override func viewDidLoad() {
        super.viewDidLoad()

        let sliderFontSize = Settings().fontSize
        fontSize.value = sliderFontSize == "fontemenor" ? 0.0 : sliderFontSize == "fontemaior" ? 2.0 : 1.0

        let iconName = UserDefaults.standard.string(forKey: Definitions.icon)
        self.iconOption1.alpha = iconName ?? IconOptions.option1 == IconOptions.option1 ? 1 : 0.6
        self.iconOption2.alpha = iconName ?? IconOptions.option1 == IconOptions.option2 ? 1 : 0.6
        self.iconOption3.alpha = iconName ?? IconOptions.option1 == IconOptions.option3 ? 1 : 0.6
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        guard let delegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        delegate.supportedInterfaceOrientation = Settings().orientations

        tableView.backgroundColor = Settings().theme.backgroundColor
        setupAppearanceSettings()
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

        UserDefaults.standard.set(fontSize, forKey: Definitions.fontSize)
        UserDefaults.standard.synchronize()

        applyTheme()
    }

    @IBAction private func changeAppearanceFollowSystem(_ sender: Any) {
        guard let followSystem = sender as? UISwitch else {
            return
        }
        UserDefaults.standard.set(followSystem.isOn ? Appearance.native.rawValue : darkModeSegmentControl.selectedSegmentIndex, forKey: Definitions.darkMode)
        UserDefaults.standard.synchronize()

        applyTheme()
        setupAppearanceSettings()
    }

    @IBAction private func changeDarkMode(_ sender: Any) {
        guard let darkMode = sender as? UISegmentedControl else {
            return
        }
        UserDefaults.standard.set(darkMode.selectedSegmentIndex, forKey: Definitions.darkMode)
        UserDefaults.standard.synchronize()

        applyTheme()
    }

    // MARK: - Private Methods -

    fileprivate func setupAppearanceSettings() {
        appearanceCell1.isUserInteractionEnabled = Settings().supportsNativeDarkMode
        darkModeSystem.isOn = Settings().supportsNativeDarkMode && Settings().appearance == .native
        if !appearanceCell1.isUserInteractionEnabled {
            appearanceCell1.subviews[0].subviews.forEach {
                if let view = $0 as? UILabel {
                    view.isEnabled = false
                }
                if let view = $0 as? UISwitch {
                    view.isEnabled = false
                }
            }
        }

        appearanceCell2.isUserInteractionEnabled = !darkModeSystem.isOn
        darkModeSegmentControl.selectedSegmentIndex = Settings().isDarkMode ? 1 : 0
        appearanceCell2.subviews[0].subviews.forEach {
            if let view = $0 as? UISegmentedControl {
                view.isEnabled = appearanceCell2.isUserInteractionEnabled
            }
        }
    }

    fileprivate func applyTheme() {
        Settings().applyTheme()
        tableView.backgroundColor = Settings().theme.backgroundColor
    }

}

// MARK: - App Icon Methods -

extension LookTableViewController {

    struct IconOptions {
        static let option1 = "option_1"
        static let option2 = "option_2"
        static let option3 = "option_3"
        static let type = Settings().isPhone ? "phone" : "tablet"
        static let icon1 = "\(type)_1"
        static let icon2 = "\(type)_2"
        static let icon3 = "\(type)_3"

        func getIcon(for option: String) -> String? {
            var icon: String?

            switch option {
            case IconOptions.option1:
                icon = IconOptions.icon1
            case IconOptions.option2:
                icon = IconOptions.icon2
            case IconOptions.option3:
                icon = IconOptions.icon3
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
        if Settings().isDarkMode {
            UIApplication.shared.keyWindow?.tintColor = LightTheme().tint
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
                self.iconOption3.alpha = iconName == IconOptions.option3 ? 1 : 0.6
            }
        }
    }

}
