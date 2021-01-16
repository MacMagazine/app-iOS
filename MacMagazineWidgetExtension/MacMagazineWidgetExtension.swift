//
//  MacMagazineWidgetExtension.swift
//  MacMagazineWidgetExtension
//
//  Created by Ailton Vieira Pinto Filho on 16/01/21.
//  Copyright © 2021 MacMagazine. All rights reserved.
//

import WidgetKit
import SwiftUI
import Intents

struct SimpleEntry: TimelineEntry {
    let date: Date
    let configuration: ConfigurationIntent
}

struct MacMagazineWidgetExtensionEntryView : View {
    @Environment(\.widgetFamily) var widgetFamily
    var entry: SimpleEntry

    var body: some View {
        switch widgetFamily {
        case .systemSmall:
            PostCell()
        case .systemMedium:
            Text("medium")
        case .systemLarge:
            Text("large")
        @unknown default:
            Text("other size")
        }
    }
}

@main
struct MacMagazineWidgetExtension: Widget {
    let kind: String = "MacMagazineWidgetExtension"

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
            MacMagazineWidgetExtensionEntryView(entry: entry)
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
    }
}

struct MacMagazineWidgetExtension_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            MacMagazineWidgetExtensionEntryView(entry: SimpleEntry(date: Date(), configuration: ConfigurationIntent()))
                .previewContext(WidgetPreviewContext(family: .systemSmall))
        }
    }
}
