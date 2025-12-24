@testable import FeedLibrary
import Foundation
import NetworkLibrary
import Testing

@Suite("FeedEndpoint Tests")
struct FeedEndpointTests {

    // MARK: - APIDefinitions Tests

    @Test("APIDefinitions should have correct main domain")
    func apiDefinitionsMainDomain() {
        #expect(APIDefinitions.mainDomain == "macmagazine.com.br")
    }

    @Test("APIDefinitions should have correct main URL")
    func apiDefinitionsMainURL() {
        #expect(APIDefinitions.mainURL == "https://macmagazine.com.br/")
    }

    @Test("APIDefinitions should have correct login URLs")
    func apiDefinitionsLoginURLs() {
        #expect(APIDefinitions.patraoLoginUrl == "https://macmagazine.com.br/loginpatrao")
        #expect(APIDefinitions.patraoSuccessUrl == "https://macmagazine.com.br/wp-admin/profile.php")
    }

    @Test("APIDefinitions should have correct policy URLs")
    func apiDefinitionsPolicyURLs() {
        #expect(APIDefinitions.privacyUrl == "https://macmagazine.com.br/politica-privacidade/")
        #expect(APIDefinitions.termsUrl == "https://macmagazine.com.br/termos-de-uso/")
    }

    @Test("APIDefinitions should have correct API paths")
    func apiDefinitionsAPIPaths() {
        #expect(APIDefinitions.feed == "/feed/")
        #expect(APIDefinitions.paged == "paged")
        #expect(APIDefinitions.cat == "cat")
        #expect(APIDefinitions.tag == "tag")
        #expect(APIDefinitions.search == "s")
    }

    // MARK: - Endpoint.posts() Tests

    @Test("posts should create endpoint with default parameters")
    func postsWithDefaults() {
        // When
        let endpoint = Endpoint.posts()

        // Then
        #expect(endpoint.api == "/feed/")
        #expect(endpoint.host == "macmagazine.com.br")
    }

    @Test("posts should include paged query parameter")
    func postsWithPagedParameter() {
        // When
        let endpoint = Endpoint.posts(paged: 2)

        // Then
        #expect(endpoint.queryItems?.contains { $0.name == "paged" && $0.value == "2" } == true)
    }

    @Test("posts should handle zero page number")
    func postsWithZeroPage() {
        // When
        let endpoint = Endpoint.posts(paged: 0)

        // Then
        #expect(endpoint.queryItems?.contains { $0.name == "paged" && $0.value == "0" } == true)
    }

    @Test("posts should handle large page numbers")
    func postsWithLargePageNumber() {
        // When
        let endpoint = Endpoint.posts(paged: 999)

        // Then
        #expect(endpoint.queryItems?.contains { $0.name == "paged" && $0.value == "999" } == true)
    }

    @Test("posts should include category query parameter")
    func postsWithCategoryQuery() {
        // Given
        let categoryQuery = ("cat", "674")

        // When
        let endpoint = Endpoint.posts(query: categoryQuery)

        // Then
        #expect(endpoint.queryItems?.contains { $0.name == "cat" && $0.value == "674" } == true)
    }

    @Test("posts should include tag query parameter")
    func postsWithTagQuery() {
        // Given
        let tagQuery = ("tag", "apple-tv-plus")

        // When
        let endpoint = Endpoint.posts(query: tagQuery)

        // Then
        #expect(endpoint.queryItems?.contains { $0.name == "tag" && $0.value == "apple-tv-plus" } == true)
    }

    @Test("posts should include search query parameter")
    func postsWithSearchQuery() {
        // Given
        let searchQuery = ("s", "iPhone")

        // When
        let endpoint = Endpoint.posts(query: searchQuery)

        // Then
        #expect(endpoint.queryItems?.contains { $0.name == "s" && $0.value == "iPhone" } == true)
    }

