import FeedLibrary
import SwiftUI

struct FeedRowView: View {
    let post: FeedDB

    var body: some View {
        GeometryReader { proxy in
            ZStack(alignment: .bottomLeading) {
                backgroundImage(proxy: proxy)
                overlayGradient
                content
            }
            .frame(width: proxy.size.width, height: rowHeight)
            .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
        }
        .frame(height: rowHeight)
        .padding(.horizontal, 6)
    }

    // MARK: - Layout

    private var rowHeight: CGFloat {
        WKInterfaceDevice.current().screenBounds.height * 0.60
    }

    // MARK: - Background

    @ViewBuilder
    private func backgroundImage(proxy: GeometryProxy) -> some View {
        if let url = post.artworkRemoteURL {
            AsyncImage(url: url) { phase in
                switch phase {
                case .success(let image):
                    image
                        .resizable()
                        .scaledToFill()
                        .frame(width: proxy.size.width, height: rowHeight + parallaxExtraHeight)
                        .offset(y: parallaxOffset(proxy: proxy))
                        .clipped()
                default:
                    fallbackBackground
                }
            }
        } else {
            fallbackBackground
        }
    }

    private var fallbackBackground: some View {
        Color.black.opacity(0.25)
    }

    private var parallaxExtraHeight: CGFloat {
        70
    }

    private func parallaxOffset(proxy: GeometryProxy) -> CGFloat {
        let screen = WKInterfaceDevice.current().screenBounds
        let screenMidY = screen.midY
        let cardMidY = proxy.frame(in: .global).midY

        let distance = cardMidY - screenMidY
        let maxDistance = screen.height

        let progress = distance / maxDistance
        let amplitude: CGFloat = 28

        return -progress * amplitude
    }

    // MARK: - Overlay

    private var overlayGradient: some View {
        LinearGradient(
            colors: [
                .black.opacity(0.10),
                .black.opacity(0.75)
            ],
            startPoint: .top,
            endPoint: .bottom
        )
    }

    // MARK: - Content

    private var content: some View {
        VStack(spacing: 10) {
            Text(post.title)
                .font(.system(size: 16))
                .bold()
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity, alignment: .leading)
                .lineLimit(3)

            Text(post.dateText)
                .font(.system(size: 10))
                .foregroundStyle(.white.opacity(0.85))
                .frame(maxWidth: .infinity, alignment: .center)
                .lineLimit(1)
        }
        .padding(.horizontal, 8)
        .padding(.bottom, 40)
    }
}

#Preview("FeedRowView - Watch") {
    FeedRowView(post: .previewItem)
}

#Preview {
    FeedRootView(viewModel: .preview())
}
