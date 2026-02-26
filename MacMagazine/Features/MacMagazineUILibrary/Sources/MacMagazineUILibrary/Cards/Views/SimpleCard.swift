import AnalyticsLibrary
import MacMagazineLibrary
import SwiftUI
import UIComponentsLibrary
import UtilityLibrary

struct SimpleCard: View {
    @EnvironmentObject private var analytics: AnalyticsManager
    @Environment(\.dynamicTypeSize) private var typeSize
    @Namespace var namespace

    let data: CardContent

    @State private var cardWidth: CGFloat = .zero

    private var density: CardDensity { .from(width: cardWidth) }

    init(data: CardContent) {
        self.data = data
    }

    var body: some View {
        content
            .background(.background)
            .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
            .contentWidth { value in
                cardWidth = value
            }
    }
}

// MARK: - Card -

private extension SimpleCard {
    @ViewBuilder
    var content: some View {
        metadataContent
        .padding(10)
    }
}

// MARK: - Content block -

private extension SimpleCard {
    var metadataContent: some View {
        VStack(alignment: .leading, spacing: 6) {
            titleRow
            dateRow
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    var titleRow: some View {
        HStack(alignment: .top, spacing: 4) {
            Text(data.title)
                .font(density.titleFont)
                .multilineTextAlignment(.leading)
                .lineLimit(density.titleLineLimit)
                .foregroundStyle(.primary)

            Spacer()

            Image(systemName: "star\(data.favorite ? ".fill" : "")")
                .font(.system(size: 12))
        }
    }

    var dateRow: some View {
        HStack {
            MetadataContent(
                image: "calendar",
                text: data.pubDate.toTimeAgoDisplay(showTime: true)
            )

            Spacer()

            Text(data.type.categories.mostRelevant.rawValue)
        }
        .foregroundStyle(.primary.opacity(0.9))
        .font(.caption2)
    }
}
