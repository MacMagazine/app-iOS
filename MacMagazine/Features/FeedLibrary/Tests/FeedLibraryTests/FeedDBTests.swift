@testable import FeedLibrary
import Foundation
import StorageLibrary
import SwiftData
import Testing

private struct FavoriteReadCase: Sendable {
    let olderFavorite: Bool
    let olderRead: Bool
    let newerFavorite: Bool
    let newerRead: Bool
    let expectedFavorite: Bool
    let expectedRead: Bool
}

@Suite("FeedDB Tests")
@MainActor
struct FeedDBTests {

    // MARK: - Initialization Tests

    @Test("FeedDB should initialize with all properties")
    func initializationWithAllProperties() {
        // Given
        let postId = "12345"
        let title = "Test Title"
        let subtitle = "Test Subtitle"
        let pubDate = Date()
        let artworkURL = "https://example.com/image.jpg"
        let link = "https://example.com/post"
        let categories = ["Tech", "News"]
        let excerpt = "Test excerpt"
        let fullContent = "Full content"
        let favorite = true

        // When
        let feed = FeedDB(
            postId: postId,
            title: title,
            subtitle: subtitle,
            pubDate: pubDate,
            artworkURL: artworkURL,
            link: link,
            categories: categories,
            excerpt: excerpt,
            fullContent: fullContent,
            favorite: favorite
        )

        // Then
        #expect(feed.postId == postId)
        #expect(feed.title == title)
        #expect(feed.subtitle == subtitle)
        #expect(feed.pubDate == pubDate)
        #expect(feed.artworkURL == artworkURL)
        #expect(feed.link == link)
        #expect(feed.categories == categories)
        #expect(feed.excerpt == excerpt)
        #expect(feed.fullContent == fullContent)
        #expect(feed.favorite == favorite)
    }

    @Test("FeedDB should initialize with default values")
    func initializationWithDefaults() {
        // When
        let feed = FeedDB()

        // Then
        #expect(feed.postId.isEmpty)
        #expect(feed.title.isEmpty)
        #expect(feed.subtitle.isEmpty)
        #expect(feed.artworkURL.isEmpty)
        #expect(feed.link.isEmpty)
        #expect(feed.categories.isEmpty)
        #expect(feed.excerpt.isEmpty)
        #expect(feed.fullContent.isEmpty)
        #expect(feed.favorite == false)
    }

    @Test("FeedDB should handle empty strings")
    func initializationWithEmptyStrings() {
        // When
        let feed = FeedDB(
            postId: "",
            title: "",
            subtitle: "",
            artworkURL: "",
            link: "",
            excerpt: "",
            fullContent: ""
        )

        // Then
        #expect(feed.postId.isEmpty)
        #expect(feed.title.isEmpty)
        #expect(feed.subtitle.isEmpty)
        #expect(feed.artworkURL.isEmpty)
        #expect(feed.link.isEmpty)
        #expect(feed.excerpt.isEmpty)
        #expect(feed.fullContent.isEmpty)
    }

    @Test("FeedDB should handle empty categories array")
    func initializationWithEmptyCategories() {
        // When
        let feed = FeedDB(categories: [])

        // Then
        #expect(feed.categories.isEmpty)
    }

    @Test("FeedDB should handle multiple categories")
    func initializationWithMultipleCategories() {
        // Given
        let categories = ["Tech", "News", "Apple", "Review"]

        // When
        let feed = FeedDB(categories: categories)

        // Then
        #expect(feed.categories.count == 4)
        #expect(feed.categories == categories)
    }

    // MARK: - Property Tests

    @Test("FeedDB properties should be mutable")
    func propertiesAreMutable() {
        // Given
        let feed = FeedDB()

        // When
        feed.postId = "123"
        feed.title = "New Title"
        feed.favorite = true

        // Then
        #expect(feed.postId == "123")
        #expect(feed.title == "New Title")
        #expect(feed.favorite == true)
    }

    @Test("FeedDB should handle special characters in strings")
    func handlesSpecialCharacters() {
        // Given
        let specialTitle = "Test & <Title> \"with\" 'quotes'"

        // When
        let feed = FeedDB(title: specialTitle)

        // Then
        #expect(feed.title == specialTitle)
    }

