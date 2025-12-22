import FeedLibrary
import SwiftUI
import WidgetKit

struct WatchWidget: Widget {
    let kind: String = "WatchWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(
            kind: kind,
            provider: WatchWidgetProvider()
        ) { entry in
            WatchWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("MacMagazine")
        .description("Acesso rápido às notícias do MacMagazine.")
        .supportedFamilies([
            .accessoryCircular,
            .accessoryCorner,
            .accessoryInline,
            .accessoryRectangular
        ])
    }
}

#if DEBUG

#Preview("Circular", as: .accessoryCircular) {
    WatchWidget()
} timeline: {
    WidgetEntry(
        date: .now,
        post: WidgetData(
            postId: UUID().uuidString,
            title: "Apple lança atualização do watchOS",
            pubDate: .now.addingTimeInterval(-60 * 25)
        )
    )
}

#Preview("Corner", as: .accessoryCorner) {
    WatchWidget()
} timeline: {
    WidgetEntry(
        date: .now,
        post: WidgetData(
            postId: UUID().uuidString,
            title: "Apple lança atualização do watchOS",
            pubDate: .now.addingTimeInterval(-60 * 25)
        )
    )
}

#Preview("Inline", as: .accessoryInline) {
    WatchWidget()
} timeline: {
    WidgetEntry(
        date: .now,
        post: WidgetData(
            postId: UUID().uuidString,
            title: "Apple lança atualização do watchOS",
            pubDate: .now.addingTimeInterval(-60 * 25)
        )
    )
}

#Preview("Rectangular", as: .accessoryRectangular) {
    WatchWidget()
} timeline: {
    WidgetEntry(
        date: .now,
        post: WidgetData(
            postId: UUID().uuidString,
            title: "Apple lança atualização do watchOS",
            pubDate: .now.addingTimeInterval(-60 * 25)
        )
    )
}
#endif
