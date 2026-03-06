import Foundation
import MacMagazineLibrary

public enum SortPreference: Sendable {
    case relevance
    case recent
}

public enum ContentType: Sendable {
    case news
    case podcast
    case video
}

struct QueryIntent: Sendable {
    let originalQuery: String
    let normalizedTerms: [String]
    let entities: [String]
    let suggestedCategories: [NewsCategory]?
    let sortPreference: SortPreference
    let contentTypes: Set<ContentType>
    var remoteSearchTerm: String
}
