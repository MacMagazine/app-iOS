import Foundation
import StorageLibrary

@Observable
final class PostsVisibilityViewModel {
    var cache: Cache?
    var postRead = true
    var countOnBadge = false

    var storage: Database?
}

extension PostsVisibilityViewModel {
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
