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
    WatchWidgetModel(
        date: .now,
        postId: UUID().uuidString,
        postTitle: "Apple lança atualização do watchOS",
        postDate: .now.addingTimeInterval(-60 * 25)
    )
}

#Preview("Corner", as: .accessoryCorner) {
    WatchWidget()
} timeline: {
    WatchWidgetModel(
        date: .now,
        postId: UUID().uuidString,
        postTitle: "Apple lança atualização do watchOS",
        postDate: .now.addingTimeInterval(-60 * 25)
    )
}

#Preview("Inline", as: .accessoryInline) {
    WatchWidget()
} timeline: {
    WatchWidgetModel(
        date: .now,
        postId: UUID().uuidString,
        postTitle: "Apple lança atualização do watchOS",
        postDate: .now.addingTimeInterval(-60 * 25)
    )
}

#Preview("Rectangular", as: .accessoryRectangular) {
    WatchWidget()
} timeline: {
    WatchWidgetModel(
        date: .now,
        postId: UUID().uuidString,
        postTitle: "O melhor pedaço da maçã da internet, clique para ver mais!",
        postDate: .now.addingTimeInterval(-60 * 90)
    )
}
#endif
