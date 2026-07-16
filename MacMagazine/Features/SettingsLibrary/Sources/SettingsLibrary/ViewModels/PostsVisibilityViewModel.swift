import Foundation
import MacMagazineLibrary
import StorageLibrary
import SwiftData
import UIComponentsLibrary

@Observable
final class PostsVisibilityViewModel {
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
}

extension PostsVisibilityViewModel {
    @MainActor
    func flush(cache: Cache) {
        Task { await CachedAsyncImage.clearCache() }

        switch cache {
        case .cleanAll: cleanAll()
        case .keepFavoritesAndStatus: keepFavoritesAndStatus()
        }
    }
}

private extension PostsVisibilityViewModel {
    @MainActor
    func cleanAll() {
        models.forEach {
            if ($0 as? SettingsDB.Type) == nil {
                try? storage?.sharedModelContainer.mainContext.delete(model: $0.self)
            }
        }
    }

    @MainActor
    func keepFavoritesAndStatus() {
        models.forEach {
            ($0 as? any ModelFavoritable.Type)?.deleteNonFavorites(using: storage?.sharedModelContainer.mainContext)
        }
    }
}
