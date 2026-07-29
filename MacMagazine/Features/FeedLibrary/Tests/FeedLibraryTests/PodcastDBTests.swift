@testable import FeedLibrary
import Foundation
import StorageLibrary
import SwiftData
import Testing

@Suite("PodcastDB Tests")
@MainActor
struct PodcastDBTests {

    // MARK: - Initialization Tests

    @Test("PodcastDB should initialize with all properties")
    func initializationWithAllProperties() {
        // Given
        let postId = "67890"
        let title = "Test Podcast"
        let subtitle = "Podcast Subtitle"
        let pubDate = Date()
        let artworkURL = "https://example.com/podcast.jpg"
        let link = "https://example.com/podcast"
        let podcastURL = "https://example.com/audio.mp3"
        let podcastSize = 1024.5
        let duration = "45:30"
        let podcastFrame = "frame-data"
        let favorite = true
        let playable = true
        let current = 123.45

        // When
        let podcast = PodcastDB(
            postId: postId,
            title: title,
            subtitle: subtitle,
            pubDate: pubDate,
            artworkURL: artworkURL,
            link: link,
            podcastURL: podcastURL,
            podcastSize: podcastSize,
            duration: duration,
            podcastFrame: podcastFrame,
            favorite: favorite,
            playable: playable,
            current: current
        )

        // Then
        #expect(podcast.postId == postId)
        #expect(podcast.title == title)
        #expect(podcast.subtitle == subtitle)
        #expect(podcast.pubDate == pubDate)
        #expect(podcast.artworkURL == artworkURL)
        #expect(podcast.link == link)
        #expect(podcast.podcastURL == podcastURL)
        #expect(podcast.podcastSize == podcastSize)
        #expect(podcast.duration == duration)
        #expect(podcast.podcastFrame == podcastFrame)
        #expect(podcast.favorite == favorite)
        #expect(podcast.playable == playable)
        #expect(podcast.current == current)
    }

    @Test("PodcastDB should initialize with default values")
    func initializationWithDefaults() {
        // When
        let podcast = PodcastDB()

        // Then
        #expect(podcast.postId.isEmpty)
        #expect(podcast.title.isEmpty)
        #expect(podcast.subtitle.isEmpty)
        #expect(podcast.artworkURL.isEmpty)
        #expect(podcast.link.isEmpty)
        #expect(podcast.podcastURL.isEmpty)
        #expect(podcast.podcastSize == 0)
        #expect(podcast.duration.isEmpty)
        #expect(podcast.podcastFrame.isEmpty)
        #expect(podcast.favorite == false)
        #expect(podcast.playable == false)
        #expect(podcast.current == 0.0)
    }

    @Test("PodcastDB should handle empty strings")
    func initializationWithEmptyStrings() {
        // When
        let podcast = PodcastDB(
            postId: "",
            title: "",
            subtitle: "",
            artworkURL: "",
            link: "",
            podcastURL: "",
            duration: "",
            podcastFrame: ""
        )

        // Then
        #expect(podcast.postId.isEmpty)
        #expect(podcast.title.isEmpty)
        #expect(podcast.subtitle.isEmpty)
        #expect(podcast.artworkURL.isEmpty)
        #expect(podcast.link.isEmpty)
        #expect(podcast.podcastURL.isEmpty)
        #expect(podcast.duration.isEmpty)
        #expect(podcast.podcastFrame.isEmpty)
    }

    @Test("PodcastDB should handle zero and negative sizes")
    func initializationWithZeroAndNegativeSizes() {
        // When
        let zeroPodcast = PodcastDB(podcastSize: 0)
        let negativePodcast = PodcastDB(podcastSize: -100)

        // Then
        #expect(zeroPodcast.podcastSize == 0)
        #expect(negativePodcast.podcastSize == -100)
    }

    @Test("PodcastDB should handle large podcast sizes")
    func initializationWithLargeSizes() {
        // Given
        let largeSize = 999999999.99

        // When
        let podcast = PodcastDB(podcastSize: largeSize)

        // Then
        #expect(podcast.podcastSize == largeSize)
    }

    // MARK: - Property Tests

