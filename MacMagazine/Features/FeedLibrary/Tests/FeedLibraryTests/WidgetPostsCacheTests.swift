@testable import FeedLibrary
import Foundation
import Testing

@Suite("WidgetPostsCache Tests")
struct WidgetPostsCacheTests {
    private let directory: URL
    private let cache: WidgetPostsCache

    init() throws {
        directory = FileManager.default.temporaryDirectory.appending(path: UUID().uuidString)
        try FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true)
        cache = WidgetPostsCache(fileURL: directory.appending(path: "widget-posts-systemSmall.json"))
    }

    private let posts = [
        WidgetData(
            postId: "1",
            title: "First",
            thumbnail: "https://example.com/1.jpg",
            pubDate: Date(timeIntervalSince1970: 1_700_000_000),
            link: "https://example.com/1",
            imageData: Data([0xFF, 0xD8, 0xFF])
        ),
        WidgetData(
            postId: "2",
            title: "Second",
            thumbnail: "https://example.com/2.jpg",
            pubDate: Date(timeIntervalSince1970: 1_700_000_100),
            link: "https://example.com/2"
        )
    ]

    @Test("Saved posts load back unchanged")
    func roundTrip() throws {
        try cache.save(posts)

        #expect(cache.load() == posts)
    }

    @Test("Missing file loads as empty")
    func missingFileLoadsEmpty() {
        #expect(cache.load().isEmpty)
    }

    @Test("Corrupt file loads as empty")
    func corruptFileLoadsEmpty() throws {
        try Data("not json".utf8).write(to: cache.fileURL)

        #expect(cache.load().isEmpty)
    }

    @Test("Saving an empty array keeps the existing posts")
    func savingEmptyKeepsExistingPosts() throws {
        try cache.save(posts)

        try cache.save([])

        #expect(cache.load() == posts)
    }
}
