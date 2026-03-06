import FeedLibrary
import SwiftData
import SwiftUI

@Observable
final class ShortcutManager {
    static let shared = ShortcutManager()

    var url: String?
    var context: ModelContext?

    func process(shortcut: UIApplicationShortcutItem) {
        switch ShortcutActions(rawValue: shortcut.type) {
        case .openLastSeenPost:
            if let context,
               let lastSeen = FeedDB.lastSeen(using: context) {
                self.url = lastSeen.link
            }

        case .openMostRecentPost:
            if let context,
               let mostRecent = FeedDB.mostRecent(using: context) {
                self.url = mostRecent.link
            }

        case .openSearchPost:
            break
        default:
            break
        }
    }
}
