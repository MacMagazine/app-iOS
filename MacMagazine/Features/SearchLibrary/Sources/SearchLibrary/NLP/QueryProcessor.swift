import Foundation
import NaturalLanguage

struct QueryProcessor: Sendable {

    func process(_ query: String) -> QueryIntent {
        let trimmed = query.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else {
            return QueryIntent(
                originalQuery: query,
                normalizedTerms: [],
                entities: [],
                suggestedCategories: nil,
                sortPreference: .relevance,
                contentTypes: [],
                remoteSearchTerm: ""
            )
        }

        let tokens = tokenize(trimmed)
        let lemmas = lemmatize(trimmed)
        let entities = extractEntities(trimmed)

        let normalizedTerms = lemmas.isEmpty ? tokens : lemmas
        let lowercaseTerms = normalizedTerms.map { $0.lowercased() }

        // Match categories against original query to preserve multi-word phrases like "como fazer"
        let categories = PortugueseLexicon.matchCategories(query: trimmed.lowercased(), terms: lowercaseTerms)

        let cleanedTerms = PortugueseLexicon.removeStopWords(from: lowercaseTerms)
        let contentTypes = PortugueseLexicon.matchContentTypes(terms: cleanedTerms)
        let isRecent = PortugueseLexicon.matchRecency(terms: cleanedTerms)

        let remoteSearchTerm = buildRemoteSearchTerm(
            original: trimmed,
            cleanedTerms: cleanedTerms
        )

        return QueryIntent(
            originalQuery: query,
            normalizedTerms: cleanedTerms,
            entities: entities,
            suggestedCategories: categories.isEmpty ? nil : categories,
            sortPreference: isRecent ? .recent : .relevance,
            contentTypes: contentTypes,
            remoteSearchTerm: remoteSearchTerm
        )
    }
}

// MARK: - NLP Pipeline

private extension QueryProcessor {

    func tokenize(_ text: String) -> [String] {
        let tokenizer = NLTokenizer(unit: .word)
        tokenizer.setLanguage(.portuguese)
        tokenizer.string = text

        var tokens: [String] = []
        tokenizer.enumerateTokens(in: text.startIndex..<text.endIndex) { range, _ in
            tokens.append(String(text[range]))
            return true
        }
        return tokens
    }

    func lemmatize(_ text: String) -> [String] {
        let tagger = NLTagger(tagSchemes: [.lemma])
        tagger.string = text
        tagger.setLanguage(.portuguese, range: text.startIndex..<text.endIndex)

        var lemmas: [String] = []
        tagger.enumerateTags(
            in: text.startIndex..<text.endIndex,
            unit: .word,
            scheme: .lemma
        ) { tag, range in
            let word = String(text[range])
            lemmas.append(tag?.rawValue ?? word)
            return true
        }
        return lemmas
    }

    func extractEntities(_ text: String) -> [String] {
        let tagger = NLTagger(tagSchemes: [.nameType])
        tagger.string = text

        var entities: [String] = []
        let options: NLTagger.Options = [.omitPunctuation, .omitWhitespace]
        tagger.enumerateTags(
            in: text.startIndex..<text.endIndex,
            unit: .word,
            scheme: .nameType,
            options: options
        ) { tag, range in
            guard let tag else { return true }
            switch tag {
            case .personalName, .organizationName, .placeName:
                entities.append(String(text[range]))
            default:
                break
            }
            return true
        }
        return entities
    }

    func buildRemoteSearchTerm(original: String, cleanedTerms: [String]) -> String {
        let filtered = cleanedTerms.filter { term in
            !PortugueseLexicon.recencyKeywords.contains(term)
                && !PortugueseLexicon.videoKeywords.contains(term)
                && !PortugueseLexicon.podcastKeywords.contains(term)
        }
        return filtered.isEmpty ? original : filtered.joined(separator: " ")
    }
}
