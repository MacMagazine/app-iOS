import Foundation
import StorageLibrary
import SwiftData

extension Database {
    @MainActor
    func save(podcast: [PodcastDB]) {
        podcast.forEach {
            _ = save(podcast: $0)
        }
    }

    @MainActor
    func save(podcast: PodcastDB) -> PodcastDB {
        let postId = podcast.postId
        let predicate = #Predicate<PodcastDB> { $0.postId == postId }

        if let existing = self.fetch(PodcastDB.self, predicate: predicate).first {
            // Update existing
            existing.title = podcast.title
            existing.subtitle = podcast.subtitle
            existing.pubDate = podcast.pubDate
            existing.artworkURL = podcast.artworkURL
            existing.podcastURL = podcast.podcastURL
            existing.podcastSize = podcast.podcastSize
            existing.duration = podcast.duration
            existing.podcastFrame = podcast.podcastFrame
            existing.favorite = podcast.favorite
            existing.playable = podcast.playable

        } else {
            // Insert new
            context.insert(podcast)
        }

        try? context.save()
        return podcast
    }
}
