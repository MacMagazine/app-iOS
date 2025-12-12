import FeedLibrary
import Foundation
import WidgetKit

struct WidgetEntry: TimelineEntry {
    let date: Date
    let posts: [WidgetData]
}
