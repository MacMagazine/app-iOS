import FeedLibrary
import MacMagazineLibrary
import SwiftUI
import UIComponentsLibrary

struct PodcastPlayerView: View {
    @Environment(\.theme) private var theme
    @Bindable var playerManager: PodcastPlayerManager

    var body: some View {
        VStack(spacing: 0) {
            if let podcast = playerManager.currentPodcast {
                fullPlayerContent(podcast: podcast)
            }
        }
        .background(.background)
    }

    @ViewBuilder
    private func fullPlayerContent(podcast: PodcastDB) -> some View {
        VStack {
            artworkView(artworkURL: URL(string: podcast.artworkURL))
            podcastTitle(podcast.title)
            progressSlider
            playbackControls
        }
        .padding(.horizontal, 20)
    }
}

private extension PodcastPlayerView {
    @ViewBuilder
    func artworkView(artworkURL: URL?) -> some View {
        if let artworkURL {
            CachedAsyncImage(image: artworkURL)
                .cornerRadius(16)
                .padding(.bottom, 20)
        }
    }

    @ViewBuilder
    func podcastTitle(_ title: String) -> some View {
        HStack {
            Text(title)
                .font(.headline)
                .lineLimit(4)
                .foregroundColor(.primary)
            Spacer()
        }
        .frame(maxWidth: .infinity)
    }

    @ViewBuilder
    var playbackControls: some View {
        HStack(spacing: 40) {
            speedButton
            skipButton(systemName: "gobackward.15", action: { playerManager.skip(by: -15) })
            playPauseButton
            skipButton(systemName: "goforward.15", action: { playerManager.skip(by: 15) })
        }
        .tint(.primary)
    }

    @ViewBuilder
    var progressSlider: some View {
        VStack(spacing: 0) {
            Slider(
                value: Binding(
                    get: { playerManager.currentTime },
                    set: { playerManager.seek(to: $0) }
                ),
                in: 0...max(playerManager.duration, 0.1)
            )
            .sliderThumbVisibility(.hidden)
            .tint(.primary)

            HStack {
                Text(formatTime(playerManager.currentTime))
                Spacer()
                Text(formatTime(playerManager.currentTime - playerManager.duration))
            }
            .font(.caption)
            .foregroundColor(.primary.opacity(0.6))
        }
        .padding(.bottom)
    }

    @ViewBuilder
    var playPauseButton: some View {
        Button {
            playerManager.togglePlayPause()
        } label: {
            Image(systemName: playerManager.isPlaying ? "pause.fill" : "play.fill")
        }
        .font(.system(size: 46))
    }

    @ViewBuilder
    func skipButton(systemName: String, action: @escaping () -> Void) -> some View {
        Button {
            action()
        } label: {
            Image(systemName: systemName)
        }
        .font(.system(size: 28))
    }
}

private extension PodcastPlayerView {
    @ViewBuilder
    var speedButton: some View {
        Menu {
            ForEach([0.75, 1.0, 1.25, 1.75, 2.0], id: \.self) { speed in
                Button {
                    playerManager.setPlaybackRate(Float(speed))
                } label: {
                    HStack {
                        Text("\(speed, specifier: "%.2g")×")
                    }
                }
            }
        } label: {
            Text("\(playerManager.playbackRate, specifier: "%.2g")x")

        }
        .font(.system(size: 18))
        .transaction { transaction in
            transaction.animation = nil
        }
    }
}

private extension PodcastPlayerView {
    func formatTime(_ time: TimeInterval) -> String {
        guard time.isFinite && !time.isNaN else { return "0:00" }
        let hours = Int(time) / 3600
        let minutes = Int(time) / 60 % 60
        let seconds = Int(time) % 60

        if hours > 0 {
            return String(format: "%d:%02d:%02d", hours, minutes, seconds)
        } else {
            return String(format: "%d:%02d", minutes, seconds)
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
        podcastSize: 50000000,
        duration: "45:30",
        podcastFrame: "",
        favorite: false,
        playable: true
    )

    PodcastPlayerView(playerManager: playerManager)
        .environment(\.theme, ThemeColor())
        .onAppear {
            playerManager.currentPodcast = mockPodcast
            playerManager.duration = 2730 // 45:30 in seconds
            playerManager.currentTime = 450 // 7:30 in seconds
        }
}
