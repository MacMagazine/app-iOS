import Testing
import Foundation
@testable import FeedLibrary

@Suite("XMLPost Tests")
struct XMLPostTests {

    // MARK: - XMLPost Initialization Tests

    @Test("XMLPost has correct default values")
    func xmlPostDefaultValues() {
        // Given/When
        let post = XMLPost()

        // Then
        #expect(post.title == "")
        #expect(post.link == "")
        #expect(post.categories == [])
        #expect(post.excerpt == "")
        #expect(post.artworkURL == "")
        #expect(post.podcastURL == "")
        #expect(post.podcastSize == 0)
        #expect(post.podcast == "")
        #expect(post.duration == "")
        #expect(post.podcastFrame == "")
        #expect(post.favorite == false)
        #expect(post.postId == "")
        #expect(post.shortURL == "")
        #expect(post.playable == false)
        #expect(post.fullContent == "")
        #expect(post.creator == "")
    }

    @Test("XMLPost is Codable")
    func xmlPostCodable() throws {
        // Given
        var post = XMLPost()
        post.title = "Test Title"
        post.link = "https://example.com"
        post.postId = "12345"
        post.categories = ["Tech", "Apple"]
        post.excerpt = "Test excerpt"
        post.creator = "John Doe"

        // When - Encode
        let encoder = JSONEncoder()
        let data = try encoder.encode(post)

        // Then - Decode
        let decoder = JSONDecoder()
        let decodedPost = try decoder.decode(XMLPost.self, from: data)

        #expect(decodedPost.title == post.title)
        #expect(decodedPost.link == post.link)
        #expect(decodedPost.postId == post.postId)
        #expect(decodedPost.categories == post.categories)
        #expect(decodedPost.excerpt == post.excerpt)
        #expect(decodedPost.creator == post.creator)
    }

    // MARK: - XMLPost to PodcastDB Conversion Tests

    @Test("XMLPost array converts to PodcastDB array correctly")
    func xmlPostArrayToPodcastDBConversion() {
        // Given
        var post1 = XMLPost()
        post1.postId = "123"
        post1.title = "Podcast Episode 1"
        post1.podcast = "Episode subtitle"
        post1.pubDate = Date()
        post1.artworkURL = "https://example.com/image.jpg"
        post1.podcastURL = "https://example.com/podcast.mp3"
        post1.podcastSize = 1024000
        post1.duration = "45:30"
        post1.podcastFrame = "<iframe>...</iframe>"

        var post2 = XMLPost()
        post2.postId = "456"
        post2.title = "Podcast Episode 2"
        post2.podcast = "Another subtitle"

        let posts = [post1, post2]

        // When
        let podcastDBs = posts.toPodcastDB

        // Then
        #expect(podcastDBs.count == 2)

        let firstPodcast = podcastDBs[0]
        #expect(firstPodcast.postId == "123")
        #expect(firstPodcast.title == "Podcast Episode 1")
        #expect(firstPodcast.subtitle == "Episode subtitle")
        #expect(firstPodcast.artworkURL == "https://example.com/image.jpg")
        #expect(firstPodcast.podcastURL == "https://example.com/podcast.mp3")
        #expect(firstPodcast.podcastSize == 1024000)
        #expect(firstPodcast.duration == "45:30")
        #expect(firstPodcast.podcastFrame == "<iframe>...</iframe>")

        let secondPodcast = podcastDBs[1]
        #expect(secondPodcast.postId == "456")
        #expect(secondPodcast.title == "Podcast Episode 2")
        #expect(secondPodcast.subtitle == "Another subtitle")
    }

    @Test("Empty XMLPost array converts to empty PodcastDB array")
    func xmlPostArrayToPodcastDBEmptyArray() {
        // Given
        let posts: [XMLPost] = []

        // When
        let podcastDBs = posts.toPodcastDB

        // Then
        #expect(podcastDBs.isEmpty)
    }

    @Test("XMLPost to PodcastDB preserves dates")
    func xmlPostToPodcastDBPreservesDates() {
        // Given
        var post = XMLPost()
        let testDate = Date()
        post.pubDate = testDate
        post.postId = "789"
        post.title = "Test"

        // When
        let podcastDB = [post].toPodcastDB.first!

        // Then
        #expect(podcastDB.pubDate == testDate)
    }

    // MARK: - XMLPost Field Tests

    @Test("XMLPost with podcast fields stores values correctly")
    func xmlPostWithPodcastFields() {
        // Given/When
        var post = XMLPost()
        post.podcastURL = "https://example.com/podcast.mp3"
        post.podcastSize = 5000000
        post.duration = "1:23:45"
        post.podcast = "Podcast subtitle"
        post.podcastFrame = "<iframe src='player'></iframe>"

        // Then
        #expect(post.podcastURL == "https://example.com/podcast.mp3")
        #expect(post.podcastSize == 5000000)
        #expect(post.duration == "1:23:45")
        #expect(post.podcast == "Podcast subtitle")
        #expect(post.podcastFrame == "<iframe src='player'></iframe>")
    }

    @Test("XMLPost with multiple categories stores all categories")
    func xmlPostWithMultipleCategories() {
        // Given/When
        var post = XMLPost()
        post.categories = ["Tech", "Apple", "iPhone", "iOS"]

        // Then
        #expect(post.categories.count == 4)
        #expect(post.categories.contains("Tech"))
        #expect(post.categories.contains("Apple"))
        #expect(post.categories.contains("iPhone"))
        #expect(post.categories.contains("iOS"))
    }

    @Test("XMLPost playable flag can be set")
    func xmlPostPlayableFlag() {
        // Given/When
        var post = XMLPost()
        post.playable = true

        // Then
        #expect(post.playable == true)
    }

    @Test("XMLPost favorite flag can be set")
    func xmlPostFavoriteFlag() {
        // Given/When
        var post = XMLPost()
        post.favorite = true

        // Then
        #expect(post.favorite == true)
    }
}
