import AppIntents
import SwiftUI
import WidgetKit

struct WatchWidgetEntryView: View {

    let entry: WatchWidgetModel
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

private extension WatchWidgetEntryView {

    // ACCESSORY CIRCULAR
    var circular: some View {
        ZStack {
            AccessoryWidgetBackground()

            Image("logo_color")
                .resizable()
                .scaledToFit()
                .frame(width: 30, height: 30)
        }
        .macMagazineCircular(
            url: URL(string: "macmagazine://news")
        )
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
            .macMagazineWidgetAccessibility(
                url: widgetPostURL(),
                lastPostTitle: entry.lastPostTitle,
                children: .ignore
            )
    }

    // ACCESSORY INLINE
    var inline: some View {
        Text(entry.lastPostTitle)
            .macMagazineWidgetAccessibility(
                url: widgetPostURL(),
                lastPostTitle: entry.lastPostTitle
            )
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
        .macMagazineRectangular(
            url: widgetPostURL(),
            accessibilityValue: accessibilityValueForRectangular()
        )
    }

    func widgetPostURL() -> URL? {
        if let postId = entry.lastPostId, !postId.isEmpty {
            return URL(string: "macmagazine://news/post/\(postId)")
        }

        return URL(string: "macmagazine://news")
    }

    func relativePostTimeText(_ date: Date?) -> String {
        guard let date else { return "Atualizado recentemente" }

        let time = DateFormatter.watchWidgetTime.string(from: date)
        let calendar = Calendar.current

        if calendar.isDateInToday(date) {
            return "Hoje às \(time)"
        }

        if calendar.isDateInYesterday(date) {
            return "Ontem às \(time)"
        }

        return "\(DateFormatter.watchWidgetDay.string(from: date)) às \(time)"
    }

    func accessibilityValueForRectangular() -> String {
        let whenText = relativePostTimeText(entry.lastPostDate)
        return "\(whenText), \(entry.lastPostTitle)"
    }
}
