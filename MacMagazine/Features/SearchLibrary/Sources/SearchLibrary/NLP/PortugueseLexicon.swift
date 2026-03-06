import MacMagazineLibrary

enum PortugueseLexicon {

    // MARK: - Category Mappings

    static let categoryKeywords: [String: NewsCategory] = [
        // Tutorials
        "tutorial": .tutorials,
        "como fazer": .tutorials,
        "dica": .tutorials,
        "passo a passo": .tutorials,
        "guia": .tutorials,
        // Rumors
        "rumor": .rumors,
        "vazamento": .rumors,
        "leak": .rumors,
        "suposto": .rumors,
        // Reviews
        "review": .reviews,
        "analise": .reviews,
        "teste": .reviews,
        "unboxing": .reviews,
        // Highlights
        "destaque": .highlights,
        // Apple TV
        "apple tv": .appletv,
        "tv+": .appletv,
        "apple tv+": .appletv,
        "streaming": .appletv,
        "serie": .appletv,
        "filme": .appletv
    ]

    // MARK: - Content Type Mappings

    static let videoKeywords: Set<String> = [
        "video", "assistir", "youtube", "ver"
    ]

    static let podcastKeywords: Set<String> = [
        "podcast", "ouvir", "episodio"
    ]

    // MARK: - Recency Mappings

    static let recencyKeywords: Set<String> = [
        "recente", "ultimo", "novo", "hoje", "ontem", "semana"
    ]

    // MARK: - Stop Words (PT-BR)

    static let stopWords: Set<String> = [
        "o", "a", "os", "as", "de", "do", "da", "dos", "das",
        "em", "no", "na", "nos", "nas", "por", "para", "com",
        "um", "uma", "uns", "umas", "e", "ou", "que", "se",
        "ao", "pelo", "pela", "este", "esta", "esse", "essa",
        "como", "mais", "sobre", "entre"
    ]

    // MARK: - Lookup

    static func matchCategories(query: String, terms: [String]) -> [NewsCategory] {
        var matched: [NewsCategory] = []
        // Use original query for multi-word phrases, lemmatized terms for single words
        let joined = terms.joined(separator: " ")
        for (keyword, category) in categoryKeywords {
            let isMatch = keyword.contains(" ")
                ? query.contains(keyword)
                : joined.contains(keyword)
            if isMatch, !matched.contains(category) {
                matched.append(category)
            }
        }
        return matched
    }

    static func matchContentTypes(terms: [String]) -> Set<ContentType> {
        var types = Set<ContentType>()
        for term in terms {
            if videoKeywords.contains(term) { types.insert(.video) }
            if podcastKeywords.contains(term) { types.insert(.podcast) }
        }
        return types
    }

    static func matchRecency(terms: [String]) -> Bool {
        terms.contains { recencyKeywords.contains($0) }
    }

    static func removeStopWords(from terms: [String]) -> [String] {
        terms.filter { !stopWords.contains($0) }
    }
}
