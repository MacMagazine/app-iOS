@testable import FeedLibrary
import Foundation
import MacMagazineLibrary
import StorageLibrary
import Testing

@Suite("StorageService Tests")
@MainActor
struct StorageServiceTests {

    // MARK: - Feed Save Tests

    @Test("save should insert new feed item")
    func saveInsertsNewFeedItem() {
        // Given
        let storage = Database(models: [FeedDB.self], inMemory: true)
        let feed = FeedDB(
            postId: "12345",
            title: "Test Post",
            subtitle: "Test Subtitle",
            pubDate: Date(),
            artworkURL: "https://example.com/image.jpg",
            link: "https://example.com/post",
            categories: ["Tech", "News"],
            excerpt: "This is a test excerpt",
            fullContent: "Full content here"
        )

        // When
        let saved = storage.save(feed: feed)

        // Then
        #expect(saved.postId == "12345")
        let fetched = storage.fetch(FeedDB.self)
        #expect(fetched.count == 1)
        #expect(fetched.first?.postId == "12345")
        #expect(fetched.first?.title == "Test Post")
    }

    @Test("save should update existing feed item")
    func saveUpdatesExistingFeedItem() {
        // Given
        let storage = Database(models: [FeedDB.self], inMemory: true)
        let original = FeedDB(
            postId: "12345",
            title: "Original Title",
            subtitle: "Original Subtitle",
            pubDate: Date(),
            artworkURL: "original.jpg",
            link: "original.com"
        )
        storage.save(feed: original)

        let updated = FeedDB(
            postId: "12345",
            title: "Updated Title",
            subtitle: "Updated Subtitle",
            pubDate: Date(),
            artworkURL: "updated.jpg",
            link: "updated.com"
        )

        // When
        storage.save(feed: updated)

        // Then
        let fetched = storage.fetch(FeedDB.self)
        #expect(fetched.count == 1)
        #expect(fetched.first?.title == "Updated Title")
        #expect(fetched.first?.subtitle == "Updated Subtitle")
    }

    @Test("save should update all feed properties")
    func saveUpdatesAllFeedProperties() {
        // Given
        let storage = Database(models: [FeedDB.self], inMemory: true)
        let original = FeedDB(postId: "123", title: "Old")
        storage.save(feed: original)

        let newDate = Date()
        let updated = FeedDB(
            postId: "123",
            title: "New Title",
            subtitle: "New Subtitle",
            pubDate: newDate,
            artworkURL: "new.jpg",
            link: "new.com",
            categories: ["New", "Categories"],
            excerpt: "New excerpt",
            fullContent: "New content"
        )

        // When
        storage.save(feed: updated)

        // Then
        let fetched = storage.fetch(FeedDB.self).first
        #expect(fetched?.title == "New Title")
        #expect(fetched?.subtitle == "New Subtitle")
        #expect(fetched?.artworkURL == "new.jpg")
        #expect(fetched?.link == "new.com")
        #expect(Set(fetched?.categories ?? []) == Set(["New", "Categories"]))
        #expect(fetched?.excerpt == "New excerpt")
        #expect(fetched?.fullContent == "New content")
    }

    @Test("save should handle array of feed items")
    func savesArrayOfFeedItems() {
        // Given
        let storage = Database(models: [FeedDB.self], inMemory: true)
        let feeds = [
            FeedDB(postId: "1", title: "Post 1"),
            FeedDB(postId: "2", title: "Post 2"),
            FeedDB(postId: "3", title: "Post 3")
        ]

        // When
        storage.save(feed: feeds)

        // Then
        let fetched = storage.fetch(FeedDB.self)
        #expect(fetched.count == 3)
        #expect(fetched.contains { $0.postId == "1" })
        #expect(fetched.contains { $0.postId == "2" })
        #expect(fetched.contains { $0.postId == "3" })
    }

    @Test("save should handle empty array of feed items")
    func savesEmptyArrayOfFeedItems() {
        // Given
        let storage = Database(models: [FeedDB.self], inMemory: true)
        let feeds: [FeedDB] = []

        // When
        storage.save(feed: feeds)

        // Then
        let fetched = storage.fetch(FeedDB.self)
        #expect(fetched.isEmpty)
    }

    @Test("save should handle duplicate feed items in array")
    func savesDuplicateFeedItemsInArray() {
        // Given
        let storage = Database(models: [FeedDB.self], inMemory: true)
        let feeds = [
            FeedDB(postId: "1", title: "First"),
            FeedDB(postId: "1", title: "Second")
        ]

        // When
        storage.save(feed: feeds)

        // Then
        let fetched = storage.fetch(FeedDB.self)
        #expect(fetched.count == 1)
        #expect(fetched.first?.title == "Second")
    }

