import Foundation
import MacMagazineLibrary
import StorageLibrary
import SwiftData

@Observable
final class PostsVisibilityViewModel {
    var cache: Cache?
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
        countOnBadge = storage?.settings?.countOnBadge ?? false
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
        case .cleanAll: cleanAll()
        case .keepFavoritesAndStatus: keepFavoritesAndStatus()
        case .allRead: markAllPostAsRead()
        }
    }
}

private extension PostsVisibilityViewModel {
    @MainActor
    func cleanAll() {
        models.forEach {
            try? storage?.sharedModelContainer.mainContext.delete(model: $0.self)
        }
    }

    @MainActor
    func keepFavoritesAndStatus() {
        models.forEach {
            ($0 as? any ModelFavoritable.Type)?.deleteNonFavorites(using: storage?.sharedModelContainer.mainContext)
        }
    }

    @MainActor
    func markAllPostAsRead() {
        models.forEach {
            ($0 as? any ModelReadable.Type)?.maskAsRead(using: storage?.sharedModelContainer.mainContext)
        }
    }
}
