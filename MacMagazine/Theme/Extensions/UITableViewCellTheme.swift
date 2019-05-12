//
//  UITableViewCellTheme.swift
//  MacMagazine
//
//  Created by Cassio Rossi on 28/02/2019.
//  Copyright © 2019 MacMagazine. All rights reserved.
//

import UIKit

public extension UITableViewCell {

    // The color of the cell when it is selected.
    @objc dynamic var selectionColor: UIColor? {
        get { return selectedBackgroundView?.backgroundColor }
        set {
            guard selectionStyle != .none else {
                return
            }
            selectedBackgroundView = UIView().with {
                $0.backgroundColor = newValue
            }
        }
    }

    // The color of the content background cell.
    @objc dynamic var contentColor: UIColor? {
        get { return contentView.backgroundColor }
        set {
            contentView.backgroundColor = newValue
        }
    }

}
