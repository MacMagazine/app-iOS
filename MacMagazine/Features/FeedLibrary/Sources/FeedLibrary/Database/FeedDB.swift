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
        read: Bool = false,
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

    /// Flips `favorite` and stamps `favoriteModifiedAt`, so `deduplicate()` can tell this
    /// explicit action apart from a blank sync-created duplicate.
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

    /// Flips `read` and stamps `readModifiedAt`, so `deduplicate()` can tell this explicit
    /// action apart from a blank sync-created duplicate.
    public func toggleRead() {
        read.toggle()
        readModifiedAt = Date()
        modifiedAt = Date()
    }

    /// Sets `read` to `true` and stamps `readModifiedAt`, so `deduplicate()` can tell this
    /// explicit action apart from a blank sync-created duplicate.
    public func markAsRead() {
        read = true
        readModifiedAt = Date()
        modifiedAt = Date()
    }
}

extension FeedDB: ModelSafeguardable {
    public func copied() -> FeedDB {
        FeedDB(postId: postId,
               title: title,
               subtitle: subtitle,
               pubDate: pubDate,
               author: author,
               artworkURL: artworkURL,
               link: link,
               categories: categories,
               excerpt: excerpt,
               fullContent: fullContent,
               favorite: favorite,
               favoriteModifiedAt: favoriteModifiedAt,
               read: read,
               readModifiedAt: readModifiedAt,
               modifiedAt: modifiedAt)
    }

    public static func snapshot(from source: ModelContext?, into destination: ModelContext?) {
        guard let source,
              let destination,
              let data = try? source.fetch(FetchDescriptor<FeedDB>()) else { return }
        data.forEach { destination.insert($0.copied()) }
        try? destination.save()
    }

    public static func restore(from snapshot: ModelContext?, into main: ModelContext?) {
        guard let snapshot,
              let main,
              let saved = try? snapshot.fetch(FetchDescriptor<FeedDB>()),
              let existing = try? main.fetch(FetchDescriptor<FeedDB>()) else { return }

        let existingByPostId = Dictionary(grouping: existing, by: \.postId)
        for record in saved {
            guard let rows = existingByPostId[record.postId] else {
                main.insert(record.copied())
                continue
            }
            rows.forEach { $0.merge(from: record) }
        }

        try? main.save()
    }

    /// Applies the snapshot's `favorite`/`read` only when its own authority timestamp is strictly
    /// newer, and carries that original timestamp over instead of stamping `Date()`: a restore is
    /// not a user action, so stamping now would let restored state outrank a genuinely newer value
    /// that iCloud delivers afterwards. Same authority rule `deduplicate()` applies.
    private func merge(from record: FeedDB) {
        if record.favoriteModifiedAt > favoriteModifiedAt {
            favorite = record.favorite
            favoriteModifiedAt = record.favoriteModifiedAt
        }
        if record.readModifiedAt > readModifiedAt {
            read = record.read
            readModifiedAt = record.readModifiedAt
        }
    }
}

extension FeedDB: ModelPrioritizable {}

extension FeedDB: ModelDuplicable {
    public static func deduplicate(using context: ModelContext?) {
        let descriptor = FetchDescriptor<FeedDB>(sortBy: [SortDescriptor(\FeedDB.pubDate, order: .reverse)])
        guard let context,
              let data = try? context.fetch(descriptor) else { return }

        FeedDB.resolveDuplicates(in: data, postId: \.postId, modifiedAt: \.modifiedAt) { survivor, group in
            if let latestFavorite = FeedDB.latest(
                in: group, value: { $0.favorite }, modifiedAt: { $0.favoriteModifiedAt },
                preferOnTie: { candidate, _ in candidate }
            ) {
                survivor.favorite = latestFavorite.value
                survivor.favoriteModifiedAt = latestFavorite.modifiedAt
            }
            if let latestRead = FeedDB.latest(
                in: group, value: { $0.read }, modifiedAt: { $0.readModifiedAt },
                preferOnTie: { candidate, _ in candidate }
            ) {
                survivor.read = latestRead.value
                survivor.readModifiedAt = latestRead.modifiedAt
            }
        } delete: { context.delete($0) }

        try? context.save()
    }
}
