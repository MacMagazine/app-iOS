import FeedLibrary
import SwiftUI
import UIComponentsLibrary

struct MiniPlayerView: View {
    @Environment(\.theme) private var theme

    @State private var offset: CGSize = .zero
    @Bindable var playerManager: PodcastPlayerManager

    let currentPodcast: PodcastDB
    let onTap: () -> Void

    var body: some View {
        miniPlayerContent(podcast: currentPodcast)
            .transition(.move(edge: .bottom).combined(with: .opacity))
            .offset(y: offset.height)

            .onTapGesture {
                onTap()
            }

            .gesture(
                DragGesture()
                    .onChanged { value in
                        offset = value.translation
                    }
                    .onEnded { value in
                        if value.translation.height > 80 {
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

private extension MiniPlayerView {
    func miniPlayerContent(podcast: PodcastDB) -> some View {
        Group {
            HStack {
                artwork(podcast.artworkURL)

                Ticker(text: podcast.title, speed: 30)
                    .frame(height: 50)
                    .id(podcast.id)

                Spacer()

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
            .foregroundColor(.primary)
            .padding()
        }
        .padding()
        .background {
            Capsule()
                .glassEffect()
                .padding()
        }
    }

    @ViewBuilder
    func artwork(_ artworkURL: String) -> some View {
        if let url = URL(string: artworkURL) {
            CachedAsyncImage(image: url)
                .scaledToFill()
                .clipShape(Circle())
                .frame(width: 50, height: 50)
        }
    }

}