    @Test("FeedDB should handle unicode characters")
    func handlesUnicodeCharacters() {
        // Given
        let unicodeTitle = "Título com açúcar 🍎"

        // When
        let feed = FeedDB(title: unicodeTitle)

        // Then
        #expect(feed.title == unicodeTitle)
    }

    // MARK: - SwiftData Model Tests

    @Test("FeedDB should be persistable in SwiftData")
    func isPersistableInSwiftData() {
        // Given
        let storage = Database(models: [FeedDB.self], inMemory: true)
        let feed = FeedDB(
            postId: "test-123",
            title: "Persistable Test",
            favorite: false
        )

        // When
        storage.context.insert(feed)
        try? storage.context.save()

        // Then
        let fetched = storage.fetch(FeedDB.self)
        #expect(fetched.count == 1)
        #expect(fetched.first?.postId == "test-123")
        #expect(fetched.first?.title == "Persistable Test")
    }

    @Test("FeedDB should persist all properties correctly")
    func persistsAllPropertiesCorrectly() {
        // Given
        let storage = Database(models: [FeedDB.self], inMemory: true)
        let pubDate = Date()
        let feed = FeedDB(
            postId: "123",
            title: "Title",
            subtitle: "Subtitle",
            pubDate: pubDate,
            artworkURL: "artwork.jpg",
            link: "link.com",
            categories: ["Cat1", "Cat2"],
            excerpt: "Excerpt",
            fullContent: "Content",
            favorite: true
        )

        // When
        storage.context.insert(feed)
        try? storage.context.save()

        // Then
        let fetched = storage.fetch(FeedDB.self).first
        #expect(fetched?.postId == "123")
        #expect(fetched?.title == "Title")
        #expect(fetched?.subtitle == "Subtitle")
        #expect(fetched?.artworkURL == "artwork.jpg")
        #expect(fetched?.link == "link.com")
        #expect(fetched?.categories == ["Cat1", "Cat2"])
        #expect(fetched?.excerpt == "Excerpt")
        #expect(fetched?.fullContent == "Content")
        #expect(fetched?.favorite == true)
    }

    // MARK: - ModelFavoritable Tests

    @Test("deleteNonFavorites should remove non-favorite items")
    func deleteNonFavoritesRemovesNonFavorites() {
        // Given
        let storage = Database(models: [FeedDB.self], inMemory: true)
        let favorite1 = FeedDB(postId: "1", title: "Favorite 1", favorite: true)
        let favorite2 = FeedDB(postId: "2", title: "Favorite 2", favorite: true)
        let nonFavorite1 = FeedDB(postId: "3", title: "Non-Favorite 1", favorite: false)
        let nonFavorite2 = FeedDB(postId: "4", title: "Non-Favorite 2", favorite: false)

        storage.context.insert(favorite1)
        storage.context.insert(favorite2)
        storage.context.insert(nonFavorite1)
        storage.context.insert(nonFavorite2)
        try? storage.context.save()

        // When
        FeedDB.deleteNonFavorites(using: storage.context)

        // Then
        let remaining = storage.fetch(FeedDB.self)
        #expect(remaining.count == 2)
        #expect(remaining.allSatisfy { $0.favorite == true })
        #expect(remaining.contains { $0.postId == "1" })
        #expect(remaining.contains { $0.postId == "2" })
    }

    @Test("deleteNonFavorites should preserve all favorites")
    func deleteNonFavoritesPreservesFavorites() {
        // Given
        let storage = Database(models: [FeedDB.self], inMemory: true)
        let favorites = [
            FeedDB(postId: "1", title: "Fav 1", favorite: true),
            FeedDB(postId: "2", title: "Fav 2", favorite: true),
            FeedDB(postId: "3", title: "Fav 3", favorite: true)
        ]
        let nonFavorites = [
            FeedDB(postId: "4", title: "Non-Fav 1", favorite: false),
            FeedDB(postId: "5", title: "Non-Fav 2", favorite: false)
        ]

        favorites.forEach { storage.context.insert($0) }
        nonFavorites.forEach { storage.context.insert($0) }
        try? storage.context.save()

        // When
        FeedDB.deleteNonFavorites(using: storage.context)

        // Then
        let remaining = storage.fetch(FeedDB.self)
        #expect(remaining.count == 3)
        #expect(remaining.allSatisfy { $0.favorite == true })
    }

