import FeedLibrary
import Foundation
import SwiftData
import YouTubeLibrary

struct LocalSearchService {
    private let scorer = RelevanceScorer()

    @MainActor
    func search(
        intent: QueryIntent,
        context: ModelContext
    ) -> [SearchResult] {
        var results: [SearchResult] = []

        let shouldSearchNews = intent.contentTypes.isEmpty || intent.contentTypes.contains(.news)
        let shouldSearchPodcasts = intent.contentTypes.isEmpty || intent.contentTypes.contains(.podcast)
        let shouldSearchVideos = intent.contentTypes.isEmpty || intent.contentTypes.contains(.video)

        if shouldSearchNews {
            results += searchFeed(intent: intent, context: context)
        }
        if shouldSearchPodcasts {
            results += searchPodcasts(intent: intent, context: context)
        }
        if shouldSearchVideos {
            results += searchVideos(intent: intent, context: context)
        }

        let scored = results
            .map { $0.withRelevanceScore(scorer.score(result: $0, intent: intent)) }

        switch intent.sortPreference {
        case .recent:
            return scored.sorted { $0.pubDate > $1.pubDate }
        case .relevance:
            return scored.sorted { $0.relevanceScore > $1.relevanceScore }
        }
    }
}

// MARK: - SwiftData Queries

private extension LocalSearchService {

    func searchFeed(intent: QueryIntent, context: ModelContext) -> [SearchResult] {
        let query = intent.originalQuery.lowercased()
        let descriptor = FetchDescriptor<FeedDB>(
            sortBy: [SortDescriptor(\FeedDB.pubDate, order: .reverse)]
        )

        guard let allFeed = try? context.fetch(descriptor) else { return [] }

        return allFeed
            .filter { item in
                item.title.localizedStandardContains(query)
                    || item.excerpt.localizedStandardContains(query)
                    || item.categories.contains { $0.localizedStandardContains(query) }
            }
            .map { $0.toSearchResult() }
    }

    func searchPodcasts(intent: QueryIntent, context: ModelContext) -> [SearchResult] {
        let query = intent.originalQuery.lowercased()
        let descriptor = FetchDescriptor<PodcastDB>(
            sortBy: [SortDescriptor(\PodcastDB.pubDate, order: .reverse)]
        )

        guard let allPodcasts = try? context.fetch(descriptor) else { return [] }

        return allPodcasts
            .filter { item in
                item.title.localizedStandardContains(query)
                    || item.subtitle.localizedStandardContains(query)
            }
            .map { $0.toSearchResult() }
    }

    func searchVideos(intent: QueryIntent, context: ModelContext) -> [SearchResult] {
        let query = intent.originalQuery.lowercased()
        let descriptor = FetchDescriptor<VideoDB>(
            sortBy: [SortDescriptor(\VideoDB.pubDate, order: .reverse)]
        )

        guard let allVideos = try? context.fetch(descriptor) else { return [] }

        return allVideos
            .filter { $0.title.localizedStandardContains(query) }
            .map { $0.toSearchResult() }
    }
}
