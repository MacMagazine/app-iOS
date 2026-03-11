import FeedLibrary
import Foundation
@testable import SearchLibrary
import Testing

@Suite("RemoteFeedSearchService Classification Tests")
struct RemoteFeedSearchServiceTests {

    // MARK: - Result Type Classification

    @Test("Feed with MMTV category is classified as video")
    func mmtvCategoryClassifiedAsVideo() {
        let feed = FeedDB(
            postId: "1",
            title: "MMTV Episode",
            categories: ["NewsCategoryMMTV", "NewsCategoryNews"]
        )
        let result = classifyFeed(feed)
        #expect(result.type == .video)
    }

    @Test("Feed with YouTube rawValue category is classified as video")
    func youtubeRawValueClassifiedAsVideo() {
        let feed = FeedDB(
            postId: "2",
            title: "Video Post",
            categories: ["Vídeos"]
        )
        let result = classifyFeed(feed)
        #expect(result.type == .video)
    }

    @Test("Feed with only news categories is classified as news")
    func newsCategoriesClassifiedAsNews() {
        let feed = FeedDB(
            postId: "3",
            title: "Regular Article",
            categories: ["NewsCategoryNews", "NewsCategoryHighlights"]
        )
        let result = classifyFeed(feed)
        #expect(result.type == .news)
    }

    @Test("Feed with no categories is classified as news")
    func emptyCategoriesClassifiedAsNews() {
        let feed = FeedDB(
            postId: "4",
            title: "Uncategorized Post",
            categories: []
        )
        let result = classifyFeed(feed)
        #expect(result.type == .news)
    }

    @Test("Feed with podcast category but no podcastURL is classified as news")
    func podcastCategoryWithoutURLIsNews() {
        let feed = FeedDB(
            postId: "5",
            title: "Podcast Post",
            categories: ["NewsCategoryPodcast"]
        )
        let result = classifyFeed(feed)
        #expect(result.type == .news)
    }

    @Test("Feed with mixed categories including MMTV is classified as video")
    func mixedCategoriesWithMMTVIsVideo() {
        let feed = FeedDB(
            postId: "6",
            title: "Mixed Content",
            categories: ["NewsCategoryRumors", "NewsCategoryMMTV", "NewsCategoryReviews"]
        )
        let result = classifyFeed(feed)
        #expect(result.type == .video)
    }

    // MARK: - Podcast Results

    @Test("PodcastDB results are always classified as podcast")
    func podcastDBAlwaysClassifiedAsPodcast() {
        let podcast = PodcastDB(
            postId: "7",
            title: "Podcast Episode",
            podcastURL: "https://example.com/audio.mp3"
        )
        let result = classifyPodcast(podcast)
        #expect(result.type == .podcast)
    }

    @Test("PodcastDB with empty podcastURL is still classified as podcast")
    func podcastDBWithEmptyURLStillPodcast() {
        let podcast = PodcastDB(
            postId: "8",
            title: "Podcast Without Audio"
        )
        let result = classifyPodcast(podcast)
        #expect(result.type == .podcast)
    }

    // MARK: - Result Data Integrity

    @Test("Feed result preserves postId as result id")
    func feedResultPreservesPostId() {
        let feed = FeedDB(postId: "abc123", title: "Test")
        let result = classifyFeed(feed)
        #expect(result.id == "abc123")
    }

    @Test("Feed result preserves pubDate")
    func feedResultPreservesPubDate() {
        let date = Date(timeIntervalSince1970: 1_000_000)
        let feed = FeedDB(postId: "1", pubDate: date)
        let result = classifyFeed(feed)
        #expect(result.pubDate == date)
    }

    @Test("Feed result carries feedDB reference")
    func feedResultCarriesFeedDB() {
        let feed = FeedDB(postId: "1", title: "Test Article")
        let result = classifyFeed(feed)
        #expect(result.feedDB != nil)
        #expect(result.feedDB?.title == "Test Article")
    }

    @Test("Podcast result carries podcastDB reference")
    func podcastResultCarriesPodcastDB() {
        let podcast = PodcastDB(postId: "1", title: "Test Podcast")
        let result = classifyPodcast(podcast)
        #expect(result.podcastDB != nil)
        #expect(result.podcastDB?.title == "Test Podcast")
    }
}

// MARK: - Helpers

private extension RemoteFeedSearchServiceTests {
    func classifyFeed(_ feed: FeedDB) -> SearchResult {
        let type = resultType(for: feed.categories)
        return SearchResult(
            id: feed.postId,
            type: type,
            pubDate: feed.pubDate,
            relevanceScore: 0,
            feedDB: feed
        )
    }

    func classifyPodcast(_ podcast: PodcastDB) -> SearchResult {
        SearchResult(
            id: podcast.postId,
            type: .podcast,
            pubDate: podcast.pubDate,
            relevanceScore: 0,
            podcastDB: podcast
        )
    }

    func resultType(for categories: [String]) -> SearchResultType {
        let isVideo = categories.contains { category in
            category == "NewsCategoryMMTV" || category == "Vídeos"
        }
        if isVideo { return .video }
        return .news
    }
}