    @Test("deleteNonFavorites should handle empty database")
    func deleteNonFavoritesHandlesEmptyDatabase() {
        // Given
        let storage = Database(models: [FeedDB.self], inMemory: true)

        // When
        FeedDB.deleteNonFavorites(using: storage.context)

        // Then
        let remaining = storage.fetch(FeedDB.self)
        #expect(remaining.isEmpty)
    }

    @Test("deleteNonFavorites should handle all favorites")
    func deleteNonFavoritesHandlesAllFavorites() {
        // Given
        let storage = Database(models: [FeedDB.self], inMemory: true)
        let allFavorites = [
            FeedDB(postId: "1", favorite: true),
            FeedDB(postId: "2", favorite: true),
            FeedDB(postId: "3", favorite: true)
        ]
        allFavorites.forEach { storage.context.insert($0) }
        try? storage.context.save()

        // When
        FeedDB.deleteNonFavorites(using: storage.context)

        // Then
        let remaining = storage.fetch(FeedDB.self)
        #expect(remaining.count == 3)
    }

    @Test("deleteNonFavorites should handle all non-favorites")
    func deleteNonFavoritesHandlesAllNonFavorites() {
        // Given
        let storage = Database(models: [FeedDB.self], inMemory: true)
        let allNonFavorites = [
            FeedDB(postId: "1", favorite: false),
            FeedDB(postId: "2", favorite: false),
            FeedDB(postId: "3", favorite: false)
        ]
        allNonFavorites.forEach { storage.context.insert($0) }
        try? storage.context.save()

        // When
        FeedDB.deleteNonFavorites(using: storage.context)

        // Then
        let remaining = storage.fetch(FeedDB.self)
        #expect(remaining.isEmpty)
    }

    // MARK: - ModelReadable Tests

    @Test("markAllAsRead should mark all unread posts as read")
    func markAllAsReadMarksUnreadPosts() {
        let storage = Database(models: [FeedDB.self], inMemory: true)
        storage.context.insert(FeedDB(postId: "1", title: "Unread 1"))
        storage.context.insert(FeedDB(postId: "2", title: "Unread 2"))
        storage.context.insert(FeedDB(postId: "3", title: "Unread 3"))
        try? storage.context.save()

        FeedDB.markAllAsRead(using: storage.context)

        let posts = storage.fetch(FeedDB.self)
        #expect(posts.count == 3)
        #expect(posts.allSatisfy { $0.read == true })
    }

    @Test("markAllAsRead should not affect already-read posts")
    func markAllAsReadPreservesAlreadyRead() {
        let storage = Database(models: [FeedDB.self], inMemory: true)
        let originalDate = Date(timeIntervalSince1970: 1000)
        let alreadyRead = FeedDB(postId: "1", title: "Already Read", modifiedAt: originalDate)
        alreadyRead.read = true
        storage.context.insert(alreadyRead)
        storage.context.insert(FeedDB(postId: "2", title: "Unread"))
        try? storage.context.save()

        FeedDB.markAllAsRead(using: storage.context)

        let posts = storage.fetch(FeedDB.self)
        #expect(posts.allSatisfy { $0.read == true })
        let readPost = posts.first { $0.postId == "1" }
        #expect(readPost?.modifiedAt == originalDate)
    }

    @Test("markAllAsRead should handle empty database")
    func markAllAsReadHandlesEmptyDatabase() {
        let storage = Database(models: [FeedDB.self], inMemory: true)
        FeedDB.markAllAsRead(using: storage.context)
        #expect(storage.fetch(FeedDB.self).isEmpty)
    }

    @Test("markAllAsRead with nil context does not crash")
    func markAllAsReadNilContext() {
        FeedDB.markAllAsRead(using: nil)
    }

