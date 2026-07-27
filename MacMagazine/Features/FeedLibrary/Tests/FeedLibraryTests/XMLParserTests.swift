@testable import FeedLibrary
import Foundation
import Testing

@Suite("XMLParser Tests")
struct XMLParserTests {

    // MARK: - Feed Parsing Tests

    @Test("Parse feed XML successfully")
    func parseFeedXMLSuccessfully() async throws {
        // Given
        let feedURL = try #require(Bundle.module.url(forResource: "feed", withExtension: "json"))
        let feedData = try Data(contentsOf: feedURL)

        // When
        let posts = try await withCheckedThrowingContinuation { continuation in
            let parser = XMLParser(data: feedData)
            let apiParser = APIXMLParser(
                numberOfPosts: -1,
                category: "news",
                parseFullContent: false,
                continuation: continuation
            )
            parser.delegate = apiParser
            parser.parse()
        } as [XMLPost]

        // Then
        #expect(!posts.isEmpty, "Should parse at least one post")

        let firstPost = try #require(posts.first)
        #expect(!firstPost.title.isEmpty, "Post should have a title")
        #expect(!firstPost.link.isEmpty, "Post should have a link")
        #expect(!firstPost.postId.isEmpty, "Post should have a post ID")
        #expect(!firstPost.categories.isEmpty, "Post should have categories")
        #expect(!firstPost.excerpt.isEmpty, "Post should have an excerpt")
        #expect(!firstPost.creator.isEmpty, "Post should have a creator")
    }

    @Test("Parse feed XML with limited number of posts")
    func parseFeedXMLWithLimitedPosts() async throws {
        // Given
        let feedURL = try #require(Bundle.module.url(forResource: "feed", withExtension: "json"))
        let feedData = try Data(contentsOf: feedURL)
        let expectedCount = 3

        // When
        let posts = try await withCheckedThrowingContinuation { continuation in
            let parser = XMLParser(data: feedData)
            let apiParser = APIXMLParser(
                numberOfPosts: expectedCount,
                category: "news",
                parseFullContent: false,
                continuation: continuation
            )
            parser.delegate = apiParser
            parser.parse()
        } as [XMLPost]

        // Then
        #expect(posts.count == expectedCount, "Should parse exactly \(expectedCount) posts")
    }

    @Test("Parse feed XML extracts media content")
    func parseFeedXMLExtractsMediaContent() async throws {
        // Given
        let feedURL = try #require(Bundle.module.url(forResource: "feed", withExtension: "json"))
        let feedData = try Data(contentsOf: feedURL)

        // When
        let posts = try await withCheckedThrowingContinuation { continuation in
            let parser = XMLParser(data: feedData)
            let apiParser = APIXMLParser(
                numberOfPosts: 1,
                category: "news",
                parseFullContent: false,
                continuation: continuation
            )
            parser.delegate = apiParser
            parser.parse()
        } as [XMLPost]

        // Then
        let firstPost = try #require(posts.first)
        #expect(!firstPost.artworkURL.isEmpty, "Post should have artwork URL from media:content")
    }

    @Test("Parse feed XML with full content")
    func parseFeedXMLWithFullContent() async throws {
        // Given
        let feedURL = try #require(Bundle.module.url(forResource: "feed", withExtension: "json"))
        let feedData = try Data(contentsOf: feedURL)

        // When
        let posts = try await withCheckedThrowingContinuation { continuation in
            let parser = XMLParser(data: feedData)
            let apiParser = APIXMLParser(
                numberOfPosts: 1,
                category: "news",
                parseFullContent: true,
                continuation: continuation
            )
            parser.delegate = apiParser
            parser.parse()
        } as [XMLPost]

        // Then
        let firstPost = try #require(posts.first)
        #expect(!firstPost.fullContent.isEmpty, "Post should have full content when parseFullContent is true")
    }

    // MARK: - Podcast Parsing Tests

    @Test("Parse podcast XML successfully")
    func parsePodcastXMLSuccessfully() async throws {
        // Given
        let podcastURL = try #require(Bundle.module.url(forResource: "podcasts", withExtension: "json"))
        let podcastData = try Data(contentsOf: podcastURL)

        // When
        let posts = try await withCheckedThrowingContinuation { continuation in
            let parser = XMLParser(data: podcastData)
            let apiParser = APIXMLParser(
                numberOfPosts: -1,
                category: "podcast",
                parseFullContent: false,
                continuation: continuation
            )
            parser.delegate = apiParser
            parser.parse()
        } as [XMLPost]

        // Then
        #expect(!posts.isEmpty, "Should parse at least one podcast")

        let firstPodcast = try #require(posts.first)
        #expect(!firstPodcast.title.isEmpty, "Podcast should have a title")
        #expect(!firstPodcast.link.isEmpty, "Podcast should have a link")
        #expect(!firstPodcast.postId.isEmpty, "Podcast should have a post ID")
    }

