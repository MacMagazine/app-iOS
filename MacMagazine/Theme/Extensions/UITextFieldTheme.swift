//
//  UITextFieldTheme.swift
//  MacMagazine
//
//  Created by Cassio Rossi on 28/02/2019.
//  Copyright © 2019 MacMagazine. All rights reserved.
//

import UIKit

public extension UITextField {
    @objc dynamic var placeholderColor: UIColor? {
        get { return self.placeholderColor }
        set {
            attributedPlaceholder = NSAttributedString(string: self.placeholder ?? "",
                                                       attributes: [NSAttributedString.Key.foregroundColor: newValue ?? .black])
        }
    }
}
