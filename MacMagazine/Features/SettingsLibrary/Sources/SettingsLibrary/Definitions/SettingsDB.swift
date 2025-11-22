import Foundation
import SwiftData

@Model
final public class SettingsDB {
    var mode = ColorScheme.system
    var icon = IconType.normal
    var notification: String = PushPreferences.all.rawValue
    var postRead: Bool = true
    var countOnBadge: Bool = false
    var subscription: Subscription = Subscription(isPatrao: false, expirationDate: Date())
    var tabs: [AppTabs] = AppTabs.allCases
    var news: [News] = News.allCases
    var social: [Social] = Social.allCases

    init(mode: ColorScheme = .system,
         icon: IconType = .normal,
         notification: String = PushPreferences.all.rawValue,
         postRead: Bool = true,
         countOnBadge: Bool = false,
         subscription: Subscription? = nil,
         tabs: [AppTabs] = AppTabs.allCases,
         social: [Social] = Social.allCases,
         news: [News] = News.allCases) {
        self.mode = mode
        self.icon = icon
        self.notification = notification
        self.postRead = postRead
        self.countOnBadge = countOnBadge
        self.tabs = tabs
        self.social = social
        self.news = news

        let date = Calendar.current.date(byAdding: .day, value: -1, to: Date()) ?? Date()
        self.subscription = subscription ?? Subscription(isPatrao: false, expirationDate: date)
    }
}
