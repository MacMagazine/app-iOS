@testable import FeedLibrary
import Foundation
import StorageLibrary
import SwiftData
import Testing

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

    @Test("deleteNonFavorites should handle nil context")
    func deleteNonFavoritesHandlesNilContext() {
        // When/Then - Should not crash
        FeedDB.deleteNonFavorites(using: nil)
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
