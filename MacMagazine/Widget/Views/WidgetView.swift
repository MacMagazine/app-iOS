import FeedLibrary
import SwiftUI
import WidgetKit

struct WidgetView: View {
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
                        .accessoryInline,
                        .accessoryCircular: WidgetElementView(post: content[0])

                case .systemExtraLarge:
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
        }.header(title: "Últimas notícias")
    }
}
