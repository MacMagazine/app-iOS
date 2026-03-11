import Foundation
import MacMagazineLibrary
import SwiftData
import WidgetKit

@Model
public final class FeedDB {
    public var postId: String = ""
    public var title: String = ""
    public var subtitle: String = ""
    public var pubDate: Date = Date()
    public var author: String?
    public var artworkURL: String = ""
    public var link: String = ""
    public var categories: [String] = []
    public var excerpt: String = ""
    public var fullContent: String = ""
    public var favorite: Bool = false
    public var read: Bool = false
    public var modifiedAt: Date = Date()

    public init(
        postId: String = "",
        title: String = "",
        subtitle: String = "",
        pubDate: Date = Date(),
        author: String? = nil,
        artworkURL: String = "",
        link: String = "",
        categories: [String] = [],
        excerpt: String = "",
        fullContent: String = "",
        favorite: Bool = false,
        ead: Bool = false,
        modifiedAt: Date = Date()
    ) {
        self.postId = postId
        self.title = title
        self.subtitle = subtitle
        self.pubDate = pubDate
        self.author = author
        self.artworkURL = artworkURL
        self.link = link
        self.categories = categories
        self.excerpt = excerpt
        self.fullContent = fullContent
        self.favorite = favorite
        self.read = read
        self.modifiedAt = modifiedAt
    }
}

extension FeedDB {
    public static func lastSeen(using context: ModelContext?) -> FeedDB? {
        let descriptor = FetchDescriptor<FeedDB>(predicate: #Predicate<FeedDB> { $0.read },
                                                 sortBy: [SortDescriptor(\FeedDB.modifiedAt, order: .reverse)])
        guard let context,
              let data = try? context.fetch(descriptor) else { return nil }
        return data.first
    }

    public static func mostRecent(using context: ModelContext?) -> FeedDB? {
        let descriptor = FetchDescriptor<FeedDB>(sortBy: [SortDescriptor(\FeedDB.pubDate, order: .reverse)])
        guard let context,
              let data = try? context.fetch(descriptor) else { return nil }
        return data.first
    }
}

extension FeedDB {
    public static func notRead() -> Int {
        let sharedDefaults = UserDefaults(suiteName: "group.com.brit.macmagazine.data")
        return sharedDefaults?.integer(forKey: "unreadCount") ?? 0
    }

    public static func notRead(using context: ModelContext?) {
        let descriptor = FetchDescriptor(predicate: #Predicate<FeedDB> { !$0.read })
        guard let context,
              let data = try? context.fetch(descriptor) else { return }

        let sharedDefaults = UserDefaults(suiteName: "group.com.brit.macmagazine.data")
        sharedDefaults?.set(data.count, forKey: "unreadCount")

        WidgetCenter.shared.reloadAllTimelines()
    }
}

extension FeedDB: ModelFavoritable {
    public static func deleteNonFavorites(using context: ModelContext?) {
        let descriptor = FetchDescriptor(predicate: #Predicate<FeedDB> { !$0.favorite })
        guard let context,
              let data = try? context.fetch(descriptor) else { return }
        data.forEach { context.delete($0) }
        try? context.save()
    }
}

extension FeedDB: ModelDuplicable {
    public static func deduplicate(using context: ModelContext?) {
        let descriptor = FetchDescriptor<FeedDB>(sortBy: [SortDescriptor(\FeedDB.pubDate, order: .reverse)])
        guard let context,
              let data = try? context.fetch(descriptor) else { return }

        let recordsToDelete = Dictionary(grouping: data, by: \.postId)
            .values
            .flatMap { $0.sorted { $0.modifiedAt > $1.modifiedAt }.dropFirst() }

        recordsToDelete.forEach { context.delete($0) }
        try? context.save()
    }
}

extension FeedDB: ModelReadable {
    public static func maskAsRead(using context: ModelContext?) {
        let descriptor = FetchDescriptor(predicate: #Predicate<FeedDB> { !$0.read })
        guard let context,
              let data = try? context.fetch(descriptor) else { return }
        data.forEach { $0.read = true }
        try? context.save()
        notRead(using: context)
    }
}
