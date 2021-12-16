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
        Group {
            if content.isEmpty {
                Text("Nenhum conteúdo disponível.")
                    .font(.headline)
                    .padding()
            } else {
                switch widgetFamily {
                case .systemSmall:
                    PostCell(post: content[0])

                case .systemMedium:
                    VStack(spacing: 1) {
                        ForEach(0 ..< min(2, content.count)) { index in
                            PostCell(post: content[index])
                        }
                    }

                case .systemLarge:
                    VStack(spacing: 1) {
                        ForEach(0 ..< min(3, content.count)) { index in
                            PostCell(post: content[index])
                        }
                    }

                case .systemExtraLarge:
                    Text("Tamanho incompatível.")

                @unknown default:
                    Text("Tamanho incompatível.")
                }
            }
        }.background(Color.white)
    }
}

struct RecentPostsWidget_Previews: PreviewProvider {
    static var previews: some View {
        RecentPostsWidget(entry: RecentPostsEntry(date: Date(), posts: [.placeholder, .placeholder, .placeholder]))
            .previewContext(WidgetPreviewContext(family: .systemLarge))
            .environment(\.sizeCategory, .extraLarge)
    }
}
