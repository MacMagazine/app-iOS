//
//  UILabelTheme.swift
//  MacMagazine
//
//  Created by Cassio Rossi on 28/02/2019.
//  Copyright © 2019 MacMagazine. All rights reserved.
//

import UIKit

class AppHeadline: UILabel {}
class AppSubhead: UILabel {}
class AppSmallFont: UILabel {}
class AppBigFont: UILabel {}
class AppLabel: UILabel {}

public extension UILabel {
    @objc dynamic var fontSize: CGFloat {
        get {
            let font = UIFontDescriptor.preferredFontDescriptor(withTextStyle: .body)
            return font.pointSize
        }
        set {
            let font = UIFontDescriptor.preferredFontDescriptor(withTextStyle: .body)
            self.font = UIFont(descriptor: font, size: font.pointSize * newValue)
        }
    }
}

extension AppHeadline {
    @objc dynamic override var fontSize: CGFloat {
        get {
            let font = UIFontDescriptor.preferredFontDescriptor(withTextStyle: .headline)
            return font.pointSize
        }
        set {
            let font = UIFontDescriptor.preferredFontDescriptor(withTextStyle: .headline)
            self.font = UIFont(descriptor: font, size: font.pointSize * newValue)
        }
    }
}

extension AppSubhead {
    @objc dynamic override var fontSize: CGFloat {
        get {
            let font = UIFontDescriptor.preferredFontDescriptor(withTextStyle: .subheadline)
            return font.pointSize
        }
        set {
            let font = UIFontDescriptor.preferredFontDescriptor(withTextStyle: .subheadline)
            self.font = UIFont(descriptor: font, size: font.pointSize * newValue)
        }
    }
}

extension AppSmallFont {
    @objc dynamic override var fontSize: CGFloat {
        get {
            return 18.0
        }
        set {
            guard let font = self.font else {
                return
            }
            self.font = UIFont(name: font.fontName, size: 18.0)
        }
    }
}

extension AppBigFont {
    @objc dynamic override var fontSize: CGFloat {
        get {
            return 28.0
        }
        set {
            guard let font = self.font else {
                return
            }
            self.font = UIFont(name: font.fontName, size: 28.0)
        }
    }
}
