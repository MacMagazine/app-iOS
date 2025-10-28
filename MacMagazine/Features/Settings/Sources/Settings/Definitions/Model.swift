import Foundation
import SwiftData

@Model
final public class SettingsDB {
    var mode: ColorScheme
    var icon: IconType
    var notification: String
    var postRead: Bool
    var countOnBadge: Bool
    var subscription: Subscription

    init(mode: ColorScheme = .system,
         icon: IconType = .normal,
         notification: String = PushPreferences.all.rawValue,
         postRead: Bool = true,
         countOnBadge: Bool = false,
         subscription: Subscription? = nil) {
        self.mode = mode
        self.icon = icon
        self.notification = notification
        self.postRead = postRead
        self.countOnBadge = countOnBadge

        let date = Calendar.current.date(byAdding: .day, value: -1, to: Date()) ?? Date()
        self.subscription = subscription ?? Subscription(isPatrao: false, expirationDate: date)
    }
}
