import SwiftUI
import WidgetKit

struct WatchWidgetModel: TimelineEntry {
    let date: Date
    let postId: String?
    let postTitle: String
    let postDate: Date?
}