    @Test("PodcastDB properties should be mutable")
    func propertiesAreMutable() {
        // Given
        let podcast = PodcastDB()

        // When
        podcast.postId = "123"
        podcast.title = "New Title"
        podcast.favorite = true
        podcast.playable = true
        podcast.current = 456.78

        // Then
        #expect(podcast.postId == "123")
        #expect(podcast.title == "New Title")
        #expect(podcast.favorite == true)
        #expect(podcast.playable == true)
        #expect(podcast.current == 456.78)
    }

    @Test("PodcastDB should handle special characters in strings")
    func handlesSpecialCharacters() {
        // Given
        let specialTitle = "Podcast & <Episode> \"with\" 'quotes'"

        // When
        let podcast = PodcastDB(title: specialTitle)

        // Then
        #expect(podcast.title == specialTitle)
    }

    @Test("PodcastDB should handle unicode characters")
    func handlesUnicodeCharacters() {
        // Given
        let unicodeTitle = "Podcast: Açúcar e Café ☕"

        // When
        let podcast = PodcastDB(title: unicodeTitle)

        // Then
        #expect(podcast.title == unicodeTitle)
    }

    @Test("PodcastDB should handle various duration formats")
    func handlesVariousDurationFormats() {
        // When
        let shortDuration = PodcastDB(duration: "5:30")
        let longDuration = PodcastDB(duration: "1:25:45")
        let withSeconds = PodcastDB(duration: "45:30:15")

        // Then
        #expect(shortDuration.duration == "5:30")
        #expect(longDuration.duration == "1:25:45")
        #expect(withSeconds.duration == "45:30:15")
    }

    // MARK: - SwiftData Model Tests

    @Test("PodcastDB should be persistable in SwiftData")
    func isPersistableInSwiftData() {
        // Given
        let storage = Database(models: [PodcastDB.self], inMemory: true)
        let podcast = PodcastDB(
            postId: "test-456",
            title: "Persistable Podcast",
            playable: true
        )

        // When
        storage.context.insert(podcast)
        try? storage.context.save()

        // Then
        let fetched = storage.fetch(PodcastDB.self)
        #expect(fetched.count == 1)
        #expect(fetched.first?.postId == "test-456")
        #expect(fetched.first?.title == "Persistable Podcast")
        #expect(fetched.first?.playable == true)
    }

    @Test("PodcastDB should persist all properties correctly")
    func persistsAllPropertiesCorrectly() {
        // Given
        let storage = Database(models: [PodcastDB.self], inMemory: true)
        let pubDate = Date()
        let podcast = PodcastDB(
            postId: "123",
            title: "Title",
            subtitle: "Subtitle",
            pubDate: pubDate,
            artworkURL: "artwork.jpg",
            link: "link.com",
            podcastURL: "audio.mp3",
            podcastSize: 2048.5,
            duration: "60:00",
            podcastFrame: "frame",
            favorite: true,
            playable: true,
            current: 30.5
        )

        // When
        storage.context.insert(podcast)
        try? storage.context.save()

        // Then
        let fetched = storage.fetch(PodcastDB.self).first
        #expect(fetched?.postId == "123")
        #expect(fetched?.title == "Title")
        #expect(fetched?.subtitle == "Subtitle")
        #expect(fetched?.artworkURL == "artwork.jpg")
        #expect(fetched?.link == "link.com")
        #expect(fetched?.podcastURL == "audio.mp3")
        #expect(fetched?.podcastSize == 2048.5)
        #expect(fetched?.duration == "60:00")
        #expect(fetched?.podcastFrame == "frame")
        #expect(fetched?.favorite == true)
        #expect(fetched?.playable == true)
        #expect(fetched?.current == 30.5)
    }

    // MARK: - ModelFavoritable Tests

    @Test("deleteNonFavorites should remove non-favorite podcasts")
    func deleteNonFavoritesRemovesNonFavorites() {
        // Given
        let storage = Database(models: [PodcastDB.self], inMemory: true)
        let favorite1 = PodcastDB(postId: "1", title: "Favorite 1", favorite: true)
        let favorite2 = PodcastDB(postId: "2", title: "Favorite 2", favorite: true)
        let nonFavorite1 = PodcastDB(postId: "3", title: "Non-Favorite 1", favorite: false)
        let nonFavorite2 = PodcastDB(postId: "4", title: "Non-Favorite 2", favorite: false)

        storage.context.insert(favorite1)
        storage.context.insert(favorite2)
        storage.context.insert(nonFavorite1)
        storage.context.insert(nonFavorite2)
        try? storage.context.save()

        // When
        PodcastDB.deleteNonFavorites(using: storage.context)

        // Then
        let remaining = storage.fetch(PodcastDB.self)
        #expect(remaining.count == 2)
        #expect(remaining.allSatisfy { $0.favorite == true })
        #expect(remaining.contains { $0.postId == "1" })
        #expect(remaining.contains { $0.postId == "2" })
    }

