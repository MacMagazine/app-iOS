import Testing
@testable import FeedLibrary

@Suite("Category Tests")
struct CategoryTests {

    // MARK: - Category Query Tests

    @Test("Highlights category has correct query")
    func highlightsCategoryQuery() {
        // Given
        let category = Category.highlights

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
        let category = Category.news

        // When
        let query = category.query

        // Then
        #expect(query == nil)
    }

    @Test("All category has nil query")
    func allCategoryQuery() {
        // Given
        let category = Category.all

        // When
        let query = category.query

        // Then
        #expect(query == nil)
    }

    @Test("Podcast category has correct query")
    func podcastCategoryQuery() {
        // Given
        let category = Category.podcast

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
        let category = Category.youtube

        // When
        let query = category.query

        // Then
        #expect(query != nil)
        #expect(query?.0 == "cat")
        #expect(query?.1 == "18")
    }

    @Test("AppleTV category has correct query")
    func appleTVCategoryQuery() {
        // Given
        let category = Category.appletv

        // When
        let query = category.query

        // Then
        #expect(query != nil)
        #expect(query?.0 == "tag")
        #expect(query?.1 == "apple-tv-plus")
    }

    @Test("Reviews category has correct query")
    func reviewsCategoryQuery() {
        // Given
        let category = Category.reviews

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
        let category = Category.tutoriais

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
        let category = Category.rumors

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
        #expect(Category.all.rawValue == "Todas")
        #expect(Category.news.rawValue == "Últimas Notícias")
        #expect(Category.highlights.rawValue == "Destaques")
        #expect(Category.appletv.rawValue == "Novidades Apple TV+")
        #expect(Category.reviews.rawValue == "Reviews")
        #expect(Category.rumors.rawValue == "Rumores")
        #expect(Category.tutoriais.rawValue == "Tutoriais")
        #expect(Category.youtube.rawValue == "Vídeos")
        #expect(Category.podcast.rawValue == "MacMagazine no Ar")
    }

    // MARK: - Category CaseIterable Tests

    @Test("All category cases are present")
    func categoryAllCases() {
        let allCases = Category.allCases
        #expect(allCases.count == 9)
        #expect(allCases.contains(.all))
        #expect(allCases.contains(.news))
        #expect(allCases.contains(.highlights))
        #expect(allCases.contains(.appletv))
        #expect(allCases.contains(.reviews))
        #expect(allCases.contains(.rumors))
        #expect(allCases.contains(.tutoriais))
        #expect(allCases.contains(.youtube))
        #expect(allCases.contains(.podcast))
    }

    // MARK: - Category Sendable Tests

    @Test("Category is Sendable across concurrency boundaries")
    func categoryIsSendable() async {
        // This test verifies that Category can be sent across concurrency boundaries
        let category = Category.highlights
        await sendCategory(category)
    }

    private func sendCategory(_ category: Category) async {}
}
