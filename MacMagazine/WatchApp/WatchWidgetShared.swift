import Foundation

enum MacMagazineWidgetSharedStore {

    static let appGroupID = "group.com.brit.beta.macmagazine"

    private enum Keys {
        static let postId = "macmagazine.widget.post.id"
        static let postTitle = "macmagazine.widget.post.title"
        static let postDate = "macmagazine.widget.post.date"
    }

    struct LastPost: Equatable {
        let id: String
        let title: String
        let date: Date
    }

    static func write(post: LastPost) {
        guard let defaults = UserDefaults(suiteName: appGroupID) else { return }

        defaults.set(post.id, forKey: Keys.postId)
        defaults.set(post.title, forKey: Keys.postTitle)
        defaults.set(post.date, forKey: Keys.postDate)
    }

    static func readPost() -> LastPost? {
        guard let defaults = UserDefaults(suiteName: appGroupID) else { return nil }

        guard
            let id = defaults.string(forKey: Keys.postId),
            let title = defaults.string(forKey: Keys.postTitle),
            let date = defaults.object(forKey: Keys.postDate) as? Date,
            !id.isEmpty,
            !title.isEmpty
        else {
            return nil
        }

        return LastPost(id: id, title: title, date: date)
    }
}
