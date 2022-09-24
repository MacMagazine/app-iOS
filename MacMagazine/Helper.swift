//
//  Helper.swift
//  MacMagazine
//
//  Created by Cassio Rossi on 24/09/2022.
//  Copyright © 2022 MacMagazine. All rights reserved.
//

import Foundation

struct Helper {
    var badgeCount: Int = {
        return CoreDataStack.shared.numberOfUnreadPosts()
    }()
}
