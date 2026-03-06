@testable import SearchLibrary
import Testing

@Suite("QueryProcessor Tests")
struct QueryProcessorTests {
    let processor = QueryProcessor()

    @Test("Empty query returns empty intent")
    func emptyQuery() {
        let intent = processor.process("")
        #expect(intent.normalizedTerms.isEmpty)
        #expect(intent.entities.isEmpty)
        #expect(intent.remoteSearchTerm.isEmpty)
    }

    @Test("Simple query tokenizes correctly")
    func simpleQuery() {
        let intent = processor.process("iPhone 17")
        #expect(!intent.normalizedTerms.isEmpty)
        #expect(intent.remoteSearchTerm.contains("iphone") || intent.remoteSearchTerm.contains("iPhone"))
    }

    @Test("Tutorial keyword maps to tutorials category")
    func tutorialCategory() {
        let intent = processor.process("tutorial iPhone")
        #expect(intent.suggestedCategories?.contains(.tutorials) == true)
    }

    @Test("Rumor keyword maps to rumors category")
    func rumorCategory() {
        let intent = processor.process("rumor iPad")
        #expect(intent.suggestedCategories?.contains(.rumors) == true)
    }

    @Test("Review keyword maps to reviews category")
    func reviewCategory() {
        let intent = processor.process("review MacBook")
        #expect(intent.suggestedCategories?.contains(.reviews) == true)
    }

    @Test("Video keyword sets video content type")
    func videoContentType() {
        let intent = processor.process("video Apple Watch")
        #expect(intent.contentTypes.contains(.video))
    }

    @Test("Podcast keyword sets podcast content type")
    func podcastContentType() {
        let intent = processor.process("podcast Apple")
        #expect(intent.contentTypes.contains(.podcast))
    }

    @Test("Recency keyword sets recent sort preference")
    func recencySortPreference() {
        let intent = processor.process("iPhone recente")
        #expect(intent.sortPreference == .recent)
    }

    @Test("Default sort preference is relevance")
    func defaultSortPreference() {
        let intent = processor.process("iPhone 17 Pro Max")
        #expect(intent.sortPreference == .relevance)
    }

    @Test("Multi-word phrase 'como fazer' maps to tutorials category")
    func comoFazerCategory() {
        let intent = processor.process("como fazer backup")
        #expect(intent.suggestedCategories?.contains(.tutorials) == true)
    }

    @Test("Remote search term removes meta keywords")
    func remoteSearchTermCleaned() {
        let intent = processor.process("video recente iPhone")
        // Should not contain "video" or "recente" in remote search term
        #expect(!intent.remoteSearchTerm.contains("video"))
        #expect(!intent.remoteSearchTerm.contains("recente"))
        #expect(intent.remoteSearchTerm.lowercased().contains("iphone"))
    }
}
