import Foundation
import MacMagazineLibrary

extension Array where Element == String {
    var toNewsCategory: [NewsCategory] {
        var categories = [String]()
        var categoriesDict = [String: NewsCategory]()
        for category in NewsCategory.allCases {
            categories.append(category.filterKey)
            categoriesDict[category.filterKey] = category
        }
        let intersect = Array(Set(self).intersection(Set(categories)))
        return intersect.compactMap { categoriesDict[$0] }
    }
}
