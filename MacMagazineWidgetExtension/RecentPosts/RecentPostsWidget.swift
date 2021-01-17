//
//  RecentPostsWidget.swift
//  MacMagazineWidgetExtensionExtension
//
//  Created by Ailton Vieira Pinto Filho on 16/01/21.
//  Copyright © 2021 MacMagazine. All rights reserved.
//

import SwiftUI
import WidgetKit

struct RecentPostsWidget : View {
    @Environment(\.widgetFamily) var widgetFamily
    var entry: RecentPostsEntry
    
    var content: [PostData] { entry.posts }

    var body: some View {
        if content.isEmpty {
            Text("Nenhum conteúdo")
                .font(.subheadline)
                .padding()
        } else {
            switch widgetFamily {
            case .systemSmall:
                PostCell(post: content[0])
            case .systemMedium:
                Text("medium")
            case .systemLarge:
                Text("large")
            @unknown default:
                Text("other size")
            }
        }
    }
}

struct RecentPostsWidget_Previews: PreviewProvider {
    static var previews: some View {
        RecentPostsWidget(entry: RecentPostsEntry(date: Date(), configuration: ConfigurationIntent(), posts: []))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
