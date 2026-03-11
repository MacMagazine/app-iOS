import MacMagazineLibrary
@testable import MacMagazineUILibrary
import Testing

// MARK: - NewsCategory Style Mapping

@Suite("NewsCategory Style Mapping")
struct NewsCategoryStyleTests {

    @Test("Highlights category maps to highlight style")
    func highlightsStyle() {
        #expect(NewsCategory.highlights.style == .highlight)
    }

    @Test("Podcast category maps to glass style")
    func podcastStyle() {
        #expect(NewsCategory.podcast.style == .glass)
    }

    @Test("YouTube category maps to glass style")
    func youtubeStyle() {
        #expect(NewsCategory.youtube.style == .glass)
    }

    @Test("News category maps to leadingImage style")
    func newsStyle() {
        #expect(NewsCategory.news.style == .leadingImage)
    }

    @Test("All category maps to leadingImage style")
    func allStyle() {
        #expect(NewsCategory.all.style == .leadingImage)
    }

    @Test("AppleTV category maps to leadingImage style")
    func appleTVStyle() {
        #expect(NewsCategory.appletv.style == .leadingImage)
    }

    @Test("Reviews category maps to leadingImage style")
    func reviewsStyle() {
        #expect(NewsCategory.reviews.style == .leadingImage)
    }

    @Test("Rumors category maps to leadingImage style")
    func rumorsStyle() {
        #expect(NewsCategory.rumors.style == .leadingImage)
    }

    @Test("Tutorials category maps to leadingImage style")
    func tutorialsStyle() {
        #expect(NewsCategory.tutorials.style == .leadingImage)
    }
}

// MARK: - Most Relevant Category Resolution

@Suite("Most Relevant Category Resolution")
struct MostRelevantCategoryTests {

    @Test("Highlights has highest priority over all others")
    func highlightsHighestPriority() {
        let categories: [NewsCategory] = [.news, .highlights, .reviews, .rumors]
        #expect(categories.mostRelevant == .highlights)
    }

    @Test("AppleTV beats reviews, rumors, tutorials, news")
    func appleTVPriority() {
        let categories: [NewsCategory] = [.news, .appletv, .reviews, .rumors]
        #expect(categories.mostRelevant == .appletv)
    }

    @Test("Reviews beats rumors, tutorials, news")
    func reviewsPriority() {
        let categories: [NewsCategory] = [.rumors, .reviews, .tutorials, .news]
        #expect(categories.mostRelevant == .reviews)
    }

    @Test("Rumors beats tutorials and news")
    func rumorsPriority() {
        let categories: [NewsCategory] = [.news, .rumors, .tutorials]
        #expect(categories.mostRelevant == .rumors)
    }

    @Test("Tutorials beats news")
    func tutorialsPriority() {
        let categories: [NewsCategory] = [.news, .tutorials]
        #expect(categories.mostRelevant == .tutorials)
    }

    @Test("News is lowest priority")
    func newsLowestPriority() {
        let categories: [NewsCategory] = [.news]
        #expect(categories.mostRelevant == .news)
    }

    @Test("Empty array returns .all as fallback")
    func emptyReturnsAll() {
        let categories: [NewsCategory] = []
        #expect(categories.mostRelevant == .all)
    }

    @Test("Single highlight returns highlight")
    func singleHighlight() {
        let categories: [NewsCategory] = [.highlights]
        #expect(categories.mostRelevant == .highlights)
    }

    @Test("Categories not in priority map return first element via min")
    func unknownCategoriesReturnFirst() {
        let categories: [NewsCategory] = [.podcast, .youtube]
        #expect(categories.mostRelevant == .podcast)
    }

    @Test("Priority order is highlights > appletv > reviews > rumors > tutorials > news")
    func fullPriorityOrder() {
        let all: [NewsCategory] = [.news, .tutorials, .rumors, .reviews, .appletv, .highlights]
        #expect(all.mostRelevant == .highlights)

        let withoutHighlights: [NewsCategory] = [.news, .tutorials, .rumors, .reviews, .appletv]
        #expect(withoutHighlights.mostRelevant == .appletv)

        let withoutAppleTV: [NewsCategory] = [.news, .tutorials, .rumors, .reviews]
        #expect(withoutAppleTV.mostRelevant == .reviews)

        let withoutReviews: [NewsCategory] = [.news, .tutorials, .rumors]
        #expect(withoutReviews.mostRelevant == .rumors)

        let withoutRumors: [NewsCategory] = [.news, .tutorials]
        #expect(withoutRumors.mostRelevant == .tutorials)

        let onlyNews: [NewsCategory] = [.news]
        #expect(onlyNews.mostRelevant == .news)
    }
}

// MARK: - CardContentType Categories & Style

@Suite("CardContentType Derived Properties")
struct CardContentTypeTests {

    @Test("News type returns its own categories")
    func newsTypeCategories() {
        let type = CardContentType.news(categories: [.highlights, .news], style: nil)
        #expect(type.categories == [.highlights, .news])
    }

    @Test("Podcast type returns podcast category")
    func podcastTypeCategories() {
        let type = CardContentType.podcast(duration: "45:00")
        #expect(type.categories == [.podcast])
    }

    @Test("Video type returns youtube category")
    func videoTypeCategories() {
        let type = CardContentType.video(views: "1K", likes: "100", duration: "10:00")
        #expect(type.categories == [.youtube])
    }

    @Test("News type style returns explicit style when set")
    func newsTypeExplicitStyle() {
        let type = CardContentType.news(categories: [.news], style: .glass)
        #expect(type.style == .glass)
    }

    @Test("News type style returns nil when not set")
    func newsTypeNilStyle() {
        let type = CardContentType.news(categories: [.news], style: nil)
        #expect(type.style == nil)
    }

    @Test("Podcast type style is always glass")
    func podcastTypeStyle() {
        let type = CardContentType.podcast(duration: "30:00")
        #expect(type.style == .glass)
    }

    @Test("Video type style is always glass")
    func videoTypeStyle() {
        let type = CardContentType.video(views: "500", likes: "50", duration: "5:00")
        #expect(type.style == .glass)
    }

    // MARK: - Card Dispatch Logic

    @Test("Highlight news dispatches to glass/highlight card via mostRelevant")
    func highlightNewsDispatch() {
        let type = CardContentType.news(categories: [.highlights, .news], style: nil)
        let resolvedStyle = type.categories.mostRelevant.style
        #expect(resolvedStyle == .highlight)
    }

    @Test("Regular news dispatches to leadingImage card via mostRelevant")
    func regularNewsDispatch() {
        let type = CardContentType.news(categories: [.news], style: nil)
        let resolvedStyle = type.categories.mostRelevant.style
        #expect(resolvedStyle == .leadingImage)
    }

    @Test("MMTV video news dispatches to glass card via mostRelevant")
    func mmtvNewsDispatch() {
        let type = CardContentType.news(categories: [.youtube], style: nil)
        let resolvedStyle = type.categories.mostRelevant.style
        #expect(resolvedStyle == .glass)
    }

    @Test("Podcast content type always routes to glass")
    func podcastContentRouting() {
        let type = CardContentType.podcast(duration: "1:00:00")
        let resolvedStyle = type.categories.mostRelevant.style
        #expect(resolvedStyle == .glass)
        #expect(type.style == .glass)
    }
}
