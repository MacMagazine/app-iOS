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
    /// Deletes every persisted object of each registered model type (except `SettingsDB`).
    ///
    /// Fetches and deletes objects individually rather than using `ModelContext.delete(model:)`.
    /// The type-erased batch delete issues an `NSBatchDeleteRequest`, which CloudKit-backed
    /// stores don't mirror to iCloud - locally deleted rows silently resurrect on the next
    /// sync. Per-object deletes participate in persistent history like any other change, so
    /// CloudKit tombstones them correctly.
    @MainActor
    func cleanAll() {
        let ctx = storage?.sharedModelContainer.mainContext
        models.forEach {
            if ($0 as? SettingsDB.Type) == nil {
                deleteAll(of: $0, in: ctx)
            }
        }
    }

    @MainActor
    func deleteAll<T: PersistentModel>(of type: T.Type, in ctx: ModelContext?) {
        guard let ctx else { return }
        let descriptor = FetchDescriptor<T>()
        if let items = try? ctx.fetch(descriptor) {
            items.forEach { ctx.delete($0) }
            try? ctx.save()
        }
    }

    @MainActor
    func keepFavoritesAndStatus() {
        models.forEach {
            ($0 as? any ModelFavoritable.Type)?.deleteNonFavorites(using: storage?.sharedModelContainer.mainContext)
        }
    }
}
