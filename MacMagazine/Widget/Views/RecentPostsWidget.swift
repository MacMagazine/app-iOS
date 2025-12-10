import FeedLibrary
import SwiftUI
import WidgetKit

struct RecentPostsWidget: View {
    @Environment(\.widgetFamily) var widgetFamily
    var entry: RecentPostsEntry
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
                        .accessoryCircular: WidgetView(post: content[0])

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
            WidgetView(post: content[index])
        }.header(title: "Últimas notícias")
    }
}

extension View {
    func header(title: String) -> some View {
        modifier(HeaderWidgetModifier(title: title))
    }
}

private struct HeaderWidgetModifier: ViewModifier {
    let title: String

    func body(content: Content) -> some View {
        VStack(spacing: 6) {
            HStack {
                Image("logo_color")
                    .resizable()
                    .widgetAccentedRenderingMode(.fullColor)
                    .scaledToFit()
                    .frame(width: 30, height: 30)

                Text(title)

                Spacer()
            }
            content
        }
    }
}
