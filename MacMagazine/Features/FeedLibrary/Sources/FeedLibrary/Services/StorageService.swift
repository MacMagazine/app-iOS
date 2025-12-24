import Foundation
import MacMagazineLibrary
import StorageLibrary
import SwiftData

// MARK: - Feed -

extension Database {
    @MainActor
    func save(feed: [FeedDB]) {
        feed.forEach {
            save(feed: $0)
        }
    }

    @MainActor
    @discardableResult
    func save(feed: FeedDB) -> FeedDB {
        let postId = feed.postId
        let predicate = #Predicate<FeedDB> { $0.postId == postId }

        if let existing = self.fetch(FeedDB.self, predicate: predicate).first {
            // Update existing
            existing.title = feed.title
            existing.subtitle = feed.subtitle
            existing.pubDate = feed.pubDate
            existing.artworkURL = feed.artworkURL
            existing.link = feed.link
            existing.categories = Array(Set(existing.categories + feed.categories))
            existing.excerpt = feed.excerpt
            existing.fullContent = feed.fullContent
        } else {
            // Insert new
            context.insert(feed)
        }

        try? context.save()
        return feed
    }
}

// MARK: - Podcast -

extension Database {
    @MainActor
    func save(podcast: [PodcastDB]) {
        podcast.forEach {
            save(podcast: $0)
        }
    }

    @MainActor
    @discardableResult
    func save(podcast: PodcastDB) -> PodcastDB {
        let postId = podcast.postId
        let predicate = #Predicate<PodcastDB> { $0.postId == postId }

        if let existing = self.fetch(PodcastDB.self, predicate: predicate).first {
            // Update existing
            existing.title = podcast.title
            existing.subtitle = podcast.subtitle
            existing.pubDate = podcast.pubDate
            existing.artworkURL = podcast.artworkURL
            existing.link = podcast.link
            existing.podcastURL = podcast.podcastURL
            existing.podcastSize = podcast.podcastSize
            existing.duration = podcast.duration
            existing.podcastFrame = podcast.podcastFrame
            existing.playable = podcast.playable

        } else {
            // Insert new
            context.insert(podcast)
        }

        try? context.save()
        return podcast
    }
}