    @Test("markAllAsRead should update modifiedAt on newly-read posts")
    func markAllAsReadUpdatesModifiedAt() {
        let storage = Database(models: [FeedDB.self], inMemory: true)
        let oldDate = Date(timeIntervalSince1970: 1000)
        let post = FeedDB(postId: "1", title: "Old Post", modifiedAt: oldDate)
        storage.context.insert(post)
        try? storage.context.save()

        FeedDB.markAllAsRead(using: storage.context)

        let fetched = storage.fetch(FeedDB.self).first
        #expect(fetched?.read == true)
        #expect(fetched?.modifiedAt != oldDate)
    }

    // MARK: - ModelDuplicable Tests

    @Test("deduplicate removes duplicate postIds keeping most recently modified")
    func deduplicateKeepsMostRecentlyModified() {
        let storage = Database(models: [FeedDB.self], inMemory: true)
        let older = FeedDB(postId: "dup-1", title: "Older", modifiedAt: Date(timeIntervalSince1970: 1000))
        let newer = FeedDB(postId: "dup-1", title: "Newer", modifiedAt: Date(timeIntervalSince1970: 2000))

        storage.context.insert(older)
        storage.context.insert(newer)
        try? storage.context.save()

        FeedDB.deduplicate(using: storage.context)

        let remaining = storage.fetch(FeedDB.self)
        #expect(remaining.count == 1)
        #expect(remaining.first?.title == "Newer")
    }

    @Test("deduplicate preserves distinct postIds")
    func deduplicatePreservesDistinctPostIds() {
        let storage = Database(models: [FeedDB.self], inMemory: true)
        storage.context.insert(FeedDB(postId: "a", title: "Post A"))
        storage.context.insert(FeedDB(postId: "b", title: "Post B"))
        storage.context.insert(FeedDB(postId: "c", title: "Post C"))
        try? storage.context.save()

        FeedDB.deduplicate(using: storage.context)

        let remaining = storage.fetch(FeedDB.self)
        #expect(remaining.count == 3)
    }

    @Test("deduplicate handles multiple groups of duplicates")
    func deduplicateHandlesMultipleGroups() {
        let storage = Database(models: [FeedDB.self], inMemory: true)
        let now = Date()

        storage.context.insert(FeedDB(postId: "x", title: "X-old", modifiedAt: now.addingTimeInterval(-100)))
        storage.context.insert(FeedDB(postId: "x", title: "X-new", modifiedAt: now))
        storage.context.insert(FeedDB(postId: "y", title: "Y-old", modifiedAt: now.addingTimeInterval(-200)))
        storage.context.insert(FeedDB(postId: "y", title: "Y-mid", modifiedAt: now.addingTimeInterval(-50)))
        storage.context.insert(FeedDB(postId: "y", title: "Y-new", modifiedAt: now))
        try? storage.context.save()

        FeedDB.deduplicate(using: storage.context)

        let remaining = storage.fetch(FeedDB.self)
        #expect(remaining.count == 2)
        #expect(remaining.contains { $0.title == "X-new" })
        #expect(remaining.contains { $0.title == "Y-new" })
    }

    @Test("deduplicate keeps the favorited copy even when it is not the most recently modified")
    func deduplicateKeepsFavoriteOverRecency() {
        let storage = Database(models: [FeedDB.self], inMemory: true)
        let favorited = FeedDB(postId: "dup-1", title: "Favorited", favorite: true, modifiedAt: Date(timeIntervalSince1970: 1000))
        let freshSync = FeedDB(postId: "dup-1", title: "Fresh Sync", favorite: false, modifiedAt: Date(timeIntervalSince1970: 2000))

        storage.context.insert(favorited)
        storage.context.insert(freshSync)
        try? storage.context.save()

        FeedDB.deduplicate(using: storage.context)

        let remaining = storage.fetch(FeedDB.self)
        #expect(remaining.count == 1)
        #expect(remaining.first?.title == "Favorited")
        #expect(remaining.first?.favorite == true)
    }

