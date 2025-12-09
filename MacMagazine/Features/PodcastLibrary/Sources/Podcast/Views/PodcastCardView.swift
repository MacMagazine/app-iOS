import FeedLibrary
import MacMagazineLibrary
import SwiftUI
import UIComponentsLibrary
import UtilityLibrary
import YouTubeLibrary

struct AdaptivePodcastCardView: View {
    @Environment(\.dynamicTypeSize) private var dynamicTypeSize
    let podcast: PodcastDB
    let onPlay: () -> Void

    var body: some View {
        Group {
            if dynamicTypeSize.usesPrimaryCardLayout {
                GlassPodcastCardView(
                    podcast: podcast,
                    onPlay: onPlay
                )
            } else {
                PodcastCardView(
                    podcast: podcast,
                    onPlay: onPlay
                )
            }
        }
    }
}

// MARK: - New Card

private struct GlassPodcastCardView: View {
    let podcast: PodcastDB
    let onPlay: () -> Void

    @Environment(\.theme) private var theme

    @State private var cardWidth: CGFloat = 0
    @State private var thumbnailSize: CGSize = .zero

    private var density: CardDensity { .from(width: cardWidth) }

    var body: some View {
        Button(action: onPlay) {

            ZStack(alignment: .topTrailing) {
                cardBase
                topButtons
                    .padding(10)
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
        .buttonStyle(.plain)
    }

    // MARK: - Card base (thumbnail + bottom content)

    private var cardBase: some View {
        ZStack(alignment: .bottom) {
            thumbnail
            content
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

    // MARK: - Thumbnail

    @ViewBuilder
    var thumbnail: some View {
        if let url = URL(string: podcast.artworkURL) {
            CachedAsyncImage(image: url)
        }
    }

    // MARK: - Bottom content block

    private var content: some View {
        VStack(alignment: .leading, spacing: 6) {

            Text(podcast.title)
                .font(density.titleFont)
                .multilineTextAlignment(.leading)
                .lineLimit(density.titleLineLimit)
                .foregroundStyle(.white)
                .shadow(color: .white.opacity(0.6), radius: 2, x: 0, y: 1)

            HStack(alignment: .firstTextBaseline, spacing: 8) {
                dateRow
                    .foregroundStyle(.white.opacity(0.9))
                    .shadow(color: .white.opacity(0.6), radius: 2, x: 0, y: 1)

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

    @ViewBuilder var topButtons: some View {

//        FavoriteShareContainer(
//            favoriteView: PodcastFavoriteButton(content: data),
//            shareView: ShareButton(content: data)
//        )

        if let urlPodCast = URL(string: podcast.podcastURL) {
            UtilityLibrary.ShareButton(title: podcast.title,
                                       url: urlPodCast)
            .buttonStyle(.plain)
            .tint(.primary)
            .font(.system(size: 16))
            .padding(.horizontal, 14)
            .padding(.vertical, 10)
            .padding(.bottom, 2)
            .glassEffect()
        } else {
            EmptyView()
        }
    }

    private var dateRow: some View {
        HStack(spacing: 4) {
            Image(systemName: "calendar")
            Text(podcast.pubDate.format(using: .dateOnly))
        }
    }

    private var duration: some View {
        Text(podcast.duration)
            .font(.caption)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .foregroundColor(.white)
            .lineLimit(1)
            .minimumScaleFactor(0.8)
            .glassEffect(.clear, in: .rect(cornerRadius: 6))
    }
}

// MARK: - Old Card

private struct PodcastCardView: View {
    let podcast: PodcastDB
    let onPlay: () -> Void

    @Environment(\.theme) private var theme

    var body: some View {
        Button(action: onPlay) {
            VStack(alignment: .leading, spacing: 0) {
                thumbnail
                metadata
            }
        }
        .cornerRadius(12)
    }

    @ViewBuilder
    var thumbnail: some View {
        if let url = URL(string: podcast.artworkURL) {
            CachedAsyncImage(image: url)
                .overlay {
                    ZStack {
                        VStack {
                            HStack {
                                Text(podcast.duration)
                                    .font(.caption)
                                    .padding(6)
                                    .foregroundColor(.white)
                                    .background(
                                        Color(
                                            red: 0.0,
                                            green: 0.0,
                                            blue: 0.0,
                                            opacity: 0.80
                                        )
                                    )
                                    .cornerRadius(6)
                                Spacer()
                            }
                            Spacer()
                        }
                        .padding([.top, .leading, .trailing], 10)
                    }
                }
        }
    }

    var metadata: some View {
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                Text(podcast.pubDate.format(using: .dateOnly))
                Spacer()
            }
            .font(.caption)
            .foregroundColor(.primary)
            .padding(.bottom, 4)

            HStack {
                Text(podcast.title)
                    .font(.headline)
                    .multilineTextAlignment(.leading)
                    .lineLimit(3, reservesSpace: true)
                Spacer()
            }
            .foregroundColor(.primary)
            .padding(.bottom, 8)
        }
        .padding(.horizontal)
        .padding(.vertical, 10)
        .padding(.bottom, 2)
        .background(.background)
    }
}

#if DEBUG
#Preview {
    @Previewable @State var playing = false
    @Previewable @Environment(\.theme) var theme

    let mockPodcast = PodcastDB(
        postId: "1",
        title: "MacMagazine no Ar #123: Especial WWDC 2024",
        subtitle: "Neste episódio especial, discutimos todas as novidades anunciadas na WWDC 2024",
        pubDate: Date(),
        artworkURL: "https://macmagazine.com.br/wp-content/uploads/2025/11/28-podcast-1260x709.jpg",
        podcastURL: "https://traffic.libsyn.com/secure/macmagazine/MacMagazine_no_Ar_001.mp3",
        podcastSize: 50_000_000,
        duration: "45:30",
        podcastFrame: "",
        favorite: false,
        playable: true
    )

    ZStack {
        theme.main.background.color
            .edgesIgnoringSafeArea(.all)

        VStack {
            PodcastCardView(
                podcast: mockPodcast,
                onPlay: { playing.toggle() }
            )
            .padding()

            GlassPodcastCardView(
                podcast: mockPodcast,
                onPlay: { playing.toggle() }
            )
            .padding()
        }
    }
    .environment(\.theme, ThemeColor())

}
#endif
