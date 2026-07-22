import FeedLibrary
import MacMagazineLibrary
import MacMagazineUILibrary
import SwiftUI
import UIComponentsLibrary
import UtilityLibrary

public struct PodcastCardView: View {
    @Environment(\.theme) private var theme

    public let podcast: CardContent
    public let onPlay: () -> Void

    public init(podcast: CardContent, onPlay: @escaping () -> Void) {
        self.podcast = podcast
        self.onPlay = onPlay
    }

    public var body: some View {
        Button(action: onPlay) {
            VStack(alignment: .leading, spacing: 0) {
                thumbnail
                metadata
            }
        }
        .cornerRadius(12)
        .buttonStyle(.plain)
    }

    @ViewBuilder
    var thumbnail: some View {
        if let url = URL(string: podcast.artworkUrl) {
            CachedAsyncImage(image: url)
                .overlay {
                    VStack {
                        HStack {
                            Text(podcast.type.duration)
                                .font(.caption)
                                .padding(6)
                                .foregroundColor(.white)
                                .background(Color(red: 0.0, green: 0.0, blue: 0.0, opacity: 0.80))
                                .cornerRadius(6)
                            Spacer()
                        }
                        Spacer()
                    }
                    .padding([.top, .leading, .trailing], 10)
                }
        }
    }

    var metadata: some View {
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                Text(podcast.pubDate.toTimeAgoDisplay(showTime: false))
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

            buttons
        }
        .padding(.vertical, 10)
        .padding(.horizontal)
        .background(.background)
    }

    var buttons: some View {
        HStack(spacing: 20) {
            FavoriteButton(
                favorite: podcast.favorite,
                action: podcast.favoriteAction
            )
            ShareButton(
                title: podcast.title,
                url: podcast.urlToShare
            )
        }
        .tint(theme.button.primary.color ?? .primary)
    }
}

#if DEBUG
#Preview {
    @Previewable @State var playing = false

    let podcast = PodcastDB(
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
        Color.brown.ignoresSafeArea()

        PodcastCardView(
            podcast: podcast.toCardContent(using: nil, analytics: nil, screen: nil),
            onPlay: { playing.toggle() }
        )
        .padding()
    }
    .environment(\.theme, ThemeColor())
}
#endif
