import FeedLibrary
import MacMagazineLibrary
import SwiftUI
import UIComponentsLibrary

struct MediumPlayerView: View {
    @Environment(\.theme) private var theme

    @State private var offset: CGSize = .zero
    @Bindable var playerManager: PodcastPlayerManager

    let currentPodcast: PodcastDB

    var body: some View {
        mediumPlayerContent(podcast: currentPodcast)
            .offset(y: offset.height)
            .gesture(
                DragGesture()
                    .onChanged { value in
                        let height = value.translation.height
                        offset = CGSize(width: 0, height: max(height, 0))
                    }
                    .onEnded { _ in
                        let finalOffset = offset.height

                        if finalOffset > 80 {
                            if playerManager.isPlaying {
                                playerManager.pause()
                            }
                            playerManager.currentPodcast = nil
                        } else {
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                offset = .zero
                            }
                        }
                    }
            )
    }
}

private extension MediumPlayerView {
    func mediumPlayerContent(podcast: PodcastDB) -> some View {
        Group {
            HStack(spacing: 8) {
                artwork(podcast.artworkURL)

                VStack(alignment: .leading, spacing: 0) {
                    Ticker(text: podcast.title, speed: 30)
                        .frame(height: 30)
                        .id(podcast.id)

                    Text("MacMagazine no Ar")
                        .font(.system(size: 16))
                        .lineLimit(1)
                        .fixedSize()
                        .foregroundStyle(.gray)
                        .offset(y: -4)
                }

                Spacer()

                HStack(spacing: 24) {
                    Button {
                        playerManager.skip(by: -15)
                    } label: {
                        Image(systemName: "gobackward.15")
                            .font(.system(size: 24))
                    }

                    Button {
                        playerManager.togglePlayPause()
                    } label: {
                        Image(systemName: playerManager.isPlaying ? "pause.fill" : "play.fill")
                            .font(.system(size: 40))
                    }

                    Button {
                        playerManager.skip(by: 15)
                    } label: {
                        Image(systemName: "goforward.15")
                            .font(.system(size: 24))
                    }
                }
            }
            .foregroundColor(.primary)
            .padding(.horizontal, 18)
            .padding(.vertical, 12)
        }
        .glassEffect(.regular)
    }

    @ViewBuilder
    func artwork(_ artworkURL: String) -> some View {
        if let url = URL(string: artworkURL) {
            CachedAsyncImage(image: url)
                .scaledToFill()
                .clipShape(Circle())
                .frame(width: 60, height: 60)
        }
    }
}

#Preview {
    @Previewable @State var playerManager = PodcastPlayerManager()

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
        LinearGradient(colors: [.blue, .purple], startPoint: .top, endPoint: .bottom).ignoresSafeArea()
    }
    .safeAreaInset(edge: .bottom, spacing: 16) {
        MediumPlayerView(
            playerManager: playerManager,
            currentPodcast: mockPodcast
        )
        .padding()
    }
    .environment(\.theme, ThemeColor())
}
