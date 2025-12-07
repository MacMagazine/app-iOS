import Foundation
import OneSignalFramework
import StorageLibrary

@Observable
final class PushOptionsViewModel {
    var type: PushPreferences = .all
    var storage: Database?
}

extension PushOptionsViewModel {
    @MainActor
    func get() {
        type = PushPreferences(rawValue: storage?.settings?.notification ?? "") ?? .all
    }

    @MainActor
    func change(_ type: PushPreferences) async {
        storage?.update(notification: type.rawValue)
        OneSignal.User.addTag(key: "notification_preferences", value: type.rawValue)
    }
}
