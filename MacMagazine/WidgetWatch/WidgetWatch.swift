import AppIntents
import SwiftUI
import WidgetKit

// MARK: - Entry

struct SimpleEntry: TimelineEntry {
    let date: Date
    let configuration: ConfigurationAppIntent

    let lastPostId: String?
    let lastPostTitle: String
    let lastPostDate: Date?
}

// MARK: - Provider

struct Provider: AppIntentTimelineProvider {

    func recommendations() -> [AppIntentRecommendation<ConfigurationAppIntent>] {
        [
            AppIntentRecommendation(
                intent: ConfigurationAppIntent(),
                description: "MacMagazine"
            )
        ]
    }

    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(
            date: .now,
            configuration: ConfigurationAppIntent(),
            lastPostId: UUID().uuidString,
            lastPostTitle: "Apple lança atualização do watchOS",
            lastPostDate: .now.addingTimeInterval(-60 * 25)
        )
    }

    func snapshot(
        for configuration: ConfigurationAppIntent,
        in context: Context
    ) async -> SimpleEntry {
        makeEntry(configuration: configuration)
    }

    func timeline(
        for configuration: ConfigurationAppIntent,
        in context: Context
    ) async -> Timeline<SimpleEntry> {

        let entry = makeEntry(configuration: configuration)

        let nextUpdate =
        Calendar.current.date(byAdding: .minute, value: 30, to: .now)
        ?? .now.addingTimeInterval(1800)

        return Timeline(entries: [entry], policy: .after(nextUpdate))
    }

    private func makeEntry(configuration: ConfigurationAppIntent) -> SimpleEntry {
        let snap = MacMagazineWidgetSharedStore.readSnapshot()

        return SimpleEntry(
            date: .now,
            configuration: configuration,
            lastPostId: snap?.postId,
            lastPostTitle: snap?.title ?? "MacMagazine",
            lastPostDate: snap?.date
        )
    }
}

// MARK: - Entry View

struct WidgetWatchEntryView: View {

    let entry: SimpleEntry
    @Environment(\.widgetFamily) private var family
    @Environment(\.widgetRenderingMode) private var renderingMode

    var body: some View {
        content
            .containerBackground(for: .widget) { Color.clear }
    }

    @ViewBuilder
    private var content: some View {
        switch family {
        case .accessoryCircular:
            circular
        case .accessoryCorner:
            corner
        case .accessoryInline:
            inline
        case .accessoryRectangular:
            rectangular
        @unknown default:
            EmptyView()
        }
    }
}

// MARK: - Layouts

private extension WidgetWatchEntryView {

    // ACCESSORY CIRCULAR
    var circular: some View {
        ZStack {
            AccessoryWidgetBackground()

            Image("logo_color")
                .resizable()
                .scaledToFit()
                .frame(width: 30, height: 30)
        }
        .widgetURL(URL(string: "macmagazine://news"))
        .accessibilityLabel("Abrir MacMagazine")
    }

    // ACCESSORY CORNER
    var corner: some View {
        Image(renderingMode == .fullColor ? "logo_color" : "logo_white")
            .resizable()
            .renderingMode(renderingMode == .fullColor ? .original : .template)
            .scaledToFit()
            .frame(width: 35, height: 35)
            .foregroundStyle(.primary)
            .widgetLabel {
                Text(entry.lastPostTitle)
                    .lineLimit(1)
            }
            .widgetURL(widgetPostURL())
            .accessibilityElement(children: .ignore)
            .accessibilityLabel("MacMagazine")
            .accessibilityValue("Última notícia: \(entry.lastPostTitle)")
            .accessibilityHint("Toque para abrir as notícias")
    }

    // ACCESSORY INLINE
    var inline: some View {
        Text("\(entry.lastPostTitle)")
            .widgetURL(widgetPostURL())
            .accessibilityLabel("MacMagazine")
            .accessibilityValue("Última notícia: \(entry.lastPostTitle)")
            .accessibilityHint("Toque para abrir as notícias")
    }

