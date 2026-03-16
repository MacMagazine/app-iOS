import AnalyticsLibrary
import FeedLibrary
import MacMagazineLibrary
import SwiftUI
import WidgetKit

struct WidgetView: View {
    @EnvironmentObject private var analytics: AnalyticsManager
    @Environment(\.widgetFamily) var widgetFamily
    var entry: WidgetEntry
    var content: [WidgetData] { entry.posts }

    var body: some View {
        Group {
            if content.isEmpty {
                Text("Nenhum conteúdo disponível.")
                    .font(.headline)
            } else {
                switch widgetFamily {
                case .systemMedium: content(quantity: 2)
                case .systemLarge: content(quantity: 3)
                case .systemSmall,
                        .accessoryRectangular,
                        .accessoryInline:
                    WidgetElementView(post: content[0])
                        .trackScreen(AnalyticsConstants.Screen.widget(widgetFamily.description).name, analytics: analytics)

                case .systemExtraLarge, .accessoryCircular:
                    Text("Tamanho incompatível.")

                @unknown default:
                    Text("Tamanho incompatível.")
                }
            }
        }
    }

    private func content(quantity: Int) -> some View {
        ForEach(0 ..< min(quantity, content.count),
                id: \.self) { index in
            WidgetElementView(post: content[index])
        }.header(title: "Últimas notícias", spacing: widgetFamily.spacing)
        .trackScreen(AnalyticsConstants.Screen.widget(widgetFamily.description).name, analytics: analytics)
    }
}

extension WidgetFamily {
    var spacing: CGFloat {
        switch self {
        case .systemMedium: 8
        case .systemLarge: 4
        default: 0
        }
    }
}