    @Test(
        "deduplicate OR-merges favorite and read across every combination",
        arguments: [
            FavoriteReadCase(olderFavorite: true, olderRead: false, newerFavorite: false, newerRead: false, expectedFavorite: true, expectedRead: false),
            FavoriteReadCase(olderFavorite: false, olderRead: true, newerFavorite: false, newerRead: false, expectedFavorite: false, expectedRead: true),
            FavoriteReadCase(olderFavorite: true, olderRead: true, newerFavorite: false, newerRead: false, expectedFavorite: true, expectedRead: true),
            FavoriteReadCase(olderFavorite: true, olderRead: true, newerFavorite: true, newerRead: false, expectedFavorite: true, expectedRead: true),
            FavoriteReadCase(olderFavorite: false, olderRead: false, newerFavorite: false, newerRead: false, expectedFavorite: false, expectedRead: false)
        ]
    )
    fileprivate func deduplicateMergesFavoriteAndReadState(_ testCase: FavoriteReadCase) {
        let storage = Database(models: [FeedDB.self], inMemory: true)
        let older = FeedDB(postId: "dup-1", favorite: testCase.olderFavorite, modifiedAt: Date(timeIntervalSince1970: 1000))
        older.read = testCase.olderRead
        let newer = FeedDB(postId: "dup-1", favorite: testCase.newerFavorite, modifiedAt: Date(timeIntervalSince1970: 2000))
        newer.read = testCase.newerRead

        storage.context.insert(older)
        storage.context.insert(newer)
        try? storage.context.save()

        FeedDB.deduplicate(using: storage.context)

        let remaining = storage.fetch(FeedDB.self)
        #expect(remaining.count == 1)
        #expect(remaining.first?.favorite == testCase.expectedFavorite)
        #expect(remaining.first?.read == testCase.expectedRead)
    }

    @Test("deduplicate is safe on empty database")
    func deduplicateSafeOnEmpty() {
        let storage = Database(models: [FeedDB.self], inMemory: true)
        FeedDB.deduplicate(using: storage.context)
        #expect(storage.fetch(FeedDB.self).isEmpty)
    }

    @Test("deduplicate with nil context does not crash")
    func deduplicateNilContext() {
        FeedDB.deduplicate(using: nil)
    }

    // MARK: - Integration Tests

    @Test("FeedDB should work with database fetch predicates")
    func worksWithFetchPredicates() {
        // Given
        let storage = Database(models: [FeedDB.self], inMemory: true)
        storage.context.insert(FeedDB(postId: "1", title: "First", favorite: true))
        storage.context.insert(FeedDB(postId: "2", title: "Second", favorite: false))
        storage.context.insert(FeedDB(postId: "3", title: "Third", favorite: true))
        try? storage.context.save()

        // When
        let predicate = #Predicate<FeedDB> { $0.favorite == true }
        let favorites = storage.fetch(FeedDB.self, predicate: predicate)

        // Then
        #expect(favorites.count == 2)
        #expect(favorites.allSatisfy { $0.favorite == true })
    }

    @Test("FeedDB should support querying by postId")
    func supportsQueryingByPostId() {
        // Given
        let storage = Database(models: [FeedDB.self], inMemory: true)
        storage.context.insert(FeedDB(postId: "123", title: "Target"))
        storage.context.insert(FeedDB(postId: "456", title: "Other"))
        try? storage.context.save()

        // When
        let targetId = "123"
        let predicate = #Predicate<FeedDB> { $0.postId == targetId }
        let results = storage.fetch(FeedDB.self, predicate: predicate)

        // Then
        #expect(results.count == 1)
        #expect(results.first?.title == "Target")
    }

    @Test("FeedDB should support querying by categories")
    func supportsQueryingByCategories() {
        // Given
        let storage = Database(models: [FeedDB.self], inMemory: true)
        storage.context.insert(FeedDB(postId: "1", categories: ["Tech"]))
        storage.context.insert(FeedDB(postId: "2", categories: ["News"]))
        storage.context.insert(FeedDB(postId: "3", categories: ["Tech", "News"]))

        // When
        let predicate = #Predicate<FeedDB> { $0.categories.contains("Tech") }
        let techPosts = storage.fetch(FeedDB.self, predicate: predicate)

        // Then
        #expect(techPosts.count == 2)
    }
}
