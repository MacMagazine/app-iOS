import Foundation
import SwiftData

@Model
public final class CustomizationDB {
    var tabs: [AppTabs] = AppTabs.allCases
    var news: [News] = News.allCases
    var social: [Social] = Social.allCases

    init(
         tabs: [AppTabs] = AppTabs.allCases,
         social: [Social] = Social.allCases,
         news: [News] = News.allCases
    ) {
        self.tabs = tabs
        self.social = social
        self.news = news
    }
}
