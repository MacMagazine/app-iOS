import AppIntents
import SwiftUI
import WidgetKit

struct WatchWidgetModel: TimelineEntry {
    let date: Date
    let configuration: AppIntent

    let lastPostId: String?
    let lastPostTitle: String
    let lastPostDate: Date?
}
