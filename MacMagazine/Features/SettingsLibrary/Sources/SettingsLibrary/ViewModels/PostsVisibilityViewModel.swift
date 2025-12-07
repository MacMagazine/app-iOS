import Combine
import Foundation
import StorageLibrary

final class PostsVisibilityViewModel: ObservableObject {
    @Published var cache: Cache?
    @Published var postRead = true
    @Published var countOnBadge = false

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
