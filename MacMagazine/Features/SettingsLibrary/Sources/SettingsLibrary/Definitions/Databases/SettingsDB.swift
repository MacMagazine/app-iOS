import Foundation
import MacMagazineLibrary
import SwiftData

@Model
public final class SettingsDB: Equatable {
    public var id: UUID = UUID()
    var mode = ColorScheme.system
    var icon = IconType.normal
    var notification: String = PushPreferences.all.rawValue
    var postRead: Bool = true
    var subscription: Subscription = Subscription(isPatrao: false, expirationDate: Date())
    var modifiedAt: Date = Date()

    init(
        id: UUID = UUID(),
        mode: ColorScheme = .system,
        icon: IconType = .normal,
        notification: String = PushPreferences.all.rawValue,
        postRead: Bool = true,
        subscription: Subscription? = nil,
        modifiedAt: Date = Date()
    ) {
        self.id = id
        self.mode = mode
        self.icon = icon
        self.notification = notification
        self.postRead = postRead
        self.modifiedAt = modifiedAt

        let date = Calendar.current.date(byAdding: .day, value: -1, to: Date()) ?? Date()
        self.subscription = subscription ?? Subscription(isPatrao: false, expirationDate: date)
    }
}

extension SettingsDB {
    public static func == (lhs: SettingsDB, rhs: SettingsDB) -> Bool {
        lhs.id == rhs.id
    }
}

extension SettingsDB: ModelDuplicable {
    /// `.unique`/`#Unique` isn't supported with CloudKit, so every device can create its own
    /// row - merge the subscription across duplicates instead of letting the most recently
    /// modified one win outright.
    public static func deduplicate(using context: ModelContext?) {
        let descriptor = FetchDescriptor<SettingsDB>()
        guard let context,
              let data = try? context.fetch(descriptor),
              data.count > 1 else { return }

        let sorted = data.sorted { $0.modifiedAt > $1.modifiedAt }
        guard let survivor = sorted.first else { return }

        survivor.subscription = Subscription(
            isPatrao: data.contains { $0.subscription.isPatrao },
            expirationDate: data.map { $0.subscription.expirationDate }.max() ?? survivor.subscription.expirationDate
        )

        sorted.dropFirst().forEach { context.delete($0) }
        try? context.save()
    }
}
