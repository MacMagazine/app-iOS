import Foundation
import MacMagazineLibrary

extension NewsCategory {
    var query: (String, String)? {
        switch self {
        case .highlights: (APIDefinitions.cat, "674")
        case .news, .all: nil
        case .podcast: (APIDefinitions.cat, "101")
        case .youtube: (APIDefinitions.cat, "9898")
        case .appletv: (APIDefinitions.tag, "apple-tv")
        case .reviews: (APIDefinitions.tag, "review")
        case .tutorials: (APIDefinitions.cat, "302")
        case .rumors: (APIDefinitions.cat, "12")
        }
    }
}
