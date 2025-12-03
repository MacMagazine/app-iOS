import FeedLibrary
import SwiftUI

struct PodcastPlayerView: View {
    @Environment(\.theme) private var theme
    @Bindable var playerManager: PodcastPlayerManager

    var body: some View {
        VStack(spacing: 0) {
            if let podcast = playerManager.currentPodcast {
                fullPlayerContent(podcast: podcast)
            }
        }
        .background(theme.main.background.color ?? .white)
    }

    @ViewBuilder
    private func fullPlayerContent(podcast: PodcastDB) -> some View {
        VStack(spacing: 24) {
            artworkView(podcast: podcast)
            podcastInfo(podcast: podcast)
            playbackControls
            playbackSpeedControl
        }
        .padding()
    }

    @ViewBuilder
    private func artworkView(podcast: PodcastDB) -> some View {
        AsyncImage(url: URL(string: podcast.artworkURL)) { phase in
            switch phase {
            case .empty:
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.gray.opacity(0.2))
                    .overlay {
                        ProgressView()
                    }
            case .success(let image):
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .cornerRadius(16)
                    .shadow(radius: 10)
            case .failure:
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.gray.opacity(0.2))
                    .overlay {
                        Image(systemName: "music.note")
                            .font(.system(size: 60))
                            .foregroundColor(.gray)
                    }
            @unknown default:
                EmptyView()
            }
        }
        .frame(maxWidth: 400, maxHeight: 400)
        .padding(.top, 20)
    }

    @ViewBuilder
    private func podcastInfo(podcast: PodcastDB) -> some View {
        VStack(spacing: 8) {
            Text(podcast.title)
                .font(.title2)
                .fontWeight(.semibold)
                .multilineTextAlignment(.center)
                .lineLimit(2)
                .foregroundColor(theme.text.primary.color ?? .primary)

            Text("MacMagazine")
                .font(.subheadline)
                .foregroundColor((theme.text.primary.color ?? .primary).opacity(0.7))

            if !podcast.duration.isEmpty {
                Text(podcast.duration)
                    .font(.caption)
                    .foregroundColor((theme.text.primary.color ?? .primary).opacity(0.6))
            }
        }
        .padding(.horizontal)
    }

    @ViewBuilder
    private var playbackControls: some View {
        VStack(spacing: 16) {
            progressSlider

            HStack(spacing: 40) {
                skipButton(systemName: "gobackward.15", action: { playerManager.skip(by: -15) })
                playPauseButton
                skipButton(systemName: "goforward.15", action: { playerManager.skip(by: 15) })
            }
            .font(.system(size: 28))
        }
    }

    @ViewBuilder
    private var progressSlider: some View {
        VStack(spacing: 8) {
            Slider(
                value: Binding(
                    get: { playerManager.currentTime },
                    set: { playerManager.seek(to: $0) }
                ),
                in: 0...max(playerManager.duration, 0.1)
            )
            .tint(theme.button.primary.color ?? .blue)

            HStack {
                Text(formatTime(playerManager.currentTime))
                    .font(.caption)
                    .foregroundColor((theme.text.primary.color ?? .primary).opacity(0.6))
                Spacer()
                Text(formatTime(playerManager.duration))
                    .font(.caption)
                    .foregroundColor((theme.text.primary.color ?? .primary).opacity(0.6))
            }
        }
        .padding(.horizontal)
    }

    @ViewBuilder
    private var playPauseButton: some View {
        Button {
            playerManager.togglePlayPause()
        } label: {
            Image(systemName: playerManager.isPlaying ? "pause.circle.fill" : "play.circle.fill")
                .font(.system(size: 64))
                .foregroundColor(theme.button.primary.color ?? .blue)
        }
    }

    @ViewBuilder
    private func skipButton(systemName: String, action: @escaping () -> Void) -> some View {
        Button {
            action()
        } label: {
            Image(systemName: systemName)
                .foregroundColor(theme.button.primary.color ?? .blue)
        }
    }

    @ViewBuilder
    private var playbackSpeedControl: some View {
        HStack(spacing: 12) {
            Text("Playback Speed:")
                .font(.subheadline)
                .foregroundColor((theme.text.primary.color ?? .primary).opacity(0.7))

            ForEach([0.75, 1.0, 1.25, 1.5, 2.0], id: \.self) { speed in
                Button {
                    playerManager.setPlaybackRate(Float(speed))
                } label: {
                    Text("\(speed, specifier: "%.2f")x")
                        .font(.caption)
                        .fontWeight(playerManager.playbackRate == Float(speed) ? .bold : .regular)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                        .background(
                            playerManager.playbackRate == Float(speed)
                                ? (theme.button.primary.color ?? .blue).opacity(0.2)
                                : Color.clear
                        )
                        .foregroundColor(
                            playerManager.playbackRate == Float(speed)
                                ? theme.button.primary.color ?? .blue
                                : (theme.text.primary.color ?? .primary).opacity(0.7)
                        )
                        .cornerRadius(8)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke((theme.button.primary.color ?? .blue).opacity(0.3), lineWidth: 1)
                        )
                }
            }
        }
        .padding(.horizontal)
    }

    private func formatTime(_ time: TimeInterval) -> String {
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