    // MARK: - Podcast Save Tests

    @Test("save should insert new podcast item")
    func saveInsertsNewPodcastItem() {
        // Given
        let storage = Database(models: [PodcastDB.self], inMemory: true)
        let podcast = PodcastDB(
            postId: "67890",
            title: "Test Podcast",
            subtitle: "Podcast Subtitle",
            pubDate: Date(),
            artworkURL: "podcast.jpg",
            link: "podcast.com",
            podcastURL: "audio.mp3",
            podcastSize: 1024.5,
            duration: "45:30",
            podcastFrame: "frame",
            playable: true
        )

        // When
        let saved = storage.save(podcast: podcast)

        // Then
        #expect(saved.postId == "67890")
        let fetched = storage.fetch(PodcastDB.self)
        #expect(fetched.count == 1)
        #expect(fetched.first?.postId == "67890")
        #expect(fetched.first?.title == "Test Podcast")
        #expect(fetched.first?.podcastURL == "audio.mp3")
    }

    @Test("save should update existing podcast item")
    func saveUpdatesExistingPodcastItem() {
        // Given
        let storage = Database(models: [PodcastDB.self], inMemory: true)
        let original = PodcastDB(
            postId: "67890",
            title: "Original Podcast",
            podcastURL: "original.mp3",
            duration: "30:00"
        )
        storage.save(podcast: original)

        let updated = PodcastDB(
            postId: "67890",
            title: "Updated Podcast",
            podcastURL: "updated.mp3",
            duration: "45:00"
        )

        // When
        storage.save(podcast: updated)

        // Then
        let fetched = storage.fetch(PodcastDB.self)
        #expect(fetched.count == 1)
        #expect(fetched.first?.title == "Updated Podcast")
        #expect(fetched.first?.podcastURL == "updated.mp3")
        #expect(fetched.first?.duration == "45:00")
    }

    @Test("save should update all podcast properties")
    func saveUpdatesAllPodcastProperties() {
        // Given
        let storage = Database(models: [PodcastDB.self], inMemory: true)
        let original = PodcastDB(postId: "123", title: "Old")
        storage.save(podcast: original)

        let newDate = Date()
        let updated = PodcastDB(
            postId: "123",
            title: "New Title",
            subtitle: "New Subtitle",
            pubDate: newDate,
            artworkURL: "new.jpg",
            link: "new.com",
            podcastURL: "new.mp3",
            podcastSize: 2048.0,
            duration: "60:00",
            podcastFrame: "newframe",
            playable: true
        )

        // When
        storage.save(podcast: updated)

        // Then
        let fetched = storage.fetch(PodcastDB.self).first
        #expect(fetched?.title == "New Title")
        #expect(fetched?.subtitle == "New Subtitle")
        #expect(fetched?.artworkURL == "new.jpg")
        #expect(fetched?.link == "new.com")
        #expect(fetched?.podcastURL == "new.mp3")
        #expect(fetched?.podcastSize == 2048.0)
        #expect(fetched?.duration == "60:00")
        #expect(fetched?.podcastFrame == "newframe")
        #expect(fetched?.playable == true)
    }

    @Test("save should handle array of podcast items")
    func savesArrayOfPodcastItems() {
        // Given
        let storage = Database(models: [PodcastDB.self], inMemory: true)
        let podcasts = [
            PodcastDB(postId: "1", title: "Podcast 1"),
            PodcastDB(postId: "2", title: "Podcast 2"),
            PodcastDB(postId: "3", title: "Podcast 3")
        ]

        // When
        storage.save(podcast: podcasts)

        // Then
        let fetched = storage.fetch(PodcastDB.self)
        #expect(fetched.count == 3)
        #expect(fetched.contains { $0.postId == "1" })
        #expect(fetched.contains { $0.postId == "2" })
        #expect(fetched.contains { $0.postId == "3" })
    }

    @Test("save should handle empty array of podcast items")
    func savesEmptyArrayOfPodcastItems() {
        // Given
        let storage = Database(models: [PodcastDB.self], inMemory: true)
        let podcasts: [PodcastDB] = []

        // When
        storage.save(podcast: podcasts)

        // Then
        let fetched = storage.fetch(PodcastDB.self)
        #expect(fetched.isEmpty)
    }

    @Test("save should handle duplicate podcast items in array")
    func savesDuplicatePodcastItemsInArray() {
        // Given
        let storage = Database(models: [PodcastDB.self], inMemory: true)
        let podcasts = [
            PodcastDB(postId: "1", title: "First"),
            PodcastDB(postId: "1", title: "Second")
        ]

        // When
        storage.save(podcast: podcasts)

        // Then
        let fetched = storage.fetch(PodcastDB.self)
        #expect(fetched.count == 1)
        #expect(fetched.first?.title == "Second")
    }

