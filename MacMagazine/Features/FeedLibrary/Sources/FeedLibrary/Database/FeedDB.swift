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
    public var favoriteModifiedAt: Date = Date.distantPast
    public var read: Bool = false
    public var readModifiedAt: Date = Date.distantPast
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
        favoriteModifiedAt: Date = Date.distantPast,
        ead: Bool = false,
        readModifiedAt: Date = Date.distantPast,
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
        self.favoriteModifiedAt = favoriteModifiedAt
        self.read = read
        self.readModifiedAt = readModifiedAt
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

extension FeedDB: ModelFavoritable {
    public static func deleteNonFavorites(using context: ModelContext?) {
        let descriptor = FetchDescriptor(predicate: #Predicate<FeedDB> { !$0.favorite })
        guard let context,
              let data = try? context.fetch(descriptor) else { return }
        data.forEach { context.delete($0) }
        try? context.save()
    }

    public func toggleFavorite() {
        favorite.toggle()
        favoriteModifiedAt = Date()
        modifiedAt = Date()
    }
}

extension FeedDB: ModelReadable {
    public static func markAllAsRead(using context: ModelContext?) {
        let descriptor = FetchDescriptor<FeedDB>(predicate: #Predicate<FeedDB> { !$0.read })
        guard let context,
              let data = try? context.fetch(descriptor) else { return }
        for post in data {
            post.markAsRead()
        }
        try? context.save()
    }

    public func toggleRead() {
        read.toggle()
        readModifiedAt = Date()
        modifiedAt = Date()
    }

    public func markAsRead() {
        read = true
        readModifiedAt = Date()
        modifiedAt = Date()
    }
}

extension FeedDB: ModelPrioritizable {}

extension FeedDB: ModelDuplicable {
    public static func deduplicate(using context: ModelContext?) {
        let descriptor = FetchDescriptor<FeedDB>(sortBy: [SortDescriptor(\FeedDB.pubDate, order: .reverse)])
        guard let context,
              let data = try? context.fetch(descriptor) else { return }

        for group in Dictionary(grouping: data, by: \.postId).values where group.count > 1 {
            guard let survivor = group.max(by: { $0.modifiedAt < $1.modifiedAt }) else { continue }

            if let latestFavorite = FeedDB.latest(in: group, value: { $0.favorite }, modifiedAt: { $0.favoriteModifiedAt }) {
                survivor.favorite = latestFavorite.value
                survivor.favoriteModifiedAt = latestFavorite.modifiedAt
            }
            if let latestRead = FeedDB.latest(in: group, value: { $0.read }, modifiedAt: { $0.readModifiedAt }) {
                survivor.read = latestRead.value
                survivor.readModifiedAt = latestRead.modifiedAt
            }

            for record in group where record !== survivor {
                context.delete(record)
            }
        }

        try? context.save()
    }
}
