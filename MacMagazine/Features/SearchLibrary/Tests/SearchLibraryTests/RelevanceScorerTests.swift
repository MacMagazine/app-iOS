import Foundation
@testable import SearchLibrary
import Testing

@Suite("RelevanceScorer Tests")
struct RelevanceScorerTests {
    let scorer = RelevanceScorer()
    let processor = QueryProcessor()

    func makeResult(
        title: String = "",
        excerpt: String = "",
        categories: [String] = [],
        pubDate: Date = Date()
    ) -> SearchResult {
        SearchResult(
            id: "test_1",
            type: .news,
            title: title,
            excerpt: excerpt,
            artworkURL: "",
            pubDate: pubDate,
            author: nil,
            link: "",
            categories: categories,
            favorite: false,
            duration: nil,
            relevanceScore: 0,
            feedDB: nil,
            podcastDB: nil,
            videoDB: nil
        )
    }

    @Test("Title match scores higher than excerpt match")
    func titleHigherThanExcerpt() {
        let intent = processor.process("iPhone")
        let titleMatch = makeResult(title: "iPhone 17 review")
        let excerptMatch = makeResult(excerpt: "The new iPhone is here")

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
        // Should only have recency boost (~0.3 for today)
        #expect(score < 0.5)
        #expect(score > 0)
    }

    @Test("Multiple term matches accumulate score")
    func multipleTerms() {
        let intent = processor.process("iPhone review")
        let singleMatch = makeResult(title: "iPhone 17")
        let doubleMatch = makeResult(title: "iPhone review completo")

        let singleScore = scorer.score(result: singleMatch, intent: intent)
        let doubleScore = scorer.score(result: doubleMatch, intent: intent)

        #expect(doubleScore > singleScore)
    }
}
