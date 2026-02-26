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
        HStack(spacing: 12) {
            if let artworkUrl = URL(string: data.artworkUrl) {
                thumbnail(artworkUrl)
                metadataContent
            } else {
                metadataContent
            }
        }
        .padding(10)
    }
}

// MARK: - Thumbnail -

private extension LeadingImageCard {
    @ViewBuilder
    func thumbnail(_ imageUrl: URL) -> some View {
        CachedAsyncImage(image: imageUrl, contentMode: .fill)
            .frame(width: 100, height: 100)
            .cornerRadius(12)
    }
}

// MARK: - Content block -

private extension LeadingImageCard {
    var metadataContent: some View {
        VStack(alignment: .leading, spacing: 6) {
            titleRow
            dateRow
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    var titleRow: some View {
        Text(data.title)
            .font(density.titleFont)
            .multilineTextAlignment(.leading)
            .lineLimit(density.titleLineLimit)
            .foregroundStyle(.primary)
    }

    var dateRow: some View {
        HStack(alignment: .center, spacing: 0) {
            MetadataContent(
                image: "calendar",
                text: data.pubDate.toTimeAgoDisplay(showTime: true)
            )
            .foregroundStyle(.primary.opacity(0.9))
            .font(.caption2)

            Spacer(minLength: 4)

            MenuButton(data: data)
        }
    }
}
