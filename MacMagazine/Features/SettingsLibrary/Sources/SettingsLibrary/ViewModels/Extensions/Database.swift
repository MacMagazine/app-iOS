import Foundation
import MacMagazineLibrary
import StorageLibrary
import SwiftData

// MARK: - User options -

extension Database {
    @MainActor
    var settings: SettingsDB? {
        let settings = fetch(SettingsDB.self)
        if settings.count > 1 {
            for index in 1..<settings.count {
                context.delete(settings[index])
            }
        }
        return settings.first
    }

    @MainActor
    func update(mode: ColorScheme) {
        if let item = settings {
            item.mode = mode
        } else {
            context.insert(SettingsDB(mode: mode))
        }
        try? context.save()
    }

    @MainActor
    func update(appIcon: IconType) {
        if let item = settings {
            item.icon = appIcon
        } else {
            context.insert(SettingsDB(icon: appIcon))
        }
        try? context.save()
    }

    @MainActor
    func update(notification: String) {
        if let item = settings {
            item.notification = notification
        } else {
            context.insert(SettingsDB(notification: notification))
        }
        try? context.save()
    }

    @MainActor
    func update(postRead: Bool) {
        if let item = settings {
            item.postRead = postRead
        } else {
            context.insert(SettingsDB(postRead: postRead))
        }
        try? context.save()
    }

    @MainActor
    func update(countOnBadge: Bool) {
        if let item = settings {
            item.countOnBadge = countOnBadge
        } else {
            context.insert(SettingsDB(countOnBadge: countOnBadge))
        }
        try? context.save()
    }

    @MainActor
    func update(isPatrao: Bool) {
        let date = Calendar.current.date(byAdding: .day, value: isPatrao ? +30 : -1, to: Date()) ?? Date()
        if let item = settings {
            item.subscription = Subscription(isPatrao: isPatrao, expirationDate: date)
        } else {
            let subscription = Subscription(isPatrao: isPatrao, expirationDate: date)
            context.insert(SettingsDB(subscription: subscription))
        }
        try? context.save()
    }

    @MainActor
    func update(expirationDate: Date) {
        if let item = settings {
            item.subscription = Subscription(isPatrao: false, expirationDate: expirationDate)
        } else {
            let subscription = Subscription(isPatrao: false, expirationDate: expirationDate)
            context.insert(SettingsDB(subscription: subscription))
        }
        try? context.save()
    }
}

// MARK: - App options -

extension Database {
    @MainActor
    var customization: CustomizationDB? {
        let customization = fetch(CustomizationDB.self)
        if customization.count > 1 {
            for index in 1..<customization.count {
                context.delete(customization[index])
            }
        }
        return customization.first
    }

    @MainActor
    func update(tabs: [AppTabs]) {
        if let item = customization {
            item.tabs = tabs
        } else {
            context.insert(CustomizationDB(tabs: tabs))
        }
        try? context.save()
    }

    @MainActor
    func update(social: [Social]) {
        if let item = customization {
            item.social = social
        } else {
            context.insert(CustomizationDB(social: social))
        }
        try? context.save()
    }

    @MainActor
    func update(news: [News]) {
        if let item = customization {
            item.news = news
        } else {
            context.insert(CustomizationDB(news: news))
        }
        try? context.save()
    }
}
