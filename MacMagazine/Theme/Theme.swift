//
//  Theme.swift
//  MacMagazine
//
//  Created by Cassio Rossi on 28/02/2019.
//  Copyright © 2019 MacMagazine. All rights reserved.
//

import UIKit
import WebKit

class AppCollectionViewCell: UICollectionViewCell {}

protocol Theme {
    var tint: UIColor { get }

    var headerFooterColor: UIColor { get }
    var labelColor: UIColor { get }
    var secondaryLabelColor: UIColor { get }
    var subtleLabelColor: UIColor { get }
    var textColor: UIColor { get }

    func apply(for application: UIApplication)
    func extend(_ application: UIApplication)
}

extension Theme {

    func apply(for application: UIApplication) {
        extend(application)

        // Ensure existing views render with new theme
        // https://developer.apple.com/documentation/uikit/uiappearance
        application.windows.reload()
    }

    // Optionally extend theme
    func extend(_ application: UIApplication) {

        // WINDOW

        application.windows.first(where: { $0.isKeyWindow })?.tintColor = tint

        let selectedMode: UIUserInterfaceStyle = Settings().isDarkMode ? .dark : .light
        let overrideInterfaceStyle: UIUserInterfaceStyle = Settings().appearance == .native ? .unspecified : selectedMode
        application.windows.first(where: { $0.isKeyWindow })?.overrideUserInterfaceStyle = overrideInterfaceStyle

        // SEGMENTCONTROL

        UILabel.appearance(whenContainedInInstancesOf: [UISegmentedControl.self]).with {
            $0.textColor = tint
        }

        // LABEL

        var fontSize = 1.0
        if let sliderFontSize = UserDefaults.standard.object(forKey: "font-size-settings") as? String {
            switch sliderFontSize {
            case "fontemenor":
                fontSize = 0.9
            case "fontemaior":
                fontSize = 1.1
            default:
                fontSize = 1.0
            }
        }

        AppLabel.appearance(whenContainedInInstancesOf: [AppTableViewCell.self]).with {
            $0.textColor = labelColor
        }
        AppLabel.appearance(whenContainedInInstancesOf: [UITableViewHeaderFooterView.self]).with {
            $0.textColor = headerFooterColor
            $0.fontSize = CGFloat(0.8)
        }
        AppLabel.appearance().with {
            $0.textColor = .black
        }
        AppHeadline.appearance().with {
            $0.textColor = labelColor
            $0.fontSize = CGFloat(fontSize)
        }
        AppSubhead.appearance().with {
            $0.textColor = secondaryLabelColor
            $0.fontSize = CGFloat(fontSize)
        }
    }

}
