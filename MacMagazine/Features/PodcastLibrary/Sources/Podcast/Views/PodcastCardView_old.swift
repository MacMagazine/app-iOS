import FeedLibrary
import SwiftUI
import UIComponentsLibrary

struct PodcastCardView_old: View {
    let podcast: PodcastDB
    let onPlay: () -> Void
    @Environment(\.theme) private var theme

    var body: some View {
        Button(action: onPlay) {
            VStack(alignment: .leading, spacing: 0) {
                thumbnail
                metadata
            }
        }
        .cornerRadius(12)
    }
}

private extension PodcastCardView_old {
    @ViewBuilder
    var thumbnail: some View {
        if let url = URL(string: podcast.artworkURL) {
            CachedAsyncImage(image: url)
                .overlay {
                    VStack {
                        HStack {
                            Text(podcast.duration)
                                .font(.caption)
                                .padding(6)
                                .foregroundColor(.white)
                                .background(Color(red: 0.0, green: 0.0, blue: 0.0, opacity: 0.80))
                                .cornerRadius(6)
                            Spacer()
                        }
                        Spacer()
                    }
                    .padding([.top, .leading, .trailing], 10)
                }
        }
    }
}

private extension PodcastCardView_old {
    var metadata: some View {
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                Text(podcast.pubDate.format(using: .dateOnly))
                Spacer()
            }
            .font(.caption)
            .foregroundColor(.primary)
            .padding(.bottom, 4)

            HStack {
                Text(podcast.title)
                    .font(.headline)
                    .multilineTextAlignment(.leading)
                    .lineLimit(3, reservesSpace: true)
                Spacer()
            }
            .foregroundColor(.primary)
            .padding(.bottom, 8)
        }
        .padding(.horizontal)
        .padding(.vertical, 10)
        .padding(.bottom, 2)
        .background(.background)
    }
}
