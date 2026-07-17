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
            _ = save(feed: $0, in: ctx)
        }
        FeedDB.deduplicate(using: ctx)
    }

    @MainActor
    @discardableResult
    func save(feed: FeedDB) -> FeedDB {
        save(feed: feed, in: sharedModelContainer.mainContext)
    }

    /// Saves category-specific fetch results and reconciles stale category membership.
    ///
    /// Each group's synthetic category key (`NewsCategory.filterKey`) is added to matching posts
    /// as usual, then removed from any locally stored post whose `pubDate` falls inside the
    /// group's fetched date range but which the fetch no longer returned - covering the case
    /// where the server removed a post from that category (e.g. a de-highlighted post).
    @MainActor
    func save(feed groups: [(category: NewsCategory, posts: [FeedDB])]) {
        let ctx = sharedModelContainer.mainContext
        for group in groups {
            group.posts.forEach {
                _ = save(feed: $0, in: ctx)
            }
            reconcile(category: group.category, fetched: group.posts, in: ctx)
        }
        FeedDB.deduplicate(using: ctx)
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

    /// Categories whose membership is reconciled (added and removed) on each fetch.
    ///
    /// `.news` is excluded: it represents the unfiltered feed, so removal has no meaning there
    /// and its date window is the widest, making false-positive removals most likely.
    private static let reconcilableCategories: Set<NewsCategory> = [
        .highlights, .appletv, .reviews, .tutorials, .rumors
    ]

    @MainActor
    private func reconcile(category: NewsCategory, fetched: [FeedDB], in ctx: ModelContext) {
        guard Self.reconcilableCategories.contains(category),
              let windowStart = fetched.map(\.pubDate).min(),
              let windowEnd = fetched.map(\.pubDate).max() else { return }

        let key = category.filterKey
        let fetchedIds = Set(fetched.map(\.postId))
        let descriptor = FetchDescriptor<FeedDB>(
            predicate: #Predicate { $0.pubDate >= windowStart && $0.pubDate <= windowEnd }
        )

        guard let candidates = try? ctx.fetch(descriptor) else { return }
        let stale = candidates.filter { $0.categories.contains(key) && !fetchedIds.contains($0.postId) }
        guard !stale.isEmpty else { return }

        for post in stale {
            post.categories.removeAll { $0 == key }
            post.modifiedAt = Date()
        }
        try? ctx.save()
    }
}

// MARK: - Podcast -

extension Database {
    @MainActor
    func save(podcast: [PodcastDB]) {
        let ctx = sharedModelContainer.mainContext
        podcast.forEach {
            _ = save(podcast: $0, in: ctx)
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
