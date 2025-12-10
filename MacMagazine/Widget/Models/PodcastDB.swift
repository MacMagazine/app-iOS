import Foundation
import SwiftData

@Model
final class WidgetDataDB {
    var postId: String = ""
    var title: String = ""

    init(
        postId: String = "",
        title: String = "",
    ) {
        self.postId = postId
        self.title = title
    }
}