    // MARK: - Integration Tests

    @Test("save should work with both feed and podcast models")
    func savesMultipleModelTypes() {
        // Given
        let storage = Database(models: [FeedDB.self, PodcastDB.self], inMemory: true)
        let feed = FeedDB(postId: "feed-1", title: "Feed Post")
        let podcast = PodcastDB(postId: "podcast-1", title: "Podcast Episode")

        // When
        storage.save(feed: feed)
        storage.save(podcast: podcast)

        // Then
        let fetchedFeeds = storage.fetch(FeedDB.self)
        let fetchedPodcasts = storage.fetch(PodcastDB.self)
        #expect(fetchedFeeds.count == 1)
        #expect(fetchedPodcasts.count == 1)
    }

    @Test("save should preserve favorite status on update for feed")
    func savePreservesFavoriteStatusForFeed() {
        let storage = Database(models: [FeedDB.self], inMemory: true)
        let original = FeedDB(postId: "123", title: "Original", favorite: true)
        storage.save(feed: original)

        let updated = FeedDB(postId: "123", title: "Updated", favorite: false)
        storage.save(feed: updated)

        let fetched = storage.fetch(FeedDB.self).first
        #expect(fetched?.title == "Updated")
        #expect(fetched?.favorite == true)
    }

    @Test("save should preserve read status on update for feed")
    func savePreservesReadStatusForFeed() {
        let storage = Database(models: [FeedDB.self], inMemory: true)
        let original = FeedDB(postId: "123", title: "Original")
        storage.save(feed: original)

        let postId = "123"
        let predicate = #Predicate<FeedDB> { $0.postId == postId }
        let persisted = storage.fetch(FeedDB.self, predicate: predicate).first
        persisted?.read = true
        try? storage.context.save()

        let updated = FeedDB(postId: "123", title: "Updated")
        storage.save(feed: updated)

        let fetched = storage.fetch(FeedDB.self).first
        #expect(fetched?.title == "Updated")
        #expect(fetched?.read == true)
    }

    @Test("save should merge categories instead of replacing for feed")
    func saveMergesCategoriesForFeed() {
        let storage = Database(models: [FeedDB.self], inMemory: true)
        let original = FeedDB(postId: "123", title: "Post", categories: ["Tech", "News"])
        storage.save(feed: original)

        let updated = FeedDB(postId: "123", title: "Post", categories: ["Reviews", "News"])
        storage.save(feed: updated)

        let fetched = storage.fetch(FeedDB.self).first
        let cats = Set(fetched?.categories ?? [])
        #expect(cats.contains("Tech"))
        #expect(cats.contains("News"))
        #expect(cats.contains("Reviews"))
    }

    // MARK: - Category Reconciliation Tests

    @Test("grouped save inserts a post carrying its fetched category key")
    func groupedSaveAddsCategoryKey() {
        let storage = Database(models: [FeedDB.self], inMemory: true)
        let post = FeedDB(postId: "1", title: "Rumor", pubDate: Date(), categories: [NewsCategory.rumors.filterKey])

        storage.save(feed: [(category: NewsCategory.rumors, posts: [post])])

        let fetched = storage.fetch(FeedDB.self).first
        #expect(fetched?.categories.contains(NewsCategory.rumors.filterKey) == true)
    }

    @Test("grouped save removes a stale category key for a post that dropped out of its date window")
    func groupedSaveRemovesStaleCategoryKey() {
        let storage = Database(models: [FeedDB.self], inMemory: true)
        let earlier = Date(timeIntervalSince1970: 900_000)
        let dehighlightedDate = Date(timeIntervalSince1970: 1_000_000)
        let later = Date(timeIntervalSince1970: 1_100_000)

        let dehighlighted = FeedDB(
            postId: "1",
            title: "No Longer Highlighted",
            pubDate: dehighlightedDate,
            categories: [NewsCategory.highlights.filterKey]
        )
        storage.save(feed: dehighlighted)

        let before = FeedDB(postId: "2", title: "Before", pubDate: earlier, categories: [NewsCategory.highlights.filterKey])
        let after = FeedDB(postId: "3", title: "After", pubDate: later, categories: [NewsCategory.highlights.filterKey])

        storage.save(feed: [(category: NewsCategory.highlights, posts: [before, after])])

        let predicate = #Predicate<FeedDB> { $0.postId == "1" }
        let fetched = storage.fetch(FeedDB.self, predicate: predicate).first
        #expect(fetched?.categories.contains(NewsCategory.highlights.filterKey) == false)
    }

