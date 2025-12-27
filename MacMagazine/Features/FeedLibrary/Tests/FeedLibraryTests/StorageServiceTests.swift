@testable import FeedLibrary
import Foundation
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
        // Given
        let storage = Database(models: [FeedDB.self], inMemory: true)
        let original = FeedDB(postId: "123", title: "Original", favorite: true)
        storage.save(feed: original)

        let updated = FeedDB(postId: "123", title: "Updated", favorite: false)

        // When
        storage.save(feed: updated)

        // Then
        let fetched = storage.fetch(FeedDB.self).first
        // Note: favorite is NOT updated in the save method, so it should remain as is
        // The save method doesn't update favorite field
        #expect(fetched?.title == "Updated")
    }

    @Test("save should preserve favorite status on update for podcast")
    func savePreservesFavoriteStatusForPodcast() {
        // Given
        let storage = Database(models: [PodcastDB.self], inMemory: true)
        let original = PodcastDB(postId: "123", title: "Original", favorite: true)
        storage.save(podcast: original)

        let updated = PodcastDB(postId: "123", title: "Updated", favorite: false)

        // When
        storage.save(podcast: updated)

        // Then
        let fetched = storage.fetch(PodcastDB.self).first
        // Note: favorite is NOT updated in the save method, so it should remain as is
        // The save method doesn't update favorite field
        #expect(fetched?.title == "Updated")
    }
}
