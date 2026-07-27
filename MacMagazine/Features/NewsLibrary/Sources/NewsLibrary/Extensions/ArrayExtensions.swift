import Foundation
import MacMagazineLibrary

private let filterKeyToCategory: [String: NewsCategory] = {
    var map = [String: NewsCategory]()
    for category in NewsCategory.allCases {
        map[category.filterKey] = category
        map[category.rawValue] = category
    }
    return map
}()

public extension Array where Element == String {
    var toNewsCategory: [NewsCategory] {
        var seen = Set<NewsCategory>()
        return compactMap { filterKeyToCategory[$0] }.filter { seen.insert($0).inserted }
    }
}
