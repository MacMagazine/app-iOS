import FeedLibrary
import MacMagazineLibrary
import SwiftUI
import UIComponentsLibrary

// MARK: - Feed Highlight Card View

/// Card view for featured/highlighted posts in the carousel
public struct FeedHighlightCardView: View {

    // MARK: - Properties

    let post: FeedDB

    @Environment(\.theme) private var theme: ThemeColor

    // MARK: - Body

    public var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .bottom) {
                backgroundImage
                    .frame(width: geometry.size.width, height: geometry.size.height)

                gradientOverlay

                contentOverlay
                    .frame(width: geometry.size.width)
            }
        }
        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
        .shadow(color: .black.opacity(0.3), radius: 12, x: 0, y: 6)
        .accessibilityElement(children: .combine)
        .accessibilityLabel(accessibilityLabel)
    }

    // MARK: - Background Image

    @ViewBuilder
    private var backgroundImage: some View {
        if let url = URL(string: post.artworkURL) {
            CachedAsyncImage(image: url, contentMode: .fill)
        } else {
            placeholderImage
        }
    }

    private var placeholderImage: some View {
        LinearGradient(
            colors: [.gray.opacity(0.4), .gray.opacity(0.6)],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }

    // MARK: - Gradient Overlay

    private var gradientOverlay: some View {
        LinearGradient(
            gradient: Gradient(stops: [
                .init(color: .clear, location: 0.0),
                .init(color: .black.opacity(0.2), location: 0.5),
                .init(color: .black.opacity(0.85), location: 1.0)
            ]),
            startPoint: .top,
            endPoint: .bottom
        )
    }

    // MARK: - Content Overlay

    private var contentOverlay: some View {
        VStack(alignment: .leading, spacing: 8) {
            Spacer()

            Text(post.title)
                .font(.title2)
                .fontWeight(.bold)
                .foregroundStyle(.white)
                .lineLimit(3)
                .multilineTextAlignment(.leading)

            dateLabel
        }
        .padding(20)
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private var dateLabel: some View {
        HStack(spacing: 6) {
            Image(systemName: "calendar")
            Text(post.pubDate.feedDateTimeDisplay)
        }
        .font(.subheadline)
        .foregroundStyle(.white.opacity(0.85))
    }

    // MARK: - Accessibility

    private var accessibilityLabel: String {
        var label = post.title
        if post.favorite {
            label += ", favoritado"
        }
        label += ", publicado em \(post.pubDate.formatted(as: "dd 'de' MMMM 'de' yyyy 'às' HH:mm"))"
        return label
    }

    // MARK: - Init

    public init(post: FeedDB) {
        self.post = post
    }
}

// MARK: - Preview

#if DEBUG
private struct FeedHighlightCardPreview: View {
    var body: some View {
        ZStack {
            Color.black.opacity(0.9).ignoresSafeArea()

            if let post = PreviewData.sampleHighlights.first {
                FeedHighlightCardView(post: post)
                    .frame(width: 340, height: 420)
                    .padding()
            }
        }
    }
}

#Preview {
    FeedHighlightCardPreview()
}
#endif
