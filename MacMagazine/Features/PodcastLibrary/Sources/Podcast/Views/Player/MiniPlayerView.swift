import FeedLibrary
import SwiftUI
import UIComponentsLibrary

enum PodcastMiniPlayerLayout {
    case tabBar
    case sidebar
}

struct MiniPlayerView: View {
    @Environment(\.theme) private var theme
    @Environment(\.shouldUseSidebar) private var shouldUseSidebar
    @Namespace private var animation

    @Bindable var playerManager: PodcastPlayerManager

    let currentPodcast: PodcastDB

    init(
        playerManager: PodcastPlayerManager,
        currentPodcast: PodcastDB
    ) {
        self.playerManager = playerManager
        self.currentPodcast = currentPodcast
    }

    var body: some View {
        miniPlayerContent(podcast: currentPodcast)
            .padding(.horizontal, 6)
            .padding(.vertical, 4)
            .contentShape(Rectangle())
            .gesture(tapToOpen)
            .gesture(tapToDismiss)
            .matchedTransitionSource(id: "MINIPLAYER", in: animation)
    }

    private var tapToOpen: some Gesture {
        TapGesture()
            .onEnded { _ in
                playerManager.isFullscreen.toggle()
            }
    }

    private var tapToDismiss: some Gesture {
        TapGesture(count: 2)
            .onEnded { _ in
                if playerManager.isPlaying {
                    playerManager.pause()
                }
                playerManager.currentPodcast = nil
            }
    }
}

private extension MiniPlayerView {
    func miniPlayerContent(podcast: PodcastDB) -> some View {
        HStack {
            HStack(spacing: 8) {
                artwork(podcast.artworkURL)

                Ticker(text: podcast.title, speed: 30)
                    .frame(height: 30)
                    .id(podcast.id)

                HStack(spacing: 20) {
                    Button {
                        playerManager.skip(by: -15)
                    } label: {
                        Image(systemName: "gobackward.15")
                            .font(.system(size: 20))
                    }

                    Button {
                        playerManager.togglePlayPause()
                    } label: {
                        Image(systemName: playerManager.isPlaying ? "pause.fill" : "play.fill")
                            .font(.system(size: 24))
                    }

                    Button {
                        playerManager.skip(by: 15)
                    } label: {
                        Image(systemName: "goforward.15")
                            .font(.system(size: 20))
                    }
                }
            }
            .contentShape(Rectangle())
        }
        .foregroundColor(.black)
    }

    @ViewBuilder
    func artwork(_ artworkURL: String) -> some View {
        if let url = URL(string: artworkURL) {
            CachedAsyncImage(image: url)
                .scaledToFill()
                .clipShape(Circle())
                .frame(width: 30, height: 30)
        }
    }
}
