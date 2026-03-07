import Foundation
import MacMagazineLibrary

private let filterKeyToCategory: [String: NewsCategory] = {
    var map = [String: NewsCategory]()
    for category in NewsCategory.allCases {
        map[category.filterKey] = category
    }
    return map
}()

public extension Array where Element == String {
    var toNewsCategory: [NewsCategory] {
        compactMap { filterKeyToCategory[$0] }
    }
}
