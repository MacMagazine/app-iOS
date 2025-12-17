import FeedLibrary
import SwiftUI
import UIComponentsLibrary

struct MiniPlayerView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.theme) private var theme
    @Namespace private var animation

    @Bindable var playerManager: PodcastPlayerManager

    let currentPodcast: PodcastDB
    let appColorScheme: ColorScheme

    private var controlsColor: Color {
        switch appColorScheme {
        case .dark:
            return .white
        case .light:
            return .black
        @unknown default:
            return .primary
        }
    }

    init(
        playerManager: PodcastPlayerManager,
        currentPodcast: PodcastDB,
        appColorScheme: ColorScheme
    ) {
        self.playerManager = playerManager
        self.currentPodcast = currentPodcast
        self.appColorScheme = appColorScheme
    }

    var body: some View {
        content
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
                    currentPodcast.save(current: playerManager.currentTime, using: modelContext)
                }
                playerManager.currentPodcast = nil
            }
    }
}

private extension MiniPlayerView {
    var content: some View {
        HStack {
            HStack(spacing: 8) {
                artwork(currentPodcast.artworkURL)
                    .accessibilityHidden(true)

                Ticker(text: currentPodcast.title, speed: 30)
                    .frame(height: 30)
                    .id(currentPodcast.id)

                HStack(spacing: 20) {
                    Button {
                        playerManager.skip(by: -15)
                    } label: {
                        Image(systemName: "gobackward.15")
                            .font(.system(size: 20))
                    }
                    .buttonStyle(.plain)

                    Button {
                        playerManager.togglePlayPause()
                        currentPodcast.save(current: playerManager.currentTime, using: modelContext)
                    } label: {
                        Image(systemName: playerManager.isPlaying ? "pause.fill" : "play.fill")
                            .font(.system(size: 24))
                    }
                    .buttonStyle(.plain)

                    Button {
                        playerManager.skip(by: 15)
                    } label: {
                        Image(systemName: "goforward.15")
                            .font(.system(size: 20))
                    }
                    .buttonStyle(.plain)

                }
            }
            .foregroundStyle(controlsColor)
            .contentShape(Rectangle())
        }
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
