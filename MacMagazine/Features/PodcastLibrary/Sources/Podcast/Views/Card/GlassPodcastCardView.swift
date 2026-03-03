import AnalyticsLibrary
import FeedLibrary
import MacMagazineLibrary
import MacMagazineUILibrary
import SwiftData
import SwiftUI

struct GlassPodcastCardView: View {
    @EnvironmentObject private var analytics: AnalyticsManager
    let podcast: CardContent
    let onPlay: () -> Void

    var body: some View {
        Button(action: {
            onPlay()
            analytics.track(.buttonTap(
                buttonId: AnalyticsConstants.ButtonID.podcastTogglePlayPause.id,
                screen: AnalyticsConstants.Screen.podcast.name
            ))
        }, label: {
            GlassCardView(data: podcast)
        })
    }
}

#if DEBUG
import StorageLibrary

#Preview {
    @Previewable @State var playing = false

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
        favorite: true,
        playable: true
    )

    let storage = Database(models: [PodcastDB.self], inMemory: true)

    GlassPodcastCardView(
        podcast: mockPodcast.toCardContent(
            using: storage.sharedModelContainer.mainContext,
            analytics: nil,
            screen: nil
        ),
        onPlay: { playing.toggle() }
    )
    .padding()
}
#endif