    @Test("deleteNonFavorites should preserve all favorites")
    func deleteNonFavoritesPreservesFavorites() {
        // Given
        let storage = Database(models: [PodcastDB.self], inMemory: true)
        let favorites = [
            PodcastDB(postId: "1", title: "Fav 1", favorite: true),
            PodcastDB(postId: "2", title: "Fav 2", favorite: true),
            PodcastDB(postId: "3", title: "Fav 3", favorite: true)
        ]
        let nonFavorites = [
            PodcastDB(postId: "4", title: "Non-Fav 1", favorite: false),
            PodcastDB(postId: "5", title: "Non-Fav 2", favorite: false)
        ]

        favorites.forEach { storage.context.insert($0) }
        nonFavorites.forEach { storage.context.insert($0) }
        try? storage.context.save()

        // When
        PodcastDB.deleteNonFavorites(using: storage.context)

        // Then
        let remaining = storage.fetch(PodcastDB.self)
        #expect(remaining.count == 3)
        #expect(remaining.allSatisfy { $0.favorite == true })
    }

    @Test("deleteNonFavorites should handle empty database")
    func deleteNonFavoritesHandlesEmptyDatabase() {
        // Given
        let storage = Database(models: [PodcastDB.self], inMemory: true)

        // When
        PodcastDB.deleteNonFavorites(using: storage.context)

        // Then
        let remaining = storage.fetch(PodcastDB.self)
        #expect(remaining.isEmpty)
    }

    @Test("deleteNonFavorites should handle all favorites")
    func deleteNonFavoritesHandlesAllFavorites() {
        // Given
        let storage = Database(models: [PodcastDB.self], inMemory: true)
        let allFavorites = [
            PodcastDB(postId: "1", favorite: true),
            PodcastDB(postId: "2", favorite: true),
            PodcastDB(postId: "3", favorite: true)
        ]
        allFavorites.forEach { storage.context.insert($0) }
        try? storage.context.save()

        // When
        PodcastDB.deleteNonFavorites(using: storage.context)

        // Then
        let remaining = storage.fetch(PodcastDB.self)
        #expect(remaining.count == 3)
    }

    @Test("deleteNonFavorites should handle all non-favorites")
    func deleteNonFavoritesHandlesAllNonFavorites() {
        // Given
        let storage = Database(models: [PodcastDB.self], inMemory: true)
        let allNonFavorites = [
            PodcastDB(postId: "1", favorite: false),
            PodcastDB(postId: "2", favorite: false),
            PodcastDB(postId: "3", favorite: false)
        ]
        allNonFavorites.forEach { storage.context.insert($0) }
        try? storage.context.save()

        // When
        PodcastDB.deleteNonFavorites(using: storage.context)

        // Then
        let remaining = storage.fetch(PodcastDB.self)
        #expect(remaining.isEmpty)
    }

    @Test("toggleFavorite flips favorite and stamps favoriteModifiedAt without touching progress")
    func toggleFavoriteStampsFavoriteModifiedAt() {
        let podcast = PodcastDB(postId: "1", current: 900)
        let progressModifiedAtBefore = podcast.progressModifiedAt

        podcast.toggleFavorite()

        #expect(podcast.favorite == true)
        #expect(podcast.favoriteModifiedAt != Date.distantPast)
        #expect(podcast.progressModifiedAt == progressModifiedAtBefore)

        podcast.toggleFavorite()
        #expect(podcast.favorite == false)
    }

    @Test("updateProgress sets current and stamps progressModifiedAt without touching favorite")
    func updateProgressStampsProgressModifiedAt() {
        let podcast = PodcastDB(postId: "1", favorite: true)
        let favoriteModifiedAtBefore = podcast.favoriteModifiedAt

        podcast.updateProgress(450)

        #expect(podcast.current == 450)
        #expect(podcast.progressModifiedAt != Date.distantPast)
        #expect(podcast.favoriteModifiedAt == favoriteModifiedAtBefore)
    }

