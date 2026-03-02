import AnalyticsLibrary
import MacMagazineLibrary
import SwiftUI
import UIComponentsLibrary
import UtilityLibrary

struct LeadingImageCard: View {
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

private extension LeadingImageCard {
    @ViewBuilder
    var content: some View {
        HStack(alignment: .top, spacing: 12) {
            thumbnail
            metadataContent
        }
        .padding(10)
    }
}

// MARK: - Thumbnail -

private extension LeadingImageCard {
    @ViewBuilder
    var thumbnail: some View {
        if let artworkUrl = URL(string: data.artworkUrl) {
            CachedAsyncImage(image: artworkUrl, contentMode: .fill)
                .frame(width: 100, height: 100)
                .cornerRadius(12)
        }
    }
}

// MARK: - Content block -

private extension LeadingImageCard {
    var metadataContent: some View {
        VStack(alignment: .leading, spacing: 6) {
            titleRow
            dateAndCreatorRow
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
    
    var dateAndCreatorRow: some View {
        HStack(spacing: 4) {
            MetadataContent(
                image: "calendar",
                text: data.pubDate.toTimeAgoDisplay(showTime: true)
            )
            if let creator = data.creator, !creator.isEmpty {
                Text("•")
                Text(creator)
            }
        }
        .foregroundStyle(.primary.opacity(0.9))
        .font(.caption2)
        .lineLimit(1)
        .truncationMode(.tail)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel({
            let dateText = data.pubDate.toTimeAgoDisplay(showTime: true)
            if let creator = data.creator, !creator.isEmpty {
                return "Publicado \(dateText) por \(creator)"
            } else {
                return "Publicado \(dateText)"
            }
        }())
    }
}
