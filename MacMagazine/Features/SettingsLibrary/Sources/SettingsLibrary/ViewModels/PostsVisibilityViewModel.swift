import Foundation
import StorageLibrary
import SwiftData

@Observable
final class PostsVisibilityViewModel {
    var cache: Cache?
    var postRead = true
    var countOnBadge = false

    var storage: Database?
    var models: [any PersistentModel.Type] = []
}

extension PostsVisibilityViewModel {
    func set(
        storage: Database?,
        models: [any PersistentModel.Type]
    ) {
        self.storage = storage
        self.models = models
    }

    @MainActor
    func get() {
        postRead = storage?.settings?.postRead ?? true
        countOnBadge = storage?.settings?.countOnBadge ?? false
    }

    @MainActor
    func change(postRead: Bool) async {
        storage?.update(postRead: postRead)
    }

    @MainActor
    func change(countOnBadge: Bool) async {
        storage?.update(countOnBadge: countOnBadge)
    }
}

extension PostsVisibilityViewModel {
    @MainActor
    func flush(cache: Cache) {
        switch cache {
        case .cleanAll:
            models.forEach {
                try? storage?.sharedModelContainer.mainContext.delete(model: $0.self)
            }

        case .keepFavoritesAndStatus: break

        default: break
        }
    }
}
