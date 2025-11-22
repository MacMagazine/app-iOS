import Foundation
import SwiftData

@Model
public final class SettingsDB {
    var mode = ColorScheme.system
    var icon = IconType.normal
    var notification: String = PushPreferences.all.rawValue
    var postRead: Bool = true
    var countOnBadge: Bool = false
    var subscription: Subscription = Subscription(isPatrao: false, expirationDate: Date())
    var tabs: [AppTabs] = AppTabs.allCases

    // New fields - stored as optional for migration compatibility
    // When nil, the computed properties return default values
    private var _news: [News]?
    private var _social: [Social]?

    var news: [News] {
        get { _news ?? News.allCases }
        set { _news = newValue }
    }

    var social: [Social] {
        get { _social ?? Social.allCases }
        set { _social = newValue }
    }

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
        self._social = social
        self._news = news

        let date = Calendar.current.date(byAdding: .day, value: -1, to: Date()) ?? Date()
        self.subscription = subscription ?? Subscription(isPatrao: false, expirationDate: date)
    }
}
