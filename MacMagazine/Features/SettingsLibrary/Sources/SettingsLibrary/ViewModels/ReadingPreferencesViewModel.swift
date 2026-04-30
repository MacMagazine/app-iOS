import Foundation
import MacMagazineLibrary
import StorageLibrary
import SwiftData

@Observable
final class ReadingPreferencesViewModel {
    var postRead: Bool = true
    var storage: Database?
    var models: [any PersistentModel.Type] = []
}

extension ReadingPreferencesViewModel {
    @MainActor
    func set(
        storage: Database?,
        models: [any PersistentModel.Type]
    ) {
        self.storage = storage
        self.models = models
        self.postRead = storage?.settings?.postRead ?? true
    }
}

extension ReadingPreferencesViewModel {
    @MainActor
    func change(postRead: Bool) async {
        storage?.update(postRead: postRead)
    }

    @MainActor
    func markAllAsRead() {
        let context = storage?.sharedModelContainer.mainContext
        models.forEach {
            ($0 as? any ModelReadable.Type)?.markAllAsRead(using: context)
        }
    }
}
