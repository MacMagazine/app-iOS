import Foundation

struct RelevanceScorer {
    func score(result: SearchResult, intent: QueryIntent) -> Double {
        var score = 0.0

        let titleLower = result.title.lowercased()
        let excerptLower = result.excerpt.lowercased()

        // Text relevance — title (0.5), excerpt (0.2), categories (0.1)
        for term in intent.normalizedTerms {
            if titleLower.contains(term) { score += 0.5 }
            if excerptLower.contains(term) { score += 0.2 }
            if result.categories.contains(where: { $0.lowercased().contains(term) }) { score += 0.1 }
        }

        // Recency boost (0.3 weight, exponential decay over 30 days)
        let daysSincePublished = Date().timeIntervalSince(result.pubDate) / 86_400
        score += exp(-daysSincePublished / 30.0) * 0.3

        // Entity match (0.2 weight)
        for entity in intent.entities where titleLower.contains(entity.lowercased()) {
            score += 0.2
        }

        return score
    }
}

private extension SearchResult {
    var title: String {
        self.feedDB?.title ?? self.podcastDB?.title ?? self.videoDB?.title ?? ""
    }

    var excerpt: String {
        self.feedDB?.excerpt ?? self.podcastDB?.subtitle ?? ""
    }

    var categories: [String] {
        self.feedDB?.categories ?? []
    }
}
