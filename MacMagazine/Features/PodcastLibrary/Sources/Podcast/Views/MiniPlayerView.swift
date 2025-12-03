import FeedLibrary
import SwiftUI

struct MiniPlayerView: View {
    @Bindable var playerManager: PodcastPlayerManager
    @Environment(\.theme) private var theme
    let onTap: () -> Void

    var body: some View {
        if let podcast = playerManager.currentPodcast {
            miniPlayerContent(podcast: podcast)
                .transition(.move(edge: .bottom).combined(with: .opacity))
        }
    }

    @ViewBuilder
    private func miniPlayerContent(podcast: PodcastDB) -> some View {
        VStack(spacing: 0) {
            progressBar

            HStack(spacing: 12) {
                artwork(podcast: podcast)

                VStack(alignment: .leading, spacing: 4) {
                    Text(podcast.title)
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .lineLimit(1)
                        .foregroundColor(theme.text.primary.color ?? .primary)

                    Text("MacMagazine")
                        .font(.caption)
                        .foregroundColor((theme.text.primary.color ?? .primary).opacity(0.7))
                }

                Spacer()

                HStack(spacing: 20) {
                    Button {
                        playerManager.skip(by: -15)
                    } label: {
                        Image(systemName: "gobackward.15")
                            .font(.system(size: 20))
                            .foregroundColor(theme.button.primary.color ?? .blue)
                    }

                    Button {
                        playerManager.togglePlayPause()
                    } label: {
                        Image(systemName: playerManager.isPlaying ? "pause.fill" : "play.fill")
                            .font(.system(size: 24))
                            .foregroundColor(theme.button.primary.color ?? .blue)
                    }

                    Button {
                        playerManager.skip(by: 15)
                    } label: {
                        Image(systemName: "goforward.15")
                            .font(.system(size: 20))
                            .foregroundColor(theme.button.primary.color ?? .blue)
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(theme.main.background.color ?? .white)
        }
        .background(
            (theme.main.background.color ?? .white)
                .shadow(color: Color.black.opacity(0.1), radius: 10, y: -5)
        )
        .onTapGesture {
            onTap()
        }
    }

    @ViewBuilder
    private func artwork(podcast: PodcastDB) -> some View {
        AsyncImage(url: URL(string: podcast.artworkURL)) { phase in
            switch phase {
            case .empty:
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.gray.opacity(0.2))
                    .frame(width: 50, height: 50)
                    .overlay {
                        ProgressView()
                            .scaleEffect(0.6)
                    }
            case .success(let image):
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 50, height: 50)
                    .cornerRadius(8)
            case .failure:
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.gray.opacity(0.2))
                    .frame(width: 50, height: 50)
                    .overlay {
                        Image(systemName: "music.note")
                            .font(.system(size: 20))
                            .foregroundColor(.gray)
                    }
            @unknown default:
                EmptyView()
            }
        }
        .frame(width: 50, height: 50)
    }

    @ViewBuilder
    private var progressBar: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                Rectangle()
                    .fill(Color.gray.opacity(0.2))
                    .frame(height: 3)

                Rectangle()
                    .fill(theme.button.primary.color ?? .blue)
                    .frame(
                        width: playerManager.duration > 0
                            ? geometry.size.width * CGFloat(playerManager.currentTime / playerManager.duration)
                            : 0,
                        height: 3
                    )
            }
        }
        .frame(height: 3)
    }
}
