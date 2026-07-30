import AnalyticsLibrary
import Foundation
import MacMagazineLibrary
import MacMagazineUILibrary
import SwiftData
import YouTubeLibrary

public extension VideoDB {
    private var urlToShare: String {
        "https://www.youtube.com/watch?v=\(videoId)"
    }

    func toCardContent(
        using context: ModelContext?,
        analytics: AnalyticsManager?
    ) -> CardContent {
        let type = CardContentType.video(
            views: (Int(self.views) ?? 0).formatted(.number),
            likes: (Int(self.likes) ?? 0).formatted(.number),
            duration: self.duration.formattedYTDuration
        )
        return CardContent(
            type: type,
            analytics: analytics,
            title: self.title,
            pubDate: self.pubDate.toDate(),
            artworkUrl: self.artworkURL,
            urlToShare: self.urlToShare,
            favorite: self.favorite,
            favoriteAction: { [weak self] in
                guard let self, let context else { return }
                self.favorite.toggle()
                self.modifiedAt = Date()
                try? context.save()
                analytics?.track(.buttonTap(
                    buttonId: AnalyticsConstants.ButtonID.videoFavorite.id,
                    screen: type.screenName
                ))
            }
        )
    }
}

extension VideoDB: @retroactive ModelFavoritable {
    public static func deleteNonFavorites(using context: ModelContext?) {
        let descriptor = FetchDescriptor(predicate: #Predicate<VideoDB> { !$0.favorite })
        guard let context,
              let data = try? context.fetch(descriptor) else { return }
        data.forEach { context.delete($0) }
        try? context.save()
    }
}

extension VideoDB: @retroactive ModelSafeguardable {
    public func copied() -> VideoDB {
        VideoDB(artworkURL: artworkURL,
                current: current,
                duration: duration,
                favorite: favorite,
                likes: likes,
                pubDate: pubDate,
                title: title,
                videoId: videoId,
                views: views,
                modifiedAt: modifiedAt)
    }

    public static func snapshot(from source: ModelContext?, into destination: ModelContext?) throws {
        guard let source, let destination else { return }
        let data = try source.fetch(FetchDescriptor<VideoDB>())
        data.forEach { destination.insert($0.copied()) }
        try destination.save()
    }

    public static func restore(from snapshot: ModelContext?, into main: ModelContext?) throws {
        guard let snapshot, let main else { return }
        let saved = try snapshot.fetch(FetchDescriptor<VideoDB>())
        let existing = try main.fetch(FetchDescriptor<VideoDB>())

        let existingByVideoId = Dictionary(grouping: existing, by: \.videoId)
        for record in saved {
            guard let rows = existingByVideoId[record.videoId] else {
                main.insert(record.copied())
                continue
            }
            rows.forEach { $0.merge(from: record) }
        }

        try main.save()
    }

    /// `VideoDB` is an external model with no per-field authority timestamps, so the merge cannot
    /// tell an explicit un-favorite apart from a blank sync-created row. It therefore only ever
    /// adds state: favorite is OR-ed and the furthest playback position wins.
    private func merge(from record: VideoDB) {
        favorite = favorite || record.favorite
        current = max(current, record.current)
    }
}

extension VideoDB: @retroactive ModelDuplicable {
    public static func deduplicate(using context: ModelContext?) {
        let descriptor = FetchDescriptor<VideoDB>()
        guard let context,
              let data = try? context.fetch(descriptor) else { return }

        let recordsToDelete = Dictionary(grouping: data, by: \.videoId)
            .values
            .flatMap { $0.sorted { $0.modifiedAt > $1.modifiedAt }.dropFirst() }

        recordsToDelete.forEach { context.delete($0) }
        try? context.save()
    }
}
