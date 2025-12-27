@testable import FeedLibrary
import MacMagazineLibrary
import Testing

@Suite("Category Tests")
struct CategoryTests {

    // MARK: - Category Query Tests

    @Test("Highlights category has correct query")
    func highlightsCategoryQuery() {
        // Given
        let category = NewsCategory.highlights

        // When
        let query = category.query

        // Then
        #expect(query != nil)
        #expect(query?.0 == "cat")
        #expect(query?.1 == "674")
    }

    @Test("News category has nil query")
    func newsCategoryQuery() {
        // Given
        let category = NewsCategory.news

        // When
        let query = category.query

        // Then
        #expect(query == nil)
    }

    @Test("All category has nil query")
    func allCategoryQuery() {
        // Given
        let category = NewsCategory.all

        // When
        let query = category.query

        // Then
        #expect(query == nil)
    }

    @Test("Podcast category has correct query")
    func podcastCategoryQuery() {
        // Given
        let category = NewsCategory.podcast

        // When
        let query = category.query

        // Then
        #expect(query != nil)
        #expect(query?.0 == "cat")
        #expect(query?.1 == "101")
    }

    @Test("YouTube category has correct query")
    func youTubeCategoryQuery() {
        // Given
        let category = NewsCategory.youtube

        // When
        let query = category.query

        // Then
        #expect(query != nil)
        #expect(query?.0 == "cat")
        #expect(query?.1 == "9898")
    }

    @Test("AppleTV category has correct query")
    func appleTVCategoryQuery() {
        // Given
        let category = NewsCategory.appletv

        // When
        let query = category.query

        // Then
        #expect(query != nil)
        #expect(query?.0 == "tag")
        #expect(query?.1 == "apple-tv")
    }

    @Test("Reviews category has correct query")
    func reviewsCategoryQuery() {
        // Given
        let category = NewsCategory.reviews

        // When
        let query = category.query

        // Then
        #expect(query != nil)
        #expect(query?.0 == "tag")
        #expect(query?.1 == "review")
    }

    @Test("Tutoriais category has correct query")
    func tutoriaisCategoryQuery() {
        // Given
        let category = NewsCategory.tutorials

        // When
        let query = category.query

        // Then
        #expect(query != nil)
        #expect(query?.0 == "cat")
        #expect(query?.1 == "302")
    }

    @Test("Rumors category has correct query")
    func rumorsCategoryQuery() {
        // Given
        let category = NewsCategory.rumors

        // When
        let query = category.query

        // Then
        #expect(query != nil)
        #expect(query?.0 == "cat")
        #expect(query?.1 == "12")
    }

    // MARK: - Category Raw Value Tests

    @Test("Category raw values are correct")
    func categoryRawValues() {
        #expect(NewsCategory.all.rawValue == "Todas")
        #expect(NewsCategory.news.rawValue == "Últimas Notícias")
        #expect(NewsCategory.highlights.rawValue == "Destaques")
        #expect(NewsCategory.appletv.rawValue == "Apple TV")
        #expect(NewsCategory.reviews.rawValue == "Reviews")
        #expect(NewsCategory.rumors.rawValue == "Rumores")
        #expect(NewsCategory.tutorials.rawValue == "Tutoriais")
        #expect(NewsCategory.youtube.rawValue == "Vídeos")
        #expect(NewsCategory.podcast.rawValue == "MacMagazine no Ar")
    }

    // MARK: - Category CaseIterable Tests

    @Test("All category cases are present")
    func categoryAllCases() {
        let allCases = NewsCategory.allCases
        #expect(allCases.count == 9)
        #expect(allCases.contains(.all))
        #expect(allCases.contains(.news))
        #expect(allCases.contains(.highlights))
        #expect(allCases.contains(.appletv))
        #expect(allCases.contains(.reviews))
        #expect(allCases.contains(.rumors))
        #expect(allCases.contains(.tutorials))
        #expect(allCases.contains(.youtube))
        #expect(allCases.contains(.podcast))
    }

    // MARK: - Category Sendable Tests

    @Test("Category is Sendable across concurrency boundaries")
    func categoryIsSendable() async {
        // This test verifies that Category can be sent across concurrency boundaries
        let category = NewsCategory.highlights
        await sendCategory(category)
    }

    private func sendCategory(_ category: NewsCategory) async {}
}
