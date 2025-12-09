import FeedLibrary
import MacMagazineLibrary
import SwiftUI
import UIComponentsLibrary
import UtilityLibrary

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
