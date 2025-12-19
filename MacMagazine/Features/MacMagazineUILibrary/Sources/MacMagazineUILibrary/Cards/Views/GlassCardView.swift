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
        .cardSize { value in
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
        GeometryReader { geo in
            CachedAsyncImage(image: imageUrl, contentMode: .fill)
                .frame(height: geo.size.width * 9 / 16)
                .cornerRadius(12)
        }
        .aspectRatio(16 / 9, contentMode: .fit)
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
            AnyLayout(VStackLayout(spacing: 8))
        default:
            AnyLayout(HStackLayout(alignment: .firstTextBaseline, spacing: 8))
        }

        layout {
            innerLayout {
                dateRow
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
            text: data.pubDate.format(using: .dateOnly)
        )
        .foregroundStyle(.white.opacity(0.9))
    }

    var duration: some View {
        MetadataDuration(text: data.type.duration)
            .lineLimit(1)
            .layoutPriority(0)
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
    @MainActor
    struct MMVideoDBPreview {
        static let sampleVideo = CardContent(
            type: .video(views: "5,6K", likes: "782", duration: "4:46"),
            title: "Apresento-lhes o… iPhone Pocket?!",
            pubDate: Date(),
            artworkUrl: "https://i.ytimg.com/vi/5rKJeiG-Rug/sddefault.jpg",
            urlToShare: "",
            favorite: true,
            favoriteAction: {}
        )

        static let samplePodcast = CardContent(
            type: .podcast(duration: "45:30"),
            title: "MacMagazine no Ar #123: Especial WWDC 2024",
            pubDate: Date(),
            artworkUrl: "https://macmagazine.com.br/wp-content/uploads/2025/11/28-podcast-1260x709.jpg",
            urlToShare: "",
            favorite: true,
            favoriteAction: {}
        )
    }

    return ZStack {
        Color.brown.ignoresSafeArea()
        VStack(spacing: 30) {
            GlassCardView(
                data: MMVideoDBPreview.sampleVideo
            )
            .padding()

            GlassCardView(
                data: MMVideoDBPreview.samplePodcast
            )
            .padding()
        }
    }
}
#endif