    // MARK: - ModelDuplicable Tests

    @Test("deduplicate removes duplicate postIds keeping most recently modified")
    func deduplicateKeepsMostRecentlyModified() {
        let storage = Database(models: [PodcastDB.self], inMemory: true)
        let older = PodcastDB(postId: "dup-1", title: "Older", modifiedAt: Date(timeIntervalSince1970: 1000))
        let newer = PodcastDB(postId: "dup-1", title: "Newer", modifiedAt: Date(timeIntervalSince1970: 2000))

        storage.context.insert(older)
        storage.context.insert(newer)
        try? storage.context.save()

        PodcastDB.deduplicate(using: storage.context)

        let remaining = storage.fetch(PodcastDB.self)
        #expect(remaining.count == 1)
        #expect(remaining.first?.title == "Newer")
    }

    @Test("deduplicate preserves podcasts with distinct postIds sharing the same pubDate")
    func deduplicatePreservesDistinctPostIds() {
        let storage = Database(models: [PodcastDB.self], inMemory: true)
        let sharedPubDate = Date(timeIntervalSince1970: 5000)
        storage.context.insert(PodcastDB(postId: "1", pubDate: sharedPubDate))
        storage.context.insert(PodcastDB(postId: "2", pubDate: sharedPubDate))
        storage.context.insert(PodcastDB(postId: "3", pubDate: sharedPubDate))
        try? storage.context.save()

        PodcastDB.deduplicate(using: storage.context)

        let remaining = storage.fetch(PodcastDB.self)
        #expect(remaining.count == 3)
    }

    @Test("deduplicate handles triple duplicates for same postId")
    func deduplicateHandlesTripleDuplicates() {
        let storage = Database(models: [PodcastDB.self], inMemory: true)
        let now = Date()

        storage.context.insert(PodcastDB(postId: "dup-1", modifiedAt: now.addingTimeInterval(-200)))
        storage.context.insert(PodcastDB(postId: "dup-1", modifiedAt: now.addingTimeInterval(-100)))
        storage.context.insert(PodcastDB(postId: "dup-1", title: "Winner", modifiedAt: now))
        try? storage.context.save()

        PodcastDB.deduplicate(using: storage.context)

        let remaining = storage.fetch(PodcastDB.self)
        #expect(remaining.count == 1)
        #expect(remaining.first?.title == "Winner")
    }

    @Test("deduplicate keeps the most recently modified content even when a different duplicate wins the favorite merge")
    func deduplicateDecouplesContentSurvivorFromFavoriteMerge() {
        let storage = Database(models: [PodcastDB.self], inMemory: true)
        let originallyFavorited = PodcastDB(postId: "dup-1", title: "Original", favorite: true, favoriteModifiedAt: Date(timeIntervalSince1970: 5000), modifiedAt: Date(timeIntervalSince1970: 1000))
        let freshSync = PodcastDB(postId: "dup-1", title: "Fresh Sync", favorite: false, modifiedAt: Date(timeIntervalSince1970: 2000))

        storage.context.insert(originallyFavorited)
        storage.context.insert(freshSync)
        try? storage.context.save()

        PodcastDB.deduplicate(using: storage.context)

        let remaining = storage.fetch(PodcastDB.self)
        #expect(remaining.count == 1)
        #expect(remaining.first?.title == "Fresh Sync")
        #expect(remaining.first?.favorite == true)
    }

    @Test("deduplicate respects an explicit cross-device unfavorite over an older favorite")
    func deduplicateRespectsExplicitUnfavorite() {
        let storage = Database(models: [PodcastDB.self], inMemory: true)
        let favoritedOnDeviceA = PodcastDB(postId: "dup-1", favorite: true, favoriteModifiedAt: Date(timeIntervalSince1970: 1000), modifiedAt: Date(timeIntervalSince1970: 1000))
        let unfavoritedOnDeviceB = PodcastDB(postId: "dup-1", favorite: false, favoriteModifiedAt: Date(timeIntervalSince1970: 2000), modifiedAt: Date(timeIntervalSince1970: 2000))

        storage.context.insert(favoritedOnDeviceA)
        storage.context.insert(unfavoritedOnDeviceB)
        try? storage.context.save()

        PodcastDB.deduplicate(using: storage.context)

        let remaining = storage.fetch(PodcastDB.self)
        #expect(remaining.count == 1)
        #expect(remaining.first?.favorite == false)
    }

