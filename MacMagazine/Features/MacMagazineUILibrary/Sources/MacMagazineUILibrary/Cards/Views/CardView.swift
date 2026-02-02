import AnalyticsLibrary
import MacMagazineLibrary
import SwiftUI
import UIComponentsLibrary
import UtilityLibrary

struct CardView: View {
    @EnvironmentObject private var analytics: AnalyticsManager
    @Environment(\.dynamicTypeSize) private var typeSize
    @Namespace var namespace

    @State private var cardWidth: CGFloat = .zero
    private let data: CardContent
    private let style: CardStyle
    private var density: CardDensity { .from(width: cardWidth) }

    init(data: CardContent, style: CardStyle) {
        self.data = data
        self.style = style
    }

    var body: some View {
        content
            .background(.background)
            .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
            .cardSize { value in
                cardWidth = value
            }
    }
}

private extension CardView {
    @ViewBuilder
    var content: some View {
        switch style {
        case .leadingImage: leadingImageView
        case .bottomImage: bottomImageView
        case .glass: GlassCardView(data: data)
        case .highlight: topImageView
        case .simple: simpleView
        case .topImage: topImageView
        }
    }
}

private extension CardView {
    @ViewBuilder
    var simpleView: some View {
        metadataContent
            .padding(10)
    }
}

private extension CardView {
    @ViewBuilder
    var leadingImageView: some View {
        HStack {
            if let artworkUrl = URL(string: data.artworkUrl) {
                thumbnail(artworkUrl, width: 95, height: 95)
                metadataContent
            } else {
                metadataContent
            }
        }
        .padding(10)
    }
}

private extension CardView {
    @ViewBuilder
    var topImageView: some View {
        VStack {
            if let artworkUrl = URL(string: data.artworkUrl) {
                thumbnail(artworkUrl, maxWidth: .infinity, height: 150)
                metadataContent
            } else {
                metadataContent
            }
        }
        .padding(10)
    }
}

private extension CardView {
    @ViewBuilder
    var bottomImageView: some View {
        VStack {
            if let artworkUrl = URL(string: data.artworkUrl) {
                metadataContent
                thumbnail(artworkUrl, maxWidth: .infinity, height: 150)
            } else {
                metadataContent
            }
        }
        .padding(10)
    }
}

private extension CardView {
    @ViewBuilder
    func thumbnail(_ imageUrl: URL, width: CGFloat, height: CGFloat) -> some View {
        CachedAsyncImage(image: imageUrl, contentMode: .fill)
            .frame(width: width, height: height)
            .cornerRadius(12)
    }

    @ViewBuilder
    func thumbnail(_ imageUrl: URL, maxWidth: CGFloat?, height: CGFloat) -> some View {
        CachedAsyncImage(image: imageUrl, contentMode: .fill)
            .frame(maxWidth: maxWidth)
            .frame(height: height)
            .cornerRadius(12)
    }
}

private extension CardView {
    var metadataContent: some View {
        VStack(alignment: .leading) {
            titleRow

            Spacer()

            dateRow
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    var titleRow: some View {
        HStack(alignment: .top) {
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