    // ACCESSORY RECTANGULAR
    var rectangular: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack(spacing: 6) {
                Image(renderingMode == .fullColor ? "logo_color" : "logo_white")
                    .resizable()
                    .renderingMode(renderingMode == .fullColor ? .original : .template)
                    .scaledToFit()
                    .frame(width: 18, height: 18)
                    .foregroundStyle(.primary)

                Text(relativePostTimeText(entry.lastPostDate))
                    .font(.footnote)
                    .foregroundStyle(.secondary)
                    .lineLimit(1)

                Spacer(minLength: 0)
            }

            Text(entry.lastPostTitle)
                .font(.callout)
                .lineLimit(2)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
        .containerBackground(for: .widget) { AccessoryWidgetBackground() }
        .widgetURL(widgetPostURL())
        .accessibilityElement(children: .combine)
        .accessibilityLabel("MacMagazine")
        .accessibilityValue(accessibilityValueForRectangular())
        .accessibilityHint("Toque para abrir as notícias")
    }

    func widgetPostURL() -> URL? {
        if let postId = entry.lastPostId, !postId.isEmpty {
            return URL(string: "macmagazine://news/post/\(postId)")
        }

        return URL(string: "macmagazine://news")
    }

    func relativePostTimeText(_ date: Date?) -> String {
        guard let date else { return "Atualizado recentemente" }

        let time = Self.timeFormatter.string(from: date)
        let calendar = Calendar.current

        if calendar.isDateInToday(date) {
            return "Hoje às \(time)"
        }

        if calendar.isDateInYesterday(date) {
            return "Ontem às \(time)"
        }

        return "\(Self.dayFormatter.string(from: date)) às \(time)"
    }

    func accessibilityValueForRectangular() -> String {
        let whenText = relativePostTimeText(entry.lastPostDate)
        return "\(whenText), \(entry.lastPostTitle)"
    }

    static let timeFormatter: DateFormatter = {
        let formatterDate = DateFormatter()
        formatterDate.locale = Locale(identifier: "pt_BR")
        formatterDate.dateFormat = "HH:mm"
        return formatterDate
    }()

    static let dayFormatter: DateFormatter = {
        let formatterDate = DateFormatter()
        formatterDate.locale = Locale(identifier: "pt_BR")
        formatterDate.dateFormat = "dd/MM"
        return formatterDate
    }()
}

// MARK: - Widget

struct WidgetWatch: Widget {

    let kind: String = "WidgetWatch"

    var body: some WidgetConfiguration {
        AppIntentConfiguration(
            kind: kind,
            intent: ConfigurationAppIntent.self,
            provider: Provider()
        ) { entry in
            WidgetWatchEntryView(entry: entry)
        }
        .configurationDisplayName("MacMagazine")
        .description("Acesso rápido às notícias do MacMagazine.")
        .supportedFamilies([
            .accessoryCircular,
            .accessoryCorner,
            .accessoryInline,
            .accessoryRectangular
        ])
    }
}

#if DEBUG

#Preview("Circular", as: .accessoryCircular) {
    WidgetWatch()
} timeline: {
    SimpleEntry(
        date: .now,
        configuration: ConfigurationAppIntent(),
        lastPostId: UUID().uuidString,
        lastPostTitle: "Apple lança atualização do watchOS",
        lastPostDate: .now.addingTimeInterval(-60 * 25)
    )
}

#Preview("Corner", as: .accessoryCorner) {
    WidgetWatch()
} timeline: {
    SimpleEntry(
        date: .now,
        configuration: ConfigurationAppIntent(),
        lastPostId: UUID().uuidString,
        lastPostTitle: "Apple lança atualização do watchOS",
        lastPostDate: .now.addingTimeInterval(-60 * 25)
    )
}

#Preview("Inline", as: .accessoryInline) {
    WidgetWatch()
} timeline: {
    SimpleEntry(
        date: .now,
        configuration: ConfigurationAppIntent(),
        lastPostId: UUID().uuidString,
        lastPostTitle: "Apple lança atualização do watchOS",
        lastPostDate: .now.addingTimeInterval(-60 * 25)
    )
}

#Preview("Rectangular",as: .accessoryRectangular) {
    WidgetWatch()
} timeline: {
    SimpleEntry(
        date: .now,
        configuration: ConfigurationAppIntent(),
        lastPostId: UUID().uuidString,
        lastPostTitle: "O melhor pedaço da maçã da internet, clique para ver mais!",
        lastPostDate: .now.addingTimeInterval(-60 * 90)
    )
}

#endif
