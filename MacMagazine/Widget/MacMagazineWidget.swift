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
            RecentPostsWidget(entry: entry)
                .containerBackground(.fill.tertiary, for: .widget)
        }
        .configurationDisplayName("MacMagazine")
        .description("Confira nossos últimos posts!")
        .supportedFamilies(supportedFamilies)
        .contentMarginsDisabled()
    }
}

#Preview("Large", as: .systemLarge) {
    MacMagazineWidget()
} timeline: {
    RecentPostsEntry(date: Date(),
                     posts: [.placeholder, .placeholder, .placeholder])
}

#Preview("Rectangular", as: .accessoryRectangular) {
    MacMagazineWidget()
} timeline: {
    RecentPostsEntry(date: Date(),
                     posts: [.placeholder])
}

#Preview("Inline", as: .accessoryInline) {
    MacMagazineWidget()
} timeline: {
    RecentPostsEntry(date: Date(),
                     posts: [.placeholder])
}

#Preview("Circular", as: .accessoryCircular) {
    MacMagazineWidget()
} timeline: {
    RecentPostsEntry(date: Date(),
                     posts: [.placeholder])
}

#Preview("Small", as: .systemSmall) {
    MacMagazineWidget()
} timeline: {
    RecentPostsEntry(date: Date(),
                     posts: [.placeholder])
}

#Preview("Medium", as: .systemMedium) {
    MacMagazineWidget()
} timeline: {
    RecentPostsEntry(date: Date(),
                     posts: [.placeholder, .placeholder])
}
