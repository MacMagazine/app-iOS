//
//  Theme.swift
//  MacMagazine
//
//  Created by Cassio Rossi on 28/02/2019.
//  Copyright © 2019 MacMagazine. All rights reserved.
//

import UIKit
import WebKit

class AppTabBar: UITabBar {}
class AppNavigationBar: UINavigationBar {}
class AppSegmentedControl: UISegmentedControl {}
class AppCollectionViewCell: UICollectionViewCell {}

protocol Theme {
	var hightlightLogo: Bool { get }

	var videoLabelColor: UIColor { get }

	var barStyle: UIBarStyle { get }
	var barTintColor: UIColor { get }

	var tint: UIColor { get }
    var secondaryTint: UIColor { get }
    var onTint: UIColor { get }

    var selectedSegmentTintColor: UIColor { get }

    var backgroundColor: UIColor { get }
    var cellBackgroundColor: UIColor { get }
    var separatorColor: UIColor { get }
    var selectionColor: UIColor { get }
	var videoCellBackgroundColor: UIColor { get }

    var headerFooterColor: UIColor { get }
    var labelColor: UIColor { get }
    var secondaryLabelColor: UIColor { get }
    var subtleLabelColor: UIColor { get }
    var textColor: UIColor { get }
    var placeholderTextColor: UIColor { get }

	var keyboardStyle: UIKeyboardAppearance { get }

    func apply(for application: UIApplication)
    func extend(_ application: UIApplication)
}

extension UIColor {
	func image(_ size: CGSize = CGSize(width: 1, height: 38)) -> UIImage {
		return UIGraphicsImageRenderer(size: size).image { rendererContext in
			self.setFill()
			rendererContext.fill(CGRect(origin: .zero, size: size))
		}
	}
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

        application.keyWindow?.tintColor = tint
		if #available(iOS 13.0, *) {
            let overrideInterfaceStyle: UIUserInterfaceStyle = Settings().appearance == .native
                ? .unspecified
                : Settings().isDarkMode ? .dark : .light

            application.keyWindow?.overrideUserInterfaceStyle = overrideInterfaceStyle
		}

        // VIEW

        AppView.appearance().with {
            $0.tintColor = backgroundColor
            $0.backgroundColor = backgroundColor
        }

        // TABBAR

        AppTabBar.appearance().with {
            $0.barStyle = barStyle
            $0.barTintColor = barTintColor
            $0.tintColor = tint
            $0.unselectedItemTintColor = secondaryTint
        }

        // NAVBAR

        AppNavigationBar.appearance().with {
            $0.barStyle = barStyle
            $0.barTintColor = barTintColor
            $0.tintColor = tint
            $0.titleTextAttributes = [
                .foregroundColor: labelColor
            ]
            $0.largeTitleTextAttributes = [
                .foregroundColor: labelColor
            ]
        }

        // SEARCHBAR

        UISearchBar.appearance().with {
            $0.barTintColor = barTintColor
            $0.setSearchFieldBackgroundImage(UIColor.lightGray.withAlphaComponent(0.3).image(), for: .normal)
            $0.searchTextPositionAdjustment = UIOffset(horizontal: 8.0, vertical: 0.0)
        }
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).with {
            $0.textColor = textColor
            $0.placeholderColor = placeholderTextColor
            $0.keyboardAppearance = keyboardStyle
        }

        // TABLEVIEW

        UITableView.appearance().with {
            $0.backgroundColor = backgroundColor
            $0.separatorColor = separatorColor
        }

        AppTableViewCell.appearance().with {
            $0.backgroundColor = cellBackgroundColor
            $0.contentView.backgroundColor = cellBackgroundColor
            $0.selectionColor = selectionColor
        }

        UIView.appearance(whenContainedInInstancesOf: [UITableViewHeaderFooterView.self]).backgroundColor = backgroundColor

        UIRefreshControl.appearance().with {
            $0.tintColor = tint
            $0.backgroundColor = backgroundColor
        }

        // COLLECTIONVIEW

        UICollectionView.appearance().with {
            $0.backgroundColor = backgroundColor
        }
        AppCollectionViewCell.appearance().with {
            $0.backgroundColor = cellBackgroundColor
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
        UILabel.appearance(whenContainedInInstancesOf: [UITableViewHeaderFooterView.self]).with {
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
        AppSmallFont.appearance().with {
            $0.textColor = labelColor
            $0.fontSize = CGFloat(1.0)
        }
        AppBigFont.appearance().with {
            $0.textColor = labelColor
            $0.fontSize = CGFloat(1.0)
        }
        VideoViewLikeLabel.appearance().with {
            $0.textColor = videoLabelColor
            $0.fontSize = CGFloat(0.65)
        }
        VideoViewLikeDataLabel.appearance().with {
            $0.textColor = secondaryLabelColor
            $0.fontSize = CGFloat(0.9)
        }

        // BUTTON

        UIButton.appearance(whenContainedInInstancesOf: [AppTableViewCell.self]).with {
            $0.setTitleColor(tint, for: .normal)
            $0.borderColor = tint
            $0.backgroundColor = .clear
        }

        // IMAGE

        AppImageView.appearance().with {
            $0.borderColor = UIColor(hex: "dddddd", alpha: 1)
        }

        // SWITCH

        UISwitch.appearance().onTintColor = onTint

        // SLIDER

        UISlider.appearance().tintColor = tint

        // SEGMENTCONTROL

        AppSegmentedControl.appearance().with {
            $0.tintColor = tint
            if #available(iOS 13.0, *) {
                $0.selectedSegmentTintColor = selectedSegmentTintColor
            }
        }
        UILabel.appearance(whenContainedInInstancesOf: [AppSegmentedControl.self]).with {
            $0.textColor = tint
            $0.fontSize = CGFloat(0.785)
        }

        // WEBVIEW

        WKWebView.appearance().with {
            $0.backgroundColor = backgroundColor
        }

        // ACTIVITYINDICATOR

        UIActivityIndicatorView.appearance().color = tint

    }

}
