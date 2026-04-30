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
    public static func deduplicate(using context: ModelContext?) {
        let descriptor = FetchDescriptor<SettingsDB>()
        guard let context,
              let data = try? context.fetch(descriptor) else { return }

        let recordsToDelete = data
            .sorted { $0.modifiedAt > $1.modifiedAt }
            .dropFirst()

        recordsToDelete.forEach { context.delete($0) }
        try? context.save()
    }
}
