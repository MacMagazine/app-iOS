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
            .padding(10)
    }
}

// MARK: - Content block -

private extension TopImageCard {
    var metadataContent: some View {
        VStack(alignment: .leading, spacing: 6) {
            thumbnail
            titleRow
            dateRow
            Spacer()
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    var titleRow: some View {
        HStack(alignment: .top, spacing: 0) {
            Text(data.title)
                .font(density.titleFont)
                .multilineTextAlignment(.leading)
                .foregroundStyle(.primary)

            Spacer(minLength: 4)

            MenuButton(data: data)
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
}

// MARK: - Thumbnail -

private extension TopImageCard {
    @ViewBuilder
    var thumbnail: some View {
        if let artworkUrl = URL(string: data.artworkUrl) {
            Rectangle().fill(Color(.gray))
                .frame(height: 120)
                .overlay {
                    CachedAsyncImage(image: artworkUrl, contentMode: .fill)
                }
                .cornerRadius(12)
                .clipped()
        }
    }
}