    @Test("grouped save never touches a sibling category's key while reconciling")
    func groupedSavePreservesSiblingCategoryKey() {
        let storage = Database(models: [FeedDB.self], inMemory: true)
        let date = Date(timeIntervalSince1970: 1_000_000)

        let multiCategory = FeedDB(
            postId: "1",
            title: "Review And Rumor",
            pubDate: date,
            categories: [NewsCategory.reviews.filterKey, NewsCategory.rumors.filterKey]
        )
        storage.save(feed: multiCategory)

        let otherReview = FeedDB(postId: "2", title: "Other Review", pubDate: date, categories: [NewsCategory.reviews.filterKey])
        storage.save(feed: [(category: NewsCategory.reviews, posts: [otherReview])])

        let predicate = #Predicate<FeedDB> { $0.postId == "1" }
        let fetched = storage.fetch(FeedDB.self, predicate: predicate).first
        #expect(fetched?.categories.contains(NewsCategory.reviews.filterKey) == false)
        #expect(fetched?.categories.contains(NewsCategory.rumors.filterKey) == true)
    }

    @Test("grouped save skips reconciliation when the fetched category result is empty")
    func groupedSaveSkipsReconciliationForEmptyResult() {
        let storage = Database(models: [FeedDB.self], inMemory: true)
        let highlighted = FeedDB(
            postId: "1",
            title: "Highlight",
            pubDate: Date(),
            categories: [NewsCategory.highlights.filterKey]
        )
        storage.save(feed: highlighted)

        storage.save(feed: [(category: NewsCategory.highlights, posts: [])])

        let fetched = storage.fetch(FeedDB.self).first
        #expect(fetched?.categories.contains(NewsCategory.highlights.filterKey) == true)
    }

    @Test("grouped save leaves a category key untouched when the post falls outside the fetched date window")
    func groupedSavePreservesKeyOutsideDateWindow() {
        let storage = Database(models: [FeedDB.self], inMemory: true)
        let farInThePast = Date(timeIntervalSince1970: 0)
        let recent = Date(timeIntervalSince1970: 2_000_000)

        let oldHighlight = FeedDB(
            postId: "1",
            title: "Old Highlight",
            pubDate: farInThePast,
            categories: [NewsCategory.highlights.filterKey]
        )
        storage.save(feed: oldHighlight)

        let recentHighlight = FeedDB(postId: "2", title: "Recent Highlight", pubDate: recent, categories: [NewsCategory.highlights.filterKey])
        storage.save(feed: [(category: NewsCategory.highlights, posts: [recentHighlight])])

        let predicate = #Predicate<FeedDB> { $0.postId == "1" }
        let fetched = storage.fetch(FeedDB.self, predicate: predicate).first
        #expect(fetched?.categories.contains(NewsCategory.highlights.filterKey) == true)
    }

    @Test("grouped save does not reconcile the news category")
    func groupedSaveDoesNotReconcileNewsCategory() {
        let storage = Database(models: [FeedDB.self], inMemory: true)
        let date = Date(timeIntervalSince1970: 1_000_000)

        let post = FeedDB(
            postId: "1",
            title: "Old News Marker",
            pubDate: date,
            categories: [NewsCategory.news.filterKey]
        )
        storage.save(feed: post)

        let otherPost = FeedDB(postId: "2", title: "Other Post", pubDate: date, categories: [NewsCategory.news.filterKey])
        storage.save(feed: [(category: NewsCategory.news, posts: [otherPost])])

        let predicate = #Predicate<FeedDB> { $0.postId == "1" }
        let fetched = storage.fetch(FeedDB.self, predicate: predicate).first
        #expect(fetched?.categories.contains(NewsCategory.news.filterKey) == true)
    }

    @Test("save should preserve favorite status on update for podcast")
    func savePreservesFavoriteStatusForPodcast() {
        let storage = Database(models: [PodcastDB.self], inMemory: true)
        let original = PodcastDB(postId: "123", title: "Original", favorite: true)
        storage.save(podcast: original)

        let updated = PodcastDB(postId: "123", title: "Updated", favorite: false)
        storage.save(podcast: updated)

        let fetched = storage.fetch(PodcastDB.self).first
        #expect(fetched?.title == "Updated")
        #expect(fetched?.favorite == true)
    }

    @Test("save should preserve playback position on update for podcast")
    func savePreservesPlaybackPositionForPodcast() {
        let storage = Database(models: [PodcastDB.self], inMemory: true)
        let original = PodcastDB(postId: "123", title: "Original", current: 345.67)
        storage.save(podcast: original)

        let updated = PodcastDB(postId: "123", title: "Updated", current: 0.0)
        storage.save(podcast: updated)

        let fetched = storage.fetch(PodcastDB.self).first
        #expect(fetched?.title == "Updated")
        #expect(fetched?.current == 345.67)
    }
}
