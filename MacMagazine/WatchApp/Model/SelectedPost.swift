import SwiftUI
import FeedLibrary

// MARK: - Navigation Payload

struct SelectedPost: Hashable, Identifiable {
    let id: String
    let post: FeedDB

    init(post: FeedDB) {
        id = post.postId
        self.post = post
    }
}
