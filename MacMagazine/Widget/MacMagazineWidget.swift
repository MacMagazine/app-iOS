import SwiftUI
import WidgetKit

struct MacMagazineWidget: Widget {
    let kind: String = "MacMagazineRecentPostsWidget"

    private var supportedFamilies: [WidgetFamily] {
#if os(iOS)
        return [.accessoryRectangular,
                .accessoryInline,
                .accessoryCircular,
                .systemSmall,
                .systemMedium,
                .systemLarge]
#else
        return [.systemSmall,
                .systemMedium]
#endif
    }

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: MacMagazineTimelineProvider()) { entry in
            WidgetView(entry: entry)
                .containerBackground(.fill.tertiary, for: .widget)
        }
        .configurationDisplayName("MacMagazine")
        .description("Confira nossos últimos posts!")
        .supportedFamilies(supportedFamilies)
        .contentMarginsDisabled()
    }
}

#Preview("Small", as: .systemSmall) {
    MacMagazineWidget()
} timeline: {
    WidgetEntry(date: Date(),
                posts: [.placeholder, .placeholder, .placeholder])
}

#Preview("Medium", as: .systemMedium) {
    MacMagazineWidget()
} timeline: {
    WidgetEntry(date: Date(),
                     posts: [.placeholder, .placeholder, .placeholder])
}

#Preview("large", as: .systemLarge) {
    MacMagazineWidget()
} timeline: {
    WidgetEntry(date: Date(),
                posts: [.placeholder, .placeholder, .placeholder])
}

#Preview("Rectangular", as: .accessoryRectangular) {
    MacMagazineWidget()
} timeline: {
    WidgetEntry(date: Date(),
                     posts: [.placeholder])
}

#Preview("Inline", as: .accessoryInline) {
    MacMagazineWidget()
} timeline: {
    WidgetEntry(date: Date(),
                     posts: [.placeholder])
}

#Preview("Circular", as: .accessoryCircular) {
    MacMagazineWidget()
} timeline: {
    WidgetEntry(date: Date(),
                     posts: [.placeholder])
}
