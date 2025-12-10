import FeedLibrary
import Foundation
import WidgetKit

struct RecentPostsEntry: TimelineEntry {
    let date: Date
    let posts: [WidgetData]
}
