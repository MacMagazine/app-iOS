import FeedLibrary
import MacMagazineLibrary
import SwiftData
import SwiftUI

@Observable
final class ShortcutManager {
    static let shared = ShortcutManager()

    var context: ModelContext? {
        didSet { processPendingShortcut() }
    }
    var url: String?
    var tab: AppTabs?
    var pendingShortcut: UIApplicationShortcutItem?

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
            tab = .search

        default:
            break
        }
    }

    private func processPendingShortcut() {
        guard let pendingShortcut else { return }
        self.pendingShortcut = nil
        process(shortcut: pendingShortcut)
    }
}
