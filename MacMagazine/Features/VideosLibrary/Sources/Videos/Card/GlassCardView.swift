import MacMagazineLibrary
import StorageLibrary
import SwiftUI
import UtilityLibrary
import YouTubeLibrary

// MARK: - GlassCard

@MainActor
public struct GlassCard: VideoCard {
    public var accessibilityLabels: [CardLabel]?
    public var accessibilityButtons: [CardButton]?

    public func makeBody(data: VideoDB) -> some View {
        GlassCardView(data: data)
    }
}

@MainActor
struct GlassCardView: View {
    @Namespace var namespace

    let data: VideoDB

    @State private var cardWidth: CGFloat = 0
    @State private var thumbnailSize: CGSize = .zero

    private var density: CardDensity { .from(width: cardWidth) }

    // MARK: - Body

    var body: some View {
        ZStack(alignment: .topTrailing) {
            cardBase
            topButtons
        }
        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
        .background(
            GeometryReader { geo in
                Color.clear
                    .onAppear { cardWidth = geo.size.width }
                    .onChange(of: geo.size) { _, newValue in
                        cardWidth = newValue.width
                    }
            }
        )
    }
}

// MARK: - Card base (thumbnail + bottom content) -

private extension GlassCardView {
    var cardBase: some View {
        Group {
            if let imageUrl = data.url {
                ZStack(alignment: .bottom) {
                    thumbnail(imageUrl)
                    content
                }
            } else {
                content
                    .background(fallbackBackground)
            }
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

    // MARK: - Thumbnail -

    func thumbnail(_ imageUrl: URL) -> some View {
        Thumbnail(
            imageUrl: imageUrl,
            duration: "",
            position: .none,
            corners: [.allCorners]
        )
        .background(
            GeometryReader { geo in
                Color.clear
                    .onAppear { thumbnailSize = geo.size }
                    .onChange(of: geo.size) { _, newSize in
                        thumbnailSize = newSize
                    }
            }
        )
    }

    // MARK: - Top buttons -

    var topButtons: some View {
        FavoriteShareContainer(
            favoriteView: FavoriteButton(content: data),
            shareView: ShareButton(content: data)
        )
    }

    // MARK: - Bottom content block -

    var content: some View {
        VStack(alignment: .leading, spacing: 6) {

            if density != .spacious {
                dateRow
                    .font(.caption2)
                    .foregroundStyle(.white.opacity(0.9))
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)
                    .shadow(color: .white.opacity(0.6), radius: 2, x: 0, y: 1)
            }

            Text(data.title)
                .font(density.titleFont)
                .multilineTextAlignment(.leading)
                .lineLimit(density.titleLineLimit)
                .foregroundStyle(.white)
                .shadow(color: .white.opacity(0.6), radius: 2, x: 0, y: 1)

            HStack(alignment: .firstTextBaseline, spacing: 8) {
                if density == .spacious {
                    dateRow
                        .foregroundStyle(.white.opacity(0.9))
                        .shadow(color: .white.opacity(0.6), radius: 2, x: 0, y: 1)
                }

                HStack(spacing: 8) {
                    statsRowViews
                    statsRowLikes
                }
                .foregroundStyle(.white.opacity(0.9))
                .shadow(color: .white.opacity(0.6), radius: 2, x: 0, y: 1)
                .lineLimit(1)
                .minimumScaleFactor(0.8)
                .layoutPriority(1)

                Spacer(minLength: 4)

                duration
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)
                    .layoutPriority(0)
            }
            .font(.caption2)
            .shadow(color: .black.opacity(0.7), radius: 2, x: 0, y: 1)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 10)
        .padding(.top, density == .compact ? 20 : 30)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(gradientOverlay)
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

    var dateRow: some View {
        HStack(spacing: 4) {
            Image(systemName: "calendar")
            Text(data.pubDate.formattedDate(using: "dd/MM/yy"))
        }
    }

    var statsRowViews: some View {
        HStack(spacing: 4) {
            Image(systemName: "chart.bar")
            Text(data.views.formattedBigNumber)
        }
    }

    var statsRowLikes: some View {
        HStack(spacing: 4) {
            Image(systemName: "hand.thumbsup")
            Text(data.likes.formattedBigNumber)
        }
    }

    var duration: some View {
        Text(data.duration.formattedYTDuration)
            .font(.caption)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .foregroundColor(.white)
            .lineLimit(1)
            .minimumScaleFactor(0.8)
            .glassEffect(.clear, in: .rect(cornerRadius: 6))
    }
}

#if DEBUG
#Preview {
    @MainActor
    struct MMVideoDBPreview {
        static let sample = VideoDB(
            artworkURL: "https://i.ytimg.com/vi/bq02LMjcCns/maxresdefault.jpg",
            current: 42.0,
            duration: "PT4M46S".formattedYTDuration,
            favorite: true,
            likes: "782",
            pubDate: "2021-02-17T20:45:21Z",
            title: "Como Usar WhatsApp No iPad",
            videoId: "VVVBel9Fc3prM1lqcVZMdzZvWGJTS1FBLmJxMDJMTWpjQ25z",
            views: "5663"
        )
    }

    return ZStack {
        Color.brown.ignoresSafeArea()
        VStack(spacing: 30) {
            GlassCardView(
                data: MMVideoDBPreview.sample
            )
            .padding()
        }
    }
}
#endif
