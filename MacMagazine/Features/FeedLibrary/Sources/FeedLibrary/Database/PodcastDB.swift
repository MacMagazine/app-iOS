import Foundation
import MacMagazineLibrary
import SwiftData

@Model
public final class PodcastDB {
    public var postId: String = ""
    public var title: String = ""
    public var subtitle: String = ""
    public var pubDate: Date = Date()
    public var artworkURL: String = ""
    public var link: String = ""
    public var podcastURL: String = ""
    public var podcastSize: Double = 0
    public var duration: String = ""
    public var podcastFrame: String = ""
    public var favorite: Bool = false
    public var favoriteModifiedAt: Date = Date.distantPast
    public var playable: Bool = false
    public var current: Double = 0.0
    public var progressModifiedAt: Date = Date.distantPast
    public var modifiedAt: Date = Date()

    public init(
        postId: String = "",
        title: String = "",
        subtitle: String = "",
        pubDate: Date = Date(),
        artworkURL: String = "",
        link: String = "",
        podcastURL: String = "",
        podcastSize: Double = 0,
        duration: String = "",
        podcastFrame: String = "",
        favorite: Bool = false,
        favoriteModifiedAt: Date = Date.distantPast,
        playable: Bool = false,
        current: Double = 0.0,
        progressModifiedAt: Date = Date.distantPast,
        modifiedAt: Date = Date()
    ) {
        self.postId = postId
        self.title = title
        self.subtitle = subtitle
        self.pubDate = pubDate
        self.artworkURL = artworkURL
        self.link = link
        self.podcastURL = podcastURL
        self.podcastSize = podcastSize
        self.duration = duration
        self.podcastFrame = podcastFrame
        self.favorite = favorite
        self.favoriteModifiedAt = favoriteModifiedAt
        self.playable = playable
        self.current = current
        self.progressModifiedAt = progressModifiedAt
        self.modifiedAt = modifiedAt
    }
}

extension PodcastDB: ModelFavoritable {
    public static func deleteNonFavorites(using context: ModelContext?) {
        let descriptor = FetchDescriptor(predicate: #Predicate<PodcastDB> { !$0.favorite })
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

extension PodcastDB {
    /// Sets `current` and stamps `progressModifiedAt`, so `deduplicate()` can tell this
    /// explicit action apart from a blank sync-created duplicate.
    public func updateProgress(_ current: Double) {
        self.current = current
        progressModifiedAt = Date()
        modifiedAt = Date()
    }
}

extension PodcastDB: ModelPrioritizable {}

extension PodcastDB: ModelDuplicable {
    public static func deduplicate(using context: ModelContext?) {
        let descriptor = FetchDescriptor<PodcastDB>()
        guard let context,
              let data = try? context.fetch(descriptor) else { return }

        PodcastDB.resolveDuplicates(in: data, postId: \.postId, modifiedAt: \.modifiedAt) { survivor, group in
            if let latestFavorite = PodcastDB.latest(
                in: group, value: { $0.favorite }, modifiedAt: { $0.favoriteModifiedAt },
                preferOnTie: { candidate, _ in candidate }
            ) {
                survivor.favorite = latestFavorite.value
                survivor.favoriteModifiedAt = latestFavorite.modifiedAt
            }
            if let latestProgress = PodcastDB.latest(
                in: group, value: { $0.current }, modifiedAt: { $0.progressModifiedAt },
                preferOnTie: { candidate, current in candidate > current }
            ) {
                survivor.current = latestProgress.value
                survivor.progressModifiedAt = latestProgress.modifiedAt
            }
        } delete: { context.delete($0) }

        try? context.save()
    }
}