    @Test("deduplicate never lets a blank sync duplicate override real playback progress")
    func deduplicatePreservesProgressAgainstBlankDuplicate() {
        let storage = Database(models: [PodcastDB.self], inMemory: true)
        let listenedTo = PodcastDB(postId: "dup-1", current: 900, progressModifiedAt: Date(timeIntervalSince1970: 1000), modifiedAt: Date(timeIntervalSince1970: 1000))
        let freshSync = PodcastDB(postId: "dup-1", current: 0, modifiedAt: Date(timeIntervalSince1970: 2000))

        storage.context.insert(listenedTo)
        storage.context.insert(freshSync)
        try? storage.context.save()

        PodcastDB.deduplicate(using: storage.context)

        let remaining = storage.fetch(PodcastDB.self)
        #expect(remaining.count == 1)
        #expect(remaining.first?.current == 900)
    }

    @Test("deduplicate honors a deliberate rewind even though it lowers the playback position")
    func deduplicateHonorsDeliberateRewind() {
        let storage = Database(models: [PodcastDB.self], inMemory: true)
        let listenedFurtherButStale = PodcastDB(postId: "dup-1", current: 900, progressModifiedAt: Date(timeIntervalSince1970: 1000), modifiedAt: Date(timeIntervalSince1970: 1000))
        let rewoundOnAnotherDevice = PodcastDB(postId: "dup-1", current: 100, progressModifiedAt: Date(timeIntervalSince1970: 2000), modifiedAt: Date(timeIntervalSince1970: 2000))

        storage.context.insert(listenedFurtherButStale)
        storage.context.insert(rewoundOnAnotherDevice)
        try? storage.context.save()

        PodcastDB.deduplicate(using: storage.context)

        let remaining = storage.fetch(PodcastDB.self)
        #expect(remaining.count == 1)
        #expect(remaining.first?.current == 100)
    }

    @Test("deduplicate breaks an exact progressModifiedAt tie by preferring the larger value, regardless of insertion order")
    func deduplicateBreaksProgressTieDeterministically() {
        let insertionOrders: [(first: Double, second: Double)] = [(900, 100), (100, 900)]

        for order in insertionOrders {
            let storage = Database(models: [PodcastDB.self], inMemory: true)
            let first = PodcastDB(postId: "dup-1", current: order.first, modifiedAt: Date(timeIntervalSince1970: 1000))
            let second = PodcastDB(postId: "dup-1", current: order.second, modifiedAt: Date(timeIntervalSince1970: 1000))

            storage.context.insert(first)
            storage.context.insert(second)
            try? storage.context.save()

            PodcastDB.deduplicate(using: storage.context)

            let remaining = storage.fetch(PodcastDB.self)
            #expect(remaining.count == 1)
            #expect(remaining.first?.current == 900)
        }
    }

    @Test("deduplicate merges favorite and progress independently by their own timestamps")
    func deduplicateMergesFavoriteAndProgressIndependently() {
        let storage = Database(models: [PodcastDB.self], inMemory: true)
        let favoritedButNotListened = PodcastDB(
            postId: "dup-1", favorite: true, favoriteModifiedAt: Date(timeIntervalSince1970: 2000),
            current: 0, modifiedAt: Date(timeIntervalSince1970: 1000)
        )
        let listenedButNotFavorited = PodcastDB(
            postId: "dup-1", favorite: false, favoriteModifiedAt: Date(timeIntervalSince1970: 1000),
            current: 900, progressModifiedAt: Date(timeIntervalSince1970: 2000), modifiedAt: Date(timeIntervalSince1970: 2000)
        )

        storage.context.insert(favoritedButNotListened)
        storage.context.insert(listenedButNotFavorited)
        try? storage.context.save()

        PodcastDB.deduplicate(using: storage.context)

        let remaining = storage.fetch(PodcastDB.self)
        #expect(remaining.count == 1)
        #expect(remaining.first?.favorite == true)
        #expect(remaining.first?.current == 900)
    }

