//
//  ShortcutActions.swift
//  MacMagazine
//
//  Created by Marcos Ferreira on 31/07/25.
//  Copyright © 2025 MacMagazine. All rights reserved.
//

import Foundation

enum ShortcutActions: String {
    case openLastSeenPost
    case openMostRecentPost
    case openSearchPost
    case none = ""

    var notificationName: Notification.Name? {
        switch self {
        case .openLastSeenPost: return .shortcutActionLastPost
        case .openMostRecentPost: return .shortcutActionRecentPost
        case .openSearchPost: return .shortcutActionSearchPost
        case .none: return nil
        }
    }
}
