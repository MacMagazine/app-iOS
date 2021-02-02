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

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: RecentPostsProvider()) { entry in
            RecentPostsWidget(entry: entry)
        }
        .configurationDisplayName("MacMagazine")
        .description("Confira nossos últimos posts!")
    }
}

struct MacMagazineWidgetExtension_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            RecentPostsWidget(entry: RecentPostsEntry(date: Date(), posts: []))
                .previewContext(WidgetPreviewContext(family: .systemSmall))
        }
    }
}
