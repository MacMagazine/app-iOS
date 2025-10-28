import Combine
import Foundation
import StorageLibrary

final public class PostsVisibilityViewModel: ObservableObject {
    @Published public var cache: Cache?
    @Published var postRead = true
    @Published var countOnBadge = false

    var storage: Database?

    public init() {}
}

extension PostsVisibilityViewModel {
    @MainActor
    func get() {
        postRead = storage?.get()?.postRead ?? true
        countOnBadge = storage?.get()?.countOnBadge ?? false
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
