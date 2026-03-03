import AnalyticsLibrary
import MacMagazineLibrary
import SwiftUI
import UIComponentsLibrary
import UtilityLibrary

@MainActor
public struct GlassCardView: View {
    @EnvironmentObject private var analytics: AnalyticsManager
    @Environment(\.dynamicTypeSize) private var typeSize
    @Namespace var namespace

    let data: CardContent

    @State private var cardWidth: CGFloat = .zero

    private var density: CardDensity { .from(width: cardWidth) }

    public init(data: CardContent) {
        self.data = data
    }

    public var body: some View {
        ZStack(alignment: .topTrailing) {
            content
            buttons
        }
        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
        .contentWidth { value in
            cardWidth = value
        }
    }
}

// MARK: - Buttons -

private extension GlassCardView {
    @ViewBuilder
    var buttons: some View {
        let favoriteButton = FavoriteButton(
            name: data.type.accessibilityName,
            favorite: data.favorite,
            action: data.favoriteAction
        )

        let shareButton = ShareButton(
            title: data.title,
            url: data.urlToShare,
            action: {
                analytics.track(.buttonTap(buttonId: AnalyticsConstants.ButtonID.share.id, screen: data.type.screenName))
            }
        )

        FavoriteShareGlassContainer(
            favoriteView: favoriteButton,
            shareView: shareButton
        )
    }
}

// MARK: - Card (thumbnail + metadata) -

private extension GlassCardView {
    @ViewBuilder
    var content: some View {
        if let artworkUrl = URL(string: data.artworkUrl) {
            ZStack(alignment: .bottom) {
                thumbnail(artworkUrl)
                metadataContent
                    .background(gradientOverlay)
            }
        } else {
            metadataContent
                .background(fallbackBackground)
        }
    }

    var fallbackBackground: LinearGradient {
        LinearGradient(
            gradient: Gradient(stops: [
                .init(color: .black.opacity(0.40), location: 0.0),
                .init(color: .black.opacity(0.85), location: 1.0)
            ]),
            startPoint: .top,
            endPoint: .bottom
        )
    }

    var gradientOverlay: LinearGradient {
        LinearGradient(
            gradient: Gradient(stops: [
                .init(color: .black.opacity(0.0), location: 0.0),
                .init(color: .black.opacity(0.60), location: 0.4),
                .init(color: .black.opacity(0.95), location: 1.0)
            ]),
            startPoint: .top,
            endPoint: .bottom
        )
    }
}

// MARK: - Thumbnail -

private extension GlassCardView {
    @ViewBuilder
    func thumbnail(_ imageUrl: URL) -> some View {
        if let ratio = data.aspectRatio {
            GeometryReader { geo in
                CachedAsyncImage(image: imageUrl, contentMode: .fill)
                    .frame(height: geo.size.width / ratio)
                    .cornerRadius(12)
            }
            .aspectRatio(ratio, contentMode: .fit)
        } else {
            GeometryReader { geo in
                CachedAsyncImage(image: imageUrl, contentMode: .fill)
                    .frame(width: geo.size.width, height: geo.size.height)
            }
        }
    }
}

// MARK: - Content block -

private extension GlassCardView {
    var metadataContent: some View {
        VStack(alignment: .leading, spacing: 6) {
            titleRow
            detailsRow
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 10)
        .padding(.top, density == .compact ? 20 : 30)
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    var titleRow: some View {
        Text(data.title)
            .font(density.titleFont)
            .multilineTextAlignment(.leading)
            .lineLimit(density.titleLineLimit)
            .foregroundStyle(.white)
    }

    @ViewBuilder
    var detailsRow: some View {
        if data.type.views == nil ||
           data.type.likes == nil {
            dateDurationRow
        } else {
            dateStatsDurationRow
        }
    }

    @ViewBuilder
    var dateDurationRow: some View {
        let layout: AnyLayout = switch typeSize {
        case .accessibility3...:
            AnyLayout(VStackLayout(alignment: .leading, spacing: 8))
        default:
            AnyLayout(HStackLayout(alignment: .firstTextBaseline, spacing: 8))
        }

        layout {
            dateRow
            Spacer(minLength: 0)
            duration
        }
        .font(.caption2)
    }

    @ViewBuilder
    var dateStatsDurationRow: some View {
        let layout: AnyLayout = switch typeSize {
        case .xLarge...:
            AnyLayout(HStackLayout(alignment: .bottom, spacing: 8))
        default:
            AnyLayout(HStackLayout(alignment: .firstTextBaseline, spacing: 8))
        }

        let innerLayout: AnyLayout = switch typeSize {
        case .xLarge...:
            AnyLayout(VStackLayout(alignment: .leading, spacing: 8))
        default:
            AnyLayout(HStackLayout(alignment: .firstTextBaseline, spacing: 8))
        }

        layout {
            innerLayout {
                dateRow
                authorRow
                statistics
            }
            Spacer(minLength: 4)
            duration
        }
        .font(.caption2)
    }

    var dateRow: some View {
        MetadataContent(
            image: "calendar",
            text: data.pubDate.toTimeAgoDisplay(showTime: false)
        )
        .foregroundStyle(.white.opacity(0.9))
    }

    @ViewBuilder
    var authorRow: some View {
        if let authorName = data.author, !authorName.isEmpty {
            MetadataContent(
                image: "person.fill",
                text: authorName
            )
            .foregroundStyle(.white.opacity(0.9))
        } else {
            EmptyView()
        }
    }

    @ViewBuilder
    var duration: some View {
        if !data.type.duration.isEmpty {
            MetadataDuration(text: data.type.duration)
                .lineLimit(1)
                .layoutPriority(0)
        }
    }
}

// MARK: - Content block -

private extension GlassCardView {
    @ViewBuilder
    var statistics: some View {
        if let views = data.type.views,
           let likes = data.type.likes {
            HStack(spacing: 8) {
                MetadataContent(image: "chart.bar", text: views)
                MetadataContent(image: "hand.thumbsup", text: likes)
            }
            .foregroundStyle(.white.opacity(0.9))
            .lineLimit(1)
            .layoutPriority(1)
        }
    }
}

#if DEBUG
#Preview {
    ZStack {
        Color.brown.ignoresSafeArea()
        VStack(spacing: 30) {
            GlassCardView(data: ContentPreview.video)
            .padding()

            GlassCardView(data: ContentPreview.podcast)
            .padding()
        }
    }
}
#endif
