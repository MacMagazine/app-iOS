import Foundation
import MacMagazineLibrary

extension Array where Element == String {
    var toNewsCategory: NewsCategory {
        let categories = [
            ("NewsCategoryAll", NewsCategory.all),
            ("NewsCategoryNews", NewsCategory.news),
            ("NewsCategoryHighlights", NewsCategory.highlights),
            ("NewsCategoryAppleTV", NewsCategory.appletv),
            ("NewsCategoryReviews", NewsCategory.reviews),
            ("NewsCategoryRumors", NewsCategory.rumors),
            ("NewsCategoryTutorials", NewsCategory.tutorials),
            ("NewsCategoryMMTV", NewsCategory.youtube),
            ("NewsCategoryPodcast", NewsCategory.podcast)
        ]
        var response = NewsCategory.all
        for category in categories where self.contains(category.0) {
            response = category.1
        }
        return response
    }
}
