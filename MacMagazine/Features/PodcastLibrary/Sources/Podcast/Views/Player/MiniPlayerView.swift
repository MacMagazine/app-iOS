import FeedLibrary
import SwiftUI
import UIComponentsLibrary

public enum PodcastMiniPlayerLayout {
    case tabBar
    case sidebar
}

public struct MiniPlayerView: View {
    @Environment(\.theme) private var theme

    @Bindable var playerManager: PodcastPlayerManager

    let currentPodcast: PodcastDB
    let onTap: () -> Void

    public init(
        playerManager: PodcastPlayerManager,
        currentPodcast: PodcastDB,
        onTap: @escaping () -> Void
    ) {
        self.playerManager = playerManager
        self.currentPodcast = currentPodcast
        self.onTap = onTap
    }

    public var body: some View {
        miniPlayerContent(podcast: currentPodcast)
            .padding(.horizontal, 6)
            .padding(.vertical, 4)
            .contentShape(Rectangle())
            .gesture(dragToDismiss)
    }

    private var dragToDismiss: some Gesture {
        DragGesture(minimumDistance: 20)
            .onEnded { value in
                let vertical = value.translation.height

                if vertical > 100 {
                    if playerManager.isPlaying {
                        playerManager.pause()
                    }
                    playerManager.currentPodcast = nil
                }
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
            }
            .contentShape(Rectangle())
            .onTapGesture {
                onTap()
            }

            Spacer()

            Button {
                playerManager.togglePlayPause()
            } label: {
                Image(systemName: playerManager.isPlaying ? "pause.fill" : "play.fill")
                    .font(.system(size: 24))
            }
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
