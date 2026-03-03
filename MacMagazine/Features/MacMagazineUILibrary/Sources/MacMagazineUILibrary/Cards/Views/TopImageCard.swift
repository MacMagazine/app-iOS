import AnalyticsLibrary
import MacMagazineLibrary
import SwiftUI
import UIComponentsLibrary
import UtilityLibrary

struct TopImageCard: View {
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

private extension TopImageCard {
    @ViewBuilder
    var content: some View {
        metadataContent
    }
}

// MARK: - Content block -

private extension TopImageCard {
    var metadataContent: some View {
        VStack(alignment: .leading, spacing: 10) {
            thumbnail
            titleRow
            dateRow
            authorRow
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    var titleRow: some View {
        Text(data.title)
            .font(density.titleFont)
            .multilineTextAlignment(.leading)
            .lineLimit(3, reservesSpace: true)
            .foregroundStyle(.primary)
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

// MARK: - Thumbnail -

private extension TopImageCard {
    @ViewBuilder
    var thumbnail: some View {
        ZStack(alignment: .topTrailing) {
            if let artworkUrl = URL(string: data.artworkUrl) {
                CachedAsyncImage(image: artworkUrl, contentMode: .fill)
                    .frame(height: 120)
                    .cornerRadius(12)
                    .clipped()
            }
            MenuButton(data: data)
                .padding(.top, 10)
                .padding(.trailing, 10)
                .highPriorityGesture(TapGesture())
        }
    }
}
