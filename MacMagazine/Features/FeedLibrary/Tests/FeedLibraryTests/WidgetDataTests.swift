@testable import FeedLibrary
import Foundation
import Testing

@Suite("WidgetData Tests")
struct WidgetDataTests {

    // MARK: - Initialization Tests

    @Test("WidgetData should initialize with all properties")
    func initializationWithAllProperties() {
        // Given
        let postId = "12345"
        let title = "Test Title"
        let thumbnail = "https://example.com/image.jpg"
        let pubDate = Date()
        let link = "https://example.com/post"

        // When
        let widgetData = WidgetData(
            postId: postId,
            title: title,
            thumbnail: thumbnail,
            pubDate: pubDate,
            link: link
        )

        // Then
        #expect(widgetData.postId == postId)
        #expect(widgetData.title == title)
        #expect(widgetData.thumbnail == thumbnail)
        #expect(widgetData.pubDate == pubDate)
        #expect(widgetData.link == link)
    }

    @Test("WidgetData should handle empty strings")
    func initializationWithEmptyStrings() {
        // Given
        let emptyPostId = ""
        let emptyTitle = ""
        let emptyThumbnail = ""
        let emptyLink = ""
        let date = Date()

        // When
        let widgetData = WidgetData(
            postId: emptyPostId,
            title: emptyTitle,
            thumbnail: emptyThumbnail,
            pubDate: date,
            link: emptyLink
        )

        // Then
        #expect(widgetData.postId.isEmpty)
        #expect(widgetData.title.isEmpty)
        #expect(widgetData.thumbnail.isEmpty)
        #expect(widgetData.link.isEmpty)
    }

    // MARK: - Codable Tests

    @Test("WidgetData should encode to JSON correctly")
    func encodesToJSON() throws {
        // Given
        let pubDate = Date(timeIntervalSince1970: 1234567890)
        let widgetData = WidgetData(
            postId: "123",
            title: "Test",
            thumbnail: "image.jpg",
            pubDate: pubDate,
            link: "link.com"
        )
        let encoder = JSONEncoder()

        // When
        let data = try encoder.encode(widgetData)
        let json = try JSONSerialization.jsonObject(with: data) as? [String: Any]

        // Then
        #expect(json != nil)
        #expect(json?["postId"] as? String == "123")
        #expect(json?["title"] as? String == "Test")
        #expect(json?["thumbnail"] as? String == "image.jpg")
        #expect(json?["link"] as? String == "link.com")
        #expect(json?["pubDate"] != nil)
    }

    @Test("WidgetData should decode from JSON correctly")
    func decodesFromJSON() throws {
        // Given
        let jsonString = """
        {
            "postId": "456",
            "title": "Decoded Title",
            "thumbnail": "decoded.jpg",
            "pubDate": 1234567890.0,
            "link": "decoded-link.com"
        }
        """
        let data = Data(jsonString.utf8)
        let decoder = JSONDecoder()

        // When
        let widgetData = try decoder.decode(WidgetData.self, from: data)

        // Then
        #expect(widgetData.postId == "456")
        #expect(widgetData.title == "Decoded Title")
        #expect(widgetData.thumbnail == "decoded.jpg")
        #expect(widgetData.link == "decoded-link.com")
    }

    @Test("WidgetData encoding and decoding should be reversible")
    func encodingDecodingRoundTrip() throws {
        // Given
        let original = WidgetData(
            postId: "789",
            title: "Round Trip",
            thumbnail: "trip.jpg",
            pubDate: Date(),
            link: "roundtrip.com"
        )
        let encoder = JSONEncoder()
        let decoder = JSONDecoder()

        // When
        let encoded = try encoder.encode(original)
        let decoded = try decoder.decode(WidgetData.self, from: encoded)

        // Then
        #expect(decoded.postId == original.postId)
        #expect(decoded.title == original.title)
        #expect(decoded.thumbnail == original.thumbnail)
        #expect(decoded.link == original.link)
        #expect(abs(decoded.pubDate.timeIntervalSince1970 - original.pubDate.timeIntervalSince1970) < 0.001)
    }

