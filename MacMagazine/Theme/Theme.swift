//
//  Theme.swift
//  MacMagazine
//
//  Created by Cassio Rossi on 28/02/2019.
//  Copyright © 2019 MacMagazine. All rights reserved.
//

import UIKit

class AppHeadline: UILabel {}
class AppSubhead: UILabel {}

protocol Theme {
    var tint: UIColor { get }
    var secondaryTint: UIColor { get }
    var onTint: UIColor { get }

    var backgroundColor: UIColor { get }
    var cellBackgroundColor: UIColor { get }
    var separatorColor: UIColor { get }
    var selectionColor: UIColor { get }

    var headerFooterColor: UIColor { get }
    var labelColor: UIColor { get }
    var secondaryLabelColor: UIColor { get }
    var subtleLabelColor: UIColor { get }
    var textColor: UIColor { get }
    var placeholderTextColor: UIColor { get }

    var barStyle: UIBarStyle { get }
    var barTintColor: UIColor { get }

    func apply(for application: UIApplication)
    func extend()
}

extension Theme {

    func apply(for application: UIApplication) {

        application.keyWindow?.tintColor = tint

        // TABBAR

        UITabBar.appearance().with {
            $0.barStyle = barStyle
            $0.barTintColor = barTintColor
            $0.tintColor = tint
            $0.unselectedItemTintColor = secondaryTint
        }

        // NAVBAR

        UINavigationBar.appearance().with {
            $0.barStyle = barStyle
            $0.barTintColor = barTintColor
            $0.tintColor = tint
            $0.titleTextAttributes = [
                .foregroundColor: labelColor
            ]

            if #available(iOS 11.0, *) {
                $0.largeTitleTextAttributes = [
                    .foregroundColor: labelColor
                ]
            }
        }

        // SEARCHBAR

        UISearchBar.appearance().with {
            $0.barTintColor = barTintColor
        }
        UITextField.appearance().with {
            $0.textColor = textColor
            $0.placeholderColor = placeholderTextColor
        }

        // TABLEVIEW

        UITableView.appearance().with {
            $0.backgroundColor = backgroundColor
            $0.separatorColor = separatorColor
        }

        UITableViewCell.appearance().with {
            $0.backgroundColor = .clear
            $0.contentColor = cellBackgroundColor
            $0.selectionColor = selectionColor
        }

        UIView.appearance(whenContainedInInstancesOf: [UITableViewHeaderFooterView.self]).backgroundColor = backgroundColor
        UILabel.appearance(whenContainedInInstancesOf: [UITableViewHeaderFooterView.self]).textColor = headerFooterColor

        // LABEL

        UILabel.appearance().textColor = labelColor
        AppHeadline.appearance().textColor = labelColor
        AppSubhead.appearance().textColor = secondaryLabelColor

        // BUTTON

        UIButton.appearance().with {
            $0.setTitleColor(tint, for: .normal)
            $0.borderColor = tint
        }

        // SWITCH

        UISwitch.appearance().with {
            $0.onTintColor = onTint
        }

        // SLIDER

        UISlider.appearance().tintColor = tint

        extend()

        // Ensure existing views render with new theme
        // https://developer.apple.com/documentation/uikit/uiappearance
        application.windows.reload()
    }

    // Optionally extend theme
    func extend() {}

}
