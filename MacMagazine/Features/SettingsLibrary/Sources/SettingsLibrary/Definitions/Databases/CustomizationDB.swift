import Foundation
import SwiftData

@Model
public final class CustomizationDB {
    public var id: UUID = UUID()
    var tabs: [AppTabs] = AppTabs.allCases
    var news: [News] = News.allCases
    var social: [Social] = Social.allCases

    init(
        id: UUID = UUID(),
        tabs: [AppTabs] = AppTabs.allCases,
        social: [Social] = Social.allCases,
        news: [News] = News.allCases
    ) {
        self.id = id
        self.tabs = tabs
        self.social = social
        self.news = news
    }
}
