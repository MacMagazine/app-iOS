import AppIntents
import SwiftUI
import WidgetKit

struct WatchWidgetModel: TimelineEntry {
    let date: Date
    let configuration: AppIntent

    let postId: String?
    let postTitle: String
    let postDate: Date?
}