    // MARK: - Hashable Tests

    @Test("WidgetData with same values should be equal")
    func equalityWithSameValues() {
        // Given
        let date = Date()
        let widgetData1 = WidgetData(
            postId: "123",
            title: "Title",
            thumbnail: "image.jpg",
            pubDate: date,
            link: "link.com"
        )
        let widgetData2 = WidgetData(
            postId: "123",
            title: "Title",
            thumbnail: "image.jpg",
            pubDate: date,
            link: "link.com"
        )

        // Then
        #expect(widgetData1 == widgetData2)
    }

    @Test("WidgetData with different values should not be equal")
    func inequalityWithDifferentValues() {
        // Given
        let date = Date()
        let widgetData1 = WidgetData(
            postId: "123",
            title: "Title",
            thumbnail: "image.jpg",
            pubDate: date,
            link: "link.com"
        )
        let widgetData2 = WidgetData(
            postId: "456",
            title: "Different",
            thumbnail: "other.jpg",
            pubDate: date,
            link: "other.com"
        )

        // Then
        #expect(widgetData1 != widgetData2)
    }

    @Test("WidgetData should hash correctly")
    func hashingBehavior() {
        // Given
        let date = Date()
        let widgetData1 = WidgetData(
            postId: "123",
            title: "Title",
            thumbnail: "image.jpg",
            pubDate: date,
            link: "link.com"
        )
        let widgetData2 = WidgetData(
            postId: "123",
            title: "Title",
            thumbnail: "image.jpg",
            pubDate: date,
            link: "link.com"
        )

        // Then
        #expect(widgetData1.hashValue == widgetData2.hashValue)
    }

    @Test("WidgetData should work in Set")
    func worksInSet() {
        // Given
        let date = Date()
        let widgetData1 = WidgetData(
            postId: "123",
            title: "Title",
            thumbnail: "image.jpg",
            pubDate: date,
            link: "link.com"
        )
        let widgetData2 = WidgetData(
            postId: "123",
            title: "Title",
            thumbnail: "image.jpg",
            pubDate: date,
            link: "link.com"
        )
        let widgetData3 = WidgetData(
            postId: "456",
            title: "Different",
            thumbnail: "other.jpg",
            pubDate: date,
            link: "other.com"
        )

        // When
        var set = Set<WidgetData>()
        set.insert(widgetData1)
        set.insert(widgetData2)
        set.insert(widgetData3)

        // Then
        #expect(set.count == 2, "Set should contain 2 unique items")
        #expect(set.contains(widgetData1))
        #expect(set.contains(widgetData3))
    }

    @Test("WidgetData should work as Dictionary key")
    func worksAsDictionaryKey() {
        // Given
        let date = Date()
        let widgetData = WidgetData(
            postId: "123",
            title: "Title",
            thumbnail: "image.jpg",
            pubDate: date,
            link: "link.com"
        )

        // When
        var dict = [WidgetData: String]()
        dict[widgetData] = "test value"

        // Then
        #expect(dict[widgetData] == "test value")
    }

    // MARK: - Edge Case Tests

    @Test("WidgetData should handle special characters in strings")
    func handlesSpecialCharacters() {
        // Given
        let specialTitle = "Test & <Title> \"with\" 'quotes'"
        let widgetData = WidgetData(
            postId: "123",
            title: specialTitle,
            thumbnail: "image.jpg",
            pubDate: Date(),
            link: "link.com"
        )

        // Then
        #expect(widgetData.title == specialTitle)
    }

    @Test("WidgetData should handle unicode characters")
    func handlesUnicodeCharacters() {
        // Given
        let unicodeTitle = "Título com açúcar 🍎"
        let widgetData = WidgetData(
            postId: "123",
            title: unicodeTitle,
            thumbnail: "image.jpg",
            pubDate: Date(),
            link: "link.com"
        )

        // Then
        #expect(widgetData.title == unicodeTitle)
    }
}
