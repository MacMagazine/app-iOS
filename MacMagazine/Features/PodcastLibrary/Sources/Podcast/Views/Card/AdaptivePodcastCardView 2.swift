import FeedLibrary
import MacMagazineLibrary
import SwiftUI
import UIComponentsLibrary
import UtilityLibrary

struct PodcastCardView: View {
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

        PodcastCardView(
            podcast: mockPodcast,
            onPlay: { playing.toggle() }
        )
        .padding()
    }
    .environment(\.theme, ThemeColor())

}
#endif