    @Test("deduplicate is safe on empty database")
    func deduplicateSafeOnEmpty() {
        let storage = Database(models: [PodcastDB.self], inMemory: true)
        PodcastDB.deduplicate(using: storage.context)
        #expect(storage.fetch(PodcastDB.self).isEmpty)
    }

    @Test("deduplicate with nil context does not crash")
    func deduplicateNilContext() {
        PodcastDB.deduplicate(using: nil)
    }

    // MARK: - Integration Tests

    @Test("PodcastDB should work with database fetch predicates")
    func worksWithFetchPredicates() {
        // Given
        let storage = Database(models: [PodcastDB.self], inMemory: true)
        storage.context.insert(PodcastDB(postId: "1", title: "First", favorite: true))
        storage.context.insert(PodcastDB(postId: "2", title: "Second", favorite: false))
        storage.context.insert(PodcastDB(postId: "3", title: "Third", favorite: true))
        try? storage.context.save()

        // When
        let predicate = #Predicate<PodcastDB> { $0.favorite == true }
        let favorites = storage.fetch(PodcastDB.self, predicate: predicate)

        // Then
        #expect(favorites.count == 2)
        #expect(favorites.allSatisfy { $0.favorite == true })
    }

    @Test("PodcastDB should support querying by postId")
    func supportsQueryingByPostId() {
        // Given
        let storage = Database(models: [PodcastDB.self], inMemory: true)
        storage.context.insert(PodcastDB(postId: "123", title: "Target"))
        storage.context.insert(PodcastDB(postId: "456", title: "Other"))
        try? storage.context.save()

        // When
        let targetId = "123"
        let predicate = #Predicate<PodcastDB> { $0.postId == targetId }
        let results = storage.fetch(PodcastDB.self, predicate: predicate)

        // Then
        #expect(results.count == 1)
        #expect(results.first?.title == "Target")
    }

    @Test("PodcastDB should support querying by playable status")
    func supportsQueryingByPlayableStatus() {
        // Given
        let storage = Database(models: [PodcastDB.self], inMemory: true)
        storage.context.insert(PodcastDB(postId: "1", playable: true))
        storage.context.insert(PodcastDB(postId: "2", playable: false))
        storage.context.insert(PodcastDB(postId: "3", playable: true))
        try? storage.context.save()

        // When
        let predicate = #Predicate<PodcastDB> { $0.playable == true }
        let playablePodcasts = storage.fetch(PodcastDB.self, predicate: predicate)

        // Then
        #expect(playablePodcasts.count == 2)
        #expect(playablePodcasts.allSatisfy { $0.playable == true })
    }

    @Test("PodcastDB should track playback progress with current property")
    func tracksPlaybackProgress() {
        // Given
        let storage = Database(models: [PodcastDB.self], inMemory: true)
        let podcast = PodcastDB(postId: "1", title: "Progress Test", current: 0.0)
        storage.context.insert(podcast)
        try? storage.context.save()

        // When - Simulate playback progress
        podcast.current = 150.5
        try? storage.context.save()

        // Then
        let fetched = storage.fetch(PodcastDB.self).first
        #expect(fetched?.current == 150.5)
    }

    @Test("PodcastDB should handle multiple podcasts with different states")
    func handlesMultiplePodcastsWithDifferentStates() {
        // Given
        let storage = Database(models: [PodcastDB.self], inMemory: true)
        storage.context.insert(PodcastDB(
            postId: "1",
            favorite: true,
            playable: true,
            current: 100.0
        ))
        storage.context.insert(PodcastDB(
            postId: "2",
            favorite: false,
            playable: true,
            current: 0.0
        ))
        storage.context.insert(PodcastDB(
            postId: "3",
            favorite: true,
            playable: false,
            current: 50.0
        ))
        try? storage.context.save()

        // When
        let allPodcasts = storage.fetch(PodcastDB.self)
        let favoritesAndPlayable = storage.fetch(
            PodcastDB.self,
            predicate: #Predicate<PodcastDB> { $0.favorite && $0.playable }
        )

        // Then
        #expect(allPodcasts.count == 3)
        #expect(favoritesAndPlayable.count == 1)
        #expect(favoritesAndPlayable.first?.postId == "1")
    }
}
