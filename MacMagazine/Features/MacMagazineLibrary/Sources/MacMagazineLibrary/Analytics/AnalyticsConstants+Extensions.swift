import Foundation
import AnalyticsLibrary

// MARK: - Social Extension

public extension Social {
    /// Returns the analytics screen constant for this social type
    var analyticsScreen: AnalyticsConstants.Screen {
        switch self {
        case .videos: return .socialVideos
        case .podcast: return .socialPodcast
        case .instagram: return .socialInstagram
        }
    }
}

// MARK: - AppTabs Extension

public extension AppTabs {
    /// Returns the analytics screen constant for this tab if applicable
    var analyticsScreen: AnalyticsConstants.Screen? {
        switch self {
        case .settings: return .settings
        case .live: return .live
        case .news, .social, .search: return nil
        }
    }
}
