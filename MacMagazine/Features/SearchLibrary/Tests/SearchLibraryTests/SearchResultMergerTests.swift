import Foundation
@testable import SearchLibrary
import Testing

@Suite("SearchResultMerger Tests")
struct SearchResultMergerTests {
    let merger = SearchResultMerger()
    let processor = QueryProcessor()

    func makeResult(
        id: String,
        type: SearchResultType = .news,
        title: String = "Test",
        pubDate: Date = Date(),
        favorite: Bool = false
    ) -> SearchResult {
        SearchResult(
            id: id,
            type: type,
            title: title,
            excerpt: "",
            artworkURL: "",
            pubDate: pubDate,
            author: nil,
            link: "",
            categories: [],
            favorite: favorite,
            duration: nil,
            relevanceScore: 0,
            feedDB: nil,
            podcastDB: nil,
            videoDB: nil
        )
    }

    @Test("Deduplicates by normalized ID")
    func deduplication() {
        let intent = processor.process("iPhone")
        let local = [makeResult(id: "news_123", title: "iPhone 17")]
        let remote = [makeResult(id: "remote_news_123", title: "iPhone 17")]

        let merged = merger.merge(existing: local, incoming: remote, intent: intent)
        #expect(merged.count == 1)
    }

    @Test("Local results take precedence over remote")
    func localPrecedence() {
        let intent = processor.process("iPhone")
        let local = [makeResult(id: "news_123", title: "iPhone 17", favorite: true)]
        let remote = [makeResult(id: "remote_news_123", title: "iPhone 17", favorite: false)]

        let merged = merger.merge(existing: local, incoming: remote, intent: intent)
        #expect(merged.count == 1)
        #expect(merged.first?.favorite == true)
    }

    @Test("Merges different result types")
    func mergesDifferentTypes() {
        let intent = processor.process("Apple")
        let local = [makeResult(id: "news_1", type: .news)]
        let remote = [makeResult(id: "podcast_1", type: .podcast)]

        let merged = merger.merge(existing: local, incoming: remote, intent: intent)
        #expect(merged.count == 2)
    }

    @Test("Recency sort: newest pubDate first when recency keyword used")
    func sortedByPubDate() {
        let intent = processor.process("test recente")
        let older = makeResult(id: "news_1", pubDate: Date(timeIntervalSinceNow: -86_400))
        let newer = makeResult(id: "news_2", pubDate: Date())

        let merged = merger.merge(existing: [older], incoming: [newer], intent: intent)
        #expect(intent.sortPreference == .recent)
        #expect(merged.first?.id == "news_2")
        #expect(merged.last?.id == "news_1")
    }

    @Test("Relevance sort: higher-scoring result first when no recency keyword")
    func relevanceSortPrioritizesScore() {
        let intent = processor.process("iPhone")
        #expect(intent.sortPreference == .relevance)

        let highMatch = makeResult(id: "news_1", title: "iPhone 17 review", pubDate: Date(timeIntervalSinceNow: -86_400))
        let lowMatch = makeResult(id: "news_2", title: "Something else", pubDate: Date())

        let merged = merger.merge(existing: [lowMatch], incoming: [highMatch], intent: intent)
        #expect(merged.first?.id == "news_1")
    }

    @Test("Empty merge returns empty")
    func emptyMerge() {
        let intent = processor.process("test")
        let merged = merger.merge(existing: [], incoming: [], intent: intent)
        #expect(merged.isEmpty)
    }
}
