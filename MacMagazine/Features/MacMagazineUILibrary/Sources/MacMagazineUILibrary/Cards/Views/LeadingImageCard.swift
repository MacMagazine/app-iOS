import AnalyticsLibrary
import MacMagazineLibrary
import SwiftUI
import UIComponentsLibrary
import UtilityLibrary

struct LeadingImageCard: View {
    private enum CardMetrics {
        static let padding: CGFloat = 10
        static let innerRadius: CGFloat = 8
        static let outerRadius: CGFloat = innerRadius + padding
    }

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
            .clipShape(RoundedRectangle(cornerRadius: CardMetrics.outerRadius, style: .continuous))
            .contentWidth { value in
                cardWidth = value
            }
    }
}

// MARK: - Card -

private extension LeadingImageCard {
    @ViewBuilder
    var content: some View {
        HStack(alignment: .top, spacing: 12) {
            thumbnail
            metadataContent
        }
        .padding(CardMetrics.padding)
    }
}

// MARK: - Thumbnail -

private extension LeadingImageCard {
    @ViewBuilder
    var thumbnail: some View {
        if let artworkUrl = URL(string: data.artworkUrl) {
            CachedAsyncImage(image: artworkUrl, contentMode: .fill)
                .frame(width: 100, height: 100)
                .clipShape(RoundedRectangle(cornerRadius: CardMetrics.innerRadius, style: .continuous))
        }
    }
}

// MARK: - Content block -

private extension LeadingImageCard {
    var metadataContent: some View {
        VStack(alignment: .leading, spacing: 6) {
            titleRow
            HStack(alignment: .firstTextBaseline, spacing: 8) {
                dateRow
                authorRow
            }
            Spacer(minLength: 0)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    var titleRow: some View {
        HStack(alignment: .top, spacing: 0) {
            Text(data.title)
                .font(density.titleFont)
                .multilineTextAlignment(.leading)
                .lineLimit(3, reservesSpace: true)
                .foregroundStyle(.primary)

            Spacer(minLength: 4)

            MenuButton(data: data)
                .highPriorityGesture(TapGesture())
        }
    }

    var dateRow: some View {
        MetadataContent(
            image: "calendar",
            text: data.pubDate.toTimeAgoDisplay(showTime: true)
        )
        .foregroundStyle(.primary.opacity(0.9))
        .font(.caption2)
    }

    @ViewBuilder
    var authorRow: some View {
        if let authorName = data.author, !authorName.isEmpty {
            MetadataContent(
                image: "person.fill",
                text: authorName
            )
            .foregroundStyle(.primary.opacity(0.9))
            .font(.caption2)
        } else {
            EmptyView()
        }
    }
}
