import FeedLibrary
import Foundation
@testable import SearchLibrary
import Testing

@Suite("RelevanceScorer Tests")
struct RelevanceScorerTests {
    let scorer = RelevanceScorer()
    let processor = QueryProcessor()

    private let fixedDate = Date()

    func makeResult(
        title: String = "",
        excerpt: String = "",
        categories: [String] = [],
        pubDate: Date? = nil
    ) -> SearchResult {
        let feed = FeedDB(
            postId: "test_\(title.hashValue)",
            title: title,
            pubDate: pubDate ?? fixedDate,
            artworkURL: "",
            link: "",
            categories: categories,
            excerpt: excerpt
        )
        return SearchResult(
            id: feed.postId,
            type: .news,
            pubDate: feed.pubDate,
            relevanceScore: 0,
            feedDB: feed
        )
    }

    @Test("Title match scores higher than excerpt match")
    func titleHigherThanExcerpt() {
        let intent = processor.process("iPhone")
        let titleMatch = makeResult(title: "iPhone 17 review")
        let excerptMatch = makeResult(title: "A review", excerpt: "The new iPhone is here")

        let titleScore = scorer.score(result: titleMatch, intent: intent)
        let excerptScore = scorer.score(result: excerptMatch, intent: intent)

        #expect(titleScore > excerptScore)
    }

    @Test("Recent results score higher than old results")
    func recencyBoost() {
        let intent = processor.process("test")
        let recent = makeResult(title: "test", pubDate: Date())
        let old = makeResult(title: "test", pubDate: Date(timeIntervalSinceNow: -365 * 86_400))

        let recentScore = scorer.score(result: recent, intent: intent)
        let oldScore = scorer.score(result: old, intent: intent)

        #expect(recentScore > oldScore)
    }

    @Test("No match gives only recency score")
    func noMatchMinimalScore() {
        let intent = processor.process("iPhone")
        let result = makeResult(title: "Something unrelated", pubDate: Date())

        let score = scorer.score(result: result, intent: intent)
        #expect(score < 0.5)
        #expect(score > 0)
    }
}
