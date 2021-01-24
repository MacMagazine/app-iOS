//
//  RecentPostsWidget.swift
//  MacMagazineWidgetExtensionExtension
//
//  Created by Ailton Vieira Pinto Filho on 16/01/21.
//  Copyright © 2021 MacMagazine. All rights reserved.
//

import SwiftUI
import WidgetKit

struct RecentPostsWidget: View {
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
                PostCell(post: content[0], style: .cover)
            case .systemMedium:
                VStack {
                    PostCell(post: content[0], style: .row)
                    PostCell(post: content[1], style: .row)
                }.padding()
            case .systemLarge:
                GeometryReader { geo in
                    VStack(spacing: 0) {
                        PostCell(post: content[0], style: .cover)
                            .frame(height: 0.5 * geo.size.height)
                        VStack {
                            PostCell(post: content[1], style: .row)
                            PostCell(post: content[2], style: .row)
                        }.padding()
                    }
                }
            @unknown default:
                Text("other size")
            }
        }
    }
}

struct RecentPostsWidget_Previews: PreviewProvider {
    static var previews: some View {
        RecentPostsWidget(entry: RecentPostsEntry(date: Date(), configuration: ConfigurationIntent(), posts: [.placeholder, .placeholder, .placeholder, .placeholder]))
            .previewContext(WidgetPreviewContext(family: .systemLarge))
    }
}
