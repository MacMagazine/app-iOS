import FeedLibrary
import SwiftUI

struct FeedRowView: View {
    let post: FeedDB

    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .bottom) {
                background(size: geometry.size)
                overlayGradient
                content
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    @ViewBuilder
    private func background(size: CGSize) -> some View {
        ZStack {
            Color.black

            if let url = post.artworkRemoteURL {
                AsyncImage(url: url) { phase in
                    switch phase {
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFill()
                            .frame(width: size.width, height: size.height)
                            .clipped()

                    case .failure:
                        Color.black.opacity(0.25)

                    case .empty:
                        ProgressView()

                    @unknown default:
                        Color.black.opacity(0.25)
                    }
                }
            } else {
                Color.black.opacity(0.25)
            }
        }
        .frame(width: size.width, height: size.height)
    }

    private var overlayGradient: some View {
        LinearGradient(
            colors: [
                .black.opacity(0.05),
                .black.opacity(0.80)
            ],
            startPoint: .top,
            endPoint: .bottom
        )
    }

    private var content: some View {
        VStack(spacing: 10) {
            Text(post.title)
                .font(.system(size: 14))
                .fontWeight(.bold)
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity, alignment: .leading)
                .lineLimit(3)
                .padding(.leading, 20)

            Text(post.dateText)
                .font(.system(size: 10))
                .foregroundStyle(.white.opacity(0.85))
                .frame(maxWidth: .infinity, alignment: .center)
                .lineLimit(1)
        }
        .padding(.horizontal, 8)
        .padding(.bottom, 8)
    }
}

#if DEBUG
#Preview("FeedRowView") {
    FeedRowView(post: .previewItem)
}
#endif