    @Test("posts should include both paged and category parameters")
    func postsWithPagedAndCategory() {
        // Given
        let categoryQuery = ("cat", "101")

        // When
        let endpoint = Endpoint.posts(paged: 3, query: categoryQuery)

        // Then
        #expect(endpoint.queryItems?.contains { $0.name == "paged" && $0.value == "3" } == true)
        #expect(endpoint.queryItems?.contains { $0.name == "cat" && $0.value == "101" } == true)
        #expect(endpoint.queryItems?.count == 2)
    }

    @Test("posts should include both paged and tag parameters")
    func postsWithPagedAndTag() {
        // Given
        let tagQuery = ("tag", "review")

        // When
        let endpoint = Endpoint.posts(paged: 5, query: tagQuery)

        // Then
        #expect(endpoint.queryItems?.contains { $0.name == "paged" && $0.value == "5" } == true)
        #expect(endpoint.queryItems?.contains { $0.name == "tag" && $0.value == "review" } == true)
    }

    @Test("posts without query should only have paged parameter")
    func postsWithoutQuery() {
        // When
        let endpoint = Endpoint.posts(paged: 1, query: nil)

        // Then
        #expect(endpoint.queryItems?.count == 1)
        #expect(endpoint.queryItems?.first?.name == "paged")
        #expect(endpoint.queryItems?.first?.value == "1")
    }

    @Test("posts should use correct custom host")
    func postsUsesCorrectCustomHost() {
        // When
        let endpoint = Endpoint.posts()

        // Then
        #expect(endpoint.host == APIDefinitions.mainDomain)
    }

    @Test("posts should use correct API path")
    func postsUsesCorrectAPIPath() {
        // When
        let endpoint = Endpoint.posts()

        // Then
        #expect(endpoint.api == APIDefinitions.feed)
    }

    // MARK: - Integration Tests

    @Test("posts should create valid endpoint for highlights category")
    func postsForHighlightsCategory() {
        // Given - From NewsCategory.highlights
        let highlightsQuery = ("cat", "674")

        // When
        let endpoint = Endpoint.posts(paged: 1, query: highlightsQuery)

        // Then
        #expect(endpoint.api == "/feed/")
        #expect(endpoint.queryItems?.contains { $0.name == "paged" && $0.value == "1" } == true)
        #expect(endpoint.queryItems?.contains { $0.name == "cat" && $0.value == "674" } == true)
    }

    @Test("posts should create valid endpoint for podcast category")
    func postsForPodcastCategory() {
        // Given - From NewsCategory.podcast
        let podcastQuery = ("cat", "101")

        // When
        let endpoint = Endpoint.posts(paged: 0, query: podcastQuery)

        // Then
        #expect(endpoint.queryItems?.contains { $0.name == "cat" && $0.value == "101" } == true)
    }

    @Test("posts should create valid endpoint for YouTube category")
    func postsForYouTubeCategory() {
        // Given - From NewsCategory.youtube
        let youtubeQuery = ("cat", "18")

        // When
        let endpoint = Endpoint.posts(paged: 2, query: youtubeQuery)

        // Then
        #expect(endpoint.queryItems?.contains { $0.name == "cat" && $0.value == "18" } == true)
    }

    @Test("posts should create valid endpoint for Apple TV tag")
    func postsForAppleTVTag() {
        // Given - From NewsCategory.appletv
        let appleTVQuery = ("tag", "apple-tv-plus")

        // When
        let endpoint = Endpoint.posts(query: appleTVQuery)

        // Then
        #expect(endpoint.queryItems?.contains { $0.name == "tag" && $0.value == "apple-tv-plus" } == true)
    }

    @Test("posts should handle empty query values")
    func postsWithEmptyQueryValue() {
        // Given
        let emptyQuery = ("cat", "")

        // When
        let endpoint = Endpoint.posts(query: emptyQuery)

        // Then
        #expect(endpoint.queryItems?.contains { $0.name == "cat" && $0.value?.isEmpty ?? false } == true)
    }
}
