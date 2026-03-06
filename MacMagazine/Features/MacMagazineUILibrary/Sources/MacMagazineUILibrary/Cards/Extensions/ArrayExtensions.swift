import Foundation
import MacMagazineLibrary

private let categoryPriority: [NewsCategory: Int] = [
    .highlights: 0,
    .appletv: 1,
    .reviews: 2,
    .rumors: 3,
    .tutorials: 4,
    .news: 5
]

public extension Array where Element == NewsCategory {
    var mostRelevant: NewsCategory {
        self.min(by: {
            (categoryPriority[$0] ?? Int.max) < (categoryPriority[$1] ?? Int.max)
        }) ?? .all
    }
}
