import Foundation
import StorageLibrary
import SwiftData

// MARK: - User options -

extension Database {
    @MainActor
    func get() -> SettingsDB? {
        fetch(SettingsDB.self).first
    }

    @MainActor
    func update(mode: ColorScheme) {
        if let item = get() {
            item.mode = mode
        } else {
            context.insert(SettingsDB(mode: mode))
        }
        try? context.save()
    }

    @MainActor
    func update(appIcon: IconType) {
        if let item = get() {
            item.icon = appIcon
        } else {
            context.insert(SettingsDB(icon: appIcon))
        }
        try? context.save()
    }

    @MainActor
    func update(notification: String) {
        if let item = get() {
            item.notification = notification
        } else {
            context.insert(SettingsDB(notification: notification))
        }
        try? context.save()
    }

    @MainActor
    func update(postRead: Bool) {
        if let item = get() {
            item.postRead = postRead
        } else {
            context.insert(SettingsDB(postRead: postRead))
        }
        try? context.save()
    }

    @MainActor
    func update(countOnBadge: Bool) {
        if let item = get() {
            item.countOnBadge = countOnBadge
        } else {
            context.insert(SettingsDB(countOnBadge: countOnBadge))
        }
        try? context.save()
    }

    @MainActor
    func update(isPatrao: Bool) {
        let date = Calendar.current.date(byAdding: .day, value: isPatrao ? +30 : -1, to: Date()) ?? Date()
        if let item = get() {
            item.subscription = Subscription(isPatrao: isPatrao, expirationDate: date)
        } else {
            let subscription = Subscription(isPatrao: isPatrao, expirationDate: date)
            context.insert(SettingsDB(subscription: subscription))
        }
        try? context.save()
    }

    @MainActor
    func update(expirationDate: Date) {
        if let item = get() {
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
    func update(tabs: [AppTabs]) {
        if let item = get() {
            item.tabs = tabs
        } else {
            context.insert(SettingsDB(tabs: tabs))
        }
        try? context.save()
    }

    @MainActor
    func update(social: [Social]) {
        if let item = get() {
            item.social = social
        } else {
            context.insert(SettingsDB(social: social))
        }
        try? context.save()
    }

    @MainActor
    func update(news: [News]) {
        if let item = get() {
            item.news = news
        } else {
            context.insert(SettingsDB(news: news))
        }
        try? context.save()
    }
}
