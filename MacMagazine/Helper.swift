//
//  Helper.swift
//  MacMagazine
//
//  Created by Cassio Rossi on 24/09/2022.
//  Copyright © 2022 MacMagazine. All rights reserved.
//

import OneSignalExtension
import UIKit

// MARK: -

enum Definitions {
    static let darkMode = "darkMode"
    static let fontSize = "font-size-settings"
    static let icon = "icon"
    static let watch = "watch"
    static let askForReview = "askForReview"
    static let all_posts_pushes = "all_posts_pushes"
    static let pushPreferences = "pushPreferences"
    static let transparency = "transparency"
    static let mm_patrao = "mm_patrao"
    static let purchased = "purchased"
    static let whatsnew = "whatsnew"
    static let deleteAllCookies = "deleteAllCookies"
    static let mmLive = "mmLive"
    static let badge = "badge"
}

struct Helper {
	var badgeCount: Int = { CoreDataStack.shared.numberOfUnreadPosts() }()
}

#if !WIDGET
extension Helper {
	func showBadge() {
		delay(1) {
			if UserDefaults.standard.bool(forKey: Definitions.badge) {
				UIApplication.shared.applicationIconBadgeNumber = badgeCount
				updateOneSignal(counter: badgeCount)
			} else {
				// Icon badge should be set to -1 to disappear but keep history of notifications
				UIApplication.shared.applicationIconBadgeNumber = -1
				updateOneSignal(counter: 0)
			}
		}
    }

	fileprivate func updateOneSignal(counter: Int) {
		logD(OneSignalExtensionBadgeHandler.currentCachedBadgeValue())
		OneSignalExtensionBadgeHandler.updateCachedBadgeValue(counter)
		logD(OneSignalExtensionBadgeHandler.currentCachedBadgeValue())
	}
}
#endif
