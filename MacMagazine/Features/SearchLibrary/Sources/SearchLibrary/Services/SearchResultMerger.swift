import Foundation

protocol SearchResultMergerProtocol {
    func merge(existing: [SearchResult], incoming: [SearchResult], intent: QueryIntent) -> [SearchResult]
}

struct SearchResultMerger: SearchResultMergerProtocol {
    private let scorer = RelevanceScorer()

    func merge(
        existing: [SearchResult],
        incoming: [SearchResult],
        intent: QueryIntent
    ) -> [SearchResult] {
        var resultMap: [String: SearchResult] = [:]

        // Local results first — they have DB references and favorite state
        for result in existing {
            resultMap[deduplicationKey(for: result)] = result
        }

        // Only add remote results that don't already exist locally
        for result in incoming {
            let key = deduplicationKey(for: result)
            if resultMap[key] != nil {
                continue
            }
            resultMap[key] = result
        }

        var scored = Array(resultMap.values)
        for index in scored.indices {
            scored[index].relevanceScore = scorer.score(result: scored[index], intent: intent)
        }

        switch intent.sortPreference {
        case .recent:
            return scored.sorted { $0.pubDate > $1.pubDate }
        case .relevance:
            return scored.sorted { $0.relevanceScore > $1.relevanceScore }
        }
    }
}

// MARK: - Deduplication

private extension SearchResultMerger {

    func deduplicationKey(for result: SearchResult) -> String {
        switch result.type {
        case .news:
            let postId = result.feedDB?.postId ?? extractId(from: result.id, prefixes: ["news_", "remote_news_"])
            return "news_\(postId)"
        case .podcast:
            let postId = result.podcastDB?.postId ?? extractId(from: result.id, prefixes: ["podcast_", "remote_podcast_"])
            return "podcast_\(postId)"
        case .video:
            let videoId = result.videoDB?.videoId ?? extractId(from: result.id, prefixes: ["video_", "remote_video_"])
            return "video_\(videoId)"
        }
    }

    func extractId(from id: String, prefixes: [String]) -> String {
        for prefix in prefixes where id.hasPrefix(prefix) {
            return String(id.dropFirst(prefix.count))
        }
        return id
    }
}
