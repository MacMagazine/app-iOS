import Combine
import Foundation
import OneSignalFramework
import StorageLibrary

final public class PushOptionsViewModel: ObservableObject {
    @Published var type: PushPreferences = .all
    var storage: Database?

    public init() {}
}

extension PushOptionsViewModel {
    @MainActor
    func get() {
        type = PushPreferences(rawValue: storage?.get()?.notification ?? "") ?? .all
    }

    @MainActor
    func change(_ type: PushPreferences) async {
        storage?.update(notification: type.rawValue)
        OneSignal.User.addTag(key: "notification_preferences", value: type.rawValue)
    }
}
