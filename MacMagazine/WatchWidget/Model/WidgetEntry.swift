import FeedLibrary
import Foundation
import WidgetKit

struct WidgetEntry: TimelineEntry {
    let date: Date
    let post: WidgetData
}

extension WidgetData {
    init(
        postId: String,
        title: String,
        pubDate: Date
    ) {
        self.init(
            postId: postId,
            title: title,
            thumbnail: "",
            pubDate: pubDate,
            link: ""
        )
    }
}

extension WidgetData {
    static var placeholder = WidgetData(
        postId: "1122438",
        title: "Apple TV: assista a “O Natal do Charlie Brown” grátis em 13 e 14 de dezembro",
        pubDate: Date()
    )
}
