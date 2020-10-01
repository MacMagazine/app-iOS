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
class AppFootnote: UILabel {}
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

extension AppFootnote {
    @objc dynamic override var fontSize: CGFloat {
        get {
            let font = UIFontDescriptor.preferredFontDescriptor(withTextStyle: .footnote)
            return font.pointSize
        }
        set {
            let font = UIFontDescriptor.preferredFontDescriptor(withTextStyle: .footnote)
            self.font = UIFont(descriptor: font, size: font.pointSize * newValue)
        }
    }
}
