import Foundation
import SwiftData

@Model
public final class SettingsDB {
    public var id: UUID = UUID()
    var mode = ColorScheme.system
    var icon = IconType.normal
    var notification: String = PushPreferences.all.rawValue
    var postRead: Bool = true
    var countOnBadge: Bool = false
    var subscription: Subscription = Subscription(isPatrao: false, expirationDate: Date())

    init(
        id: UUID = UUID(),
        mode: ColorScheme = .system,
        icon: IconType = .normal,
        notification: String = PushPreferences.all.rawValue,
        postRead: Bool = true,
        countOnBadge: Bool = false,
        subscription: Subscription? = nil
    ) {
        self.id = id
        self.mode = mode
        self.icon = icon
        self.notification = notification
        self.postRead = postRead
        self.countOnBadge = countOnBadge

        let date = Calendar.current.date(byAdding: .day, value: -1, to: Date()) ?? Date()
        self.subscription = subscription ?? Subscription(isPatrao: false, expirationDate: date)
    }
}
