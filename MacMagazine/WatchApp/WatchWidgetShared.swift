import Foundation

enum MacMagazineWidgetSharedStore {
    static let appGroupID = "group.com.brit.beta.macmagazine"

    private enum Keys {
        static let lastPostTitle = "macmagazine.widget.lastPost.title"
        static let lastPostDate = "macmagazine.widget.lastPost.date"
        static let lastPostId = "macmagazine.widget.lastPost.id"
    }

    struct Snapshot: Equatable {
        let postId: String
        let title: String
        let date: Date
    }

    static func write(snapshot: Snapshot) {
        guard let defaults = UserDefaults(suiteName: appGroupID) else { return }

        defaults.set(snapshot.title, forKey: Keys.lastPostTitle)
        defaults.set(snapshot.date, forKey: Keys.lastPostDate)
        defaults.set(snapshot.postId, forKey: Keys.lastPostId)
        defaults.synchronize()
    }

    static func readSnapshot() -> Snapshot? {
        guard let defaults = UserDefaults(suiteName: appGroupID) else { return nil }

        guard
            let title = defaults.string(forKey: Keys.lastPostTitle),
            let date = defaults.object(forKey: Keys.lastPostDate) as? Date,
            let postId = defaults.string(forKey: Keys.lastPostId),
            !title.isEmpty,
            !postId.isEmpty
        else {
            return nil
        }

        return Snapshot(postId: postId, title: title, date: date)
    }
}
