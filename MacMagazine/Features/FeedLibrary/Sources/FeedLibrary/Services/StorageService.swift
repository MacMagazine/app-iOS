import Foundation
import MacMagazineLibrary
import StorageLibrary
import SwiftData

// MARK: - Feed -

extension Database {
    @MainActor
    func save(feed: [FeedDB]) {
        let ctx = sharedModelContainer.mainContext
        feed.forEach {
            save(feed: $0, in: ctx)
        }
        FeedDB.deduplicate(using: ctx)
        FeedDB.notRead(using: ctx)
    }

    @MainActor
    @discardableResult
    func save(feed: FeedDB) -> FeedDB {
        save(feed: feed, in: sharedModelContainer.mainContext)
    }

    @MainActor
    private func save(feed: FeedDB, in ctx: ModelContext) -> FeedDB {
        let postId = feed.postId
        let predicate = #Predicate<FeedDB> { $0.postId == postId }
        let descriptor = FetchDescriptor(predicate: predicate)

        if let existing = (try? ctx.fetch(descriptor))?.first {
            existing.title = feed.title
            existing.subtitle = feed.subtitle
            existing.pubDate = feed.pubDate
            existing.author = feed.author
            existing.artworkURL = feed.artworkURL
            existing.link = feed.link
            existing.categories = Array(Set(existing.categories + feed.categories))
            existing.excerpt = feed.excerpt
            existing.fullContent = feed.fullContent
        } else {
            ctx.insert(feed)
        }

        try? ctx.save()
        return feed
    }
}

// MARK: - Podcast -

extension Database {
    @MainActor
    func save(podcast: [PodcastDB]) {
        let ctx = sharedModelContainer.mainContext
        podcast.forEach {
            save(podcast: $0, in: ctx)
        }
        PodcastDB.deduplicate(using: ctx)
    }

    @MainActor
    @discardableResult
    func save(podcast: PodcastDB) -> PodcastDB {
        save(podcast: podcast, in: sharedModelContainer.mainContext)
    }

    @MainActor
    private func save(podcast: PodcastDB, in ctx: ModelContext) -> PodcastDB {
        let postId = podcast.postId
        let predicate = #Predicate<PodcastDB> { $0.postId == postId }
        let descriptor = FetchDescriptor(predicate: predicate)

        if let existing = (try? ctx.fetch(descriptor))?.first {
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
            ctx.insert(podcast)
        }

        try? ctx.save()
        return podcast
    }
}
