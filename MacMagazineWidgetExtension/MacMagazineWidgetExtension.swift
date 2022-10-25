//
//  MacMagazineWidgetExtension.swift
//  MacMagazineWidgetExtension
//
//  Created by Ailton Vieira Pinto Filho on 16/01/21.
//  Copyright © 2021 MacMagazine. All rights reserved.
//

import SwiftUI
import WidgetKit

@main
struct MacMagazineWidgetExtension: Widget {
    let kind: String = "MacMagazineRecentPostsWidget"

    private var supportedFamilies: [WidgetFamily] {
#if os(iOS)
        if #available(iOS 16, *) {
            return [.accessoryRectangular,
                    .accessoryInline,
                    .accessoryCircular,
                    .systemSmall,
                    .systemMedium,
					.systemLarge]
        } else {
            return [.systemSmall,
                    .systemMedium]
        }
#else
        return [.systemSmall,
                .systemMedium]
#endif
        }

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: RecentPostsProvider()) { entry in
            RecentPostsWidget(entry: entry)
        }
        .configurationDisplayName("MacMagazine")
        .description("Confira nossos últimos posts!")
        .supportedFamilies(supportedFamilies)
    }
}

struct MacMagazineWidgetExtension_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            if #available(iOSApplicationExtension 16.0, *) {
                RecentPostsWidget(entry: RecentPostsEntry(date: Date(), posts: [.placeholder]))
                    .previewContext(WidgetPreviewContext(family: .accessoryRectangular))
                    .previewDisplayName("Rectangular")
                RecentPostsWidget(entry: RecentPostsEntry(date: Date(), posts: [.placeholder]))
                    .previewContext(WidgetPreviewContext(family: .accessoryInline))
                    .previewDisplayName("Inline")
                RecentPostsWidget(entry: RecentPostsEntry(date: Date(), posts: [.placeholder]))
                    .previewContext(WidgetPreviewContext(family: .accessoryCircular))
                    .previewDisplayName("Circular")
            }
            RecentPostsWidget(entry: RecentPostsEntry(date: Date(), posts: [.placeholder]))
                .previewContext(WidgetPreviewContext(family: .systemSmall))
                .previewDisplayName("Small")
			RecentPostsWidget(entry: RecentPostsEntry(date: Date(), posts: [.placeholder, .placeholder, .placeholder]))
				.previewContext(WidgetPreviewContext(family: .systemLarge))
				.previewDisplayName("Large")
        }
    }
}
