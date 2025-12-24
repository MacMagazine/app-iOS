import Foundation
import MacMagazineLibrary

extension Array where Element == NewsCategory {
    var mostRelevant: NewsCategory {
        let categories = [
            NewsCategory.highlights: 0,
            NewsCategory.appletv: 1,
            NewsCategory.reviews: 2,
            NewsCategory.rumors: 3,
            NewsCategory.tutorials: 4,
            NewsCategory.news: 5
        ]

        let response = self.min(by: {
            (categories[$0] ?? Int.max) < (categories[$1] ?? Int.max)
        }) ?? .all

        return response
    }
}