    @Test("Parse podcast XML extracts podcast-specific fields")
    func parsePodcastXMLExtractsPodcastFields() async throws {
        // Given
        let podcastURL = try #require(Bundle.module.url(forResource: "podcasts", withExtension: "json"))
        let podcastData = try Data(contentsOf: podcastURL)

        // When
        let posts = try await withCheckedThrowingContinuation { continuation in
            let parser = XMLParser(data: podcastData)
            let apiParser = APIXMLParser(
                numberOfPosts: 1,
                category: "podcast",
                parseFullContent: false,
                continuation: continuation
            )
            parser.delegate = apiParser
            parser.parse()
        } as [XMLPost]

        // Then
        let firstPodcast = try #require(posts.first)

        // These fields are specific to podcasts
        if !firstPodcast.podcastURL.isEmpty {
            #expect(!firstPodcast.podcastURL.isEmpty, "Podcast should have enclosure URL")
        }
        if !firstPodcast.podcast.isEmpty {
            #expect(!firstPodcast.podcast.isEmpty, "Podcast should have subtitle")
        }
        if !firstPodcast.duration.isEmpty {
            #expect(!firstPodcast.duration.isEmpty, "Podcast should have duration")
        }
    }

    @Test("Image enclosure from search feed is not treated as a podcast URL")
    func parseSearchXMLImageEnclosureIsNotPodcastURL() async throws {
        // Given
        let xml = """
        <?xml version="1.0"?>
        <rss><channel><item>
            <post-id>123</post-id>
            <title>News item</title>
            <link>https://macmagazine.com.br/post</link>
            <enclosure url="https://macmagazine.com.br/image.jpg" length="12345" type="image/jpeg" />
        </item></channel></rss>
        """
        let data = Data(xml.utf8)

        // When
        let posts = try await withCheckedThrowingContinuation { continuation in
            let parser = XMLParser(data: data)
            let apiParser = APIXMLParser(
                numberOfPosts: -1,
                category: "",
                parseFullContent: false,
                continuation: continuation
            )
            parser.delegate = apiParser
            parser.parse()
        } as [XMLPost]

        // Then
        let post = try #require(posts.first)
        #expect(post.podcastURL.isEmpty, "Image enclosure must not populate podcastURL")
    }

    @Test("Audio enclosure from search feed is treated as a podcast URL")
    func parseSearchXMLAudioEnclosureIsPodcastURL() async throws {
        // Given
        let xml = """
        <?xml version="1.0"?>
        <rss><channel><item>
            <post-id>456</post-id>
            <title>Podcast item</title>
            <link>https://macmagazine.com.br/podcast</link>
            <enclosure url="https://feeds.soundcloud.com/stream/episode.mp3" length="67890" type="audio/mpeg" />
        </item></channel></rss>
        """
        let data = Data(xml.utf8)

        // When
        let posts = try await withCheckedThrowingContinuation { continuation in
            let parser = XMLParser(data: data)
            let apiParser = APIXMLParser(
                numberOfPosts: -1,
                category: "",
                parseFullContent: false,
                continuation: continuation
            )
            parser.delegate = apiParser
            parser.parse()
        } as [XMLPost]

        // Then
        let post = try #require(posts.first)
        #expect(post.podcastURL == "https://feeds.soundcloud.com/stream/episode.mp3")
    }

    // MARK: - Error Handling Tests

    @Test("Parse invalid XML throws error")
    func parseInvalidXMLThrowsError() async throws {
        // Given
        let invalidXML = Data("Not valid XML data".utf8)

        // When/Then
        await #expect(throws: Error.self) {
            try await withCheckedThrowingContinuation { continuation in
                let parser = XMLParser(data: invalidXML)
                let apiParser = APIXMLParser(
                    numberOfPosts: -1,
                    category: "news",
                    parseFullContent: false,
                    continuation: continuation
                )
                parser.delegate = apiParser
                parser.parse()
            } as [XMLPost]
        }
    }

    @Test("Parse empty data returns empty array")
    func parseEmptyDataReturnsEmptyArray() async throws {
        // Given
        let emptyXML = Data("<?xml version=\"1.0\"?><rss><channel></channel></rss>".utf8)

        // When
        let posts = try await withCheckedThrowingContinuation { continuation in
            let parser = XMLParser(data: emptyXML)
            let apiParser = APIXMLParser(
                numberOfPosts: -1,
                category: "news",
                parseFullContent: false,
                continuation: continuation
            )
            parser.delegate = apiParser
            parser.parse()
        } as [XMLPost]

        // Then
        #expect(posts.isEmpty, "Should return empty array for XML with no items")
    }
}
