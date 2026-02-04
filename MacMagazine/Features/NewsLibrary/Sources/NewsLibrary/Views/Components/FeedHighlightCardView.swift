import FeedLibrary
import MacMagazineLibrary
import SwiftUI
import UIComponentsLibrary

// MARK: - Feed Highlight Card View

/// Card view for featured/highlighted posts in the carousel.
/// Optimized for performance with reduced shadows and drawingGroup.
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
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        .compositingGroup()
        .shadow(color: .black.opacity(0.15), radius: 8, x: 0, y: 4)
        .drawingGroup()
        .accessibilityElement(children: .combine)
        .accessibilityLabel(accessibilityLabel)
        .accessibilityHint("Toque duas vezes para ler a notícia")
        .accessibilityAddTraits(.isButton)
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
                .init(color: .black.opacity(0.15), location: 0.5),
                .init(color: .black.opacity(0.75), location: 1.0)
            ]),
            startPoint: .top,
            endPoint: .bottom
        )
    }

    // MARK: - Content Overlay

    private var contentOverlay: some View {
        VStack(alignment: .leading, spacing: 6) {
            Spacer()

            Text(post.title)
                .font(.headline)
                .fontWeight(.semibold)
                .foregroundStyle(.white)
                .lineLimit(3)
                .multilineTextAlignment(.leading)

            dateLabel
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private var dateLabel: some View {
        HStack(spacing: 4) {
            Image(systemName: "calendar")
            Text(post.pubDate.toTimeAgoDisplay(showTime: true))
        }
        .font(.caption)
        .foregroundStyle(.white.opacity(0.8))
    }

    // MARK: - Accessibility

    private var accessibilityLabel: String {
        var label = post.title
        if post.favorite {
            label += ", favoritado"
        }
        label += ", publicado em \(post.pubDate.toTimeAgoDisplay(showTime: true)))"
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
                VStack(spacing: 20) {
                    Text("Tamanho reduzido")
                        .foregroundStyle(.white)
                        .font(.caption)

                    FeedHighlightCardView(post: post)
                        .frame(width: 320, height: 280)
                }
                .padding()
            }
        }
    }
}

#Preview("Card") {
    FeedHighlightCardPreview()
}

#Preview("Card Sizes") {
    ScrollView {
        VStack(spacing: 24) {
            if let post = PreviewData.sampleHighlights.first {
                Group {
                    VStack(spacing: 8) {
                        Text("iPhone Portrait (280pt)")
                            .font(.caption)
                        FeedHighlightCardView(post: post)
                            .frame(width: 340, height: 280)
                    }

                    VStack(spacing: 8) {
                        Text("iPhone Landscape (180pt)")
                            .font(.caption)
                        FeedHighlightCardView(post: post)
                            .frame(width: 400, height: 180)
                    }

                    VStack(spacing: 8) {
                        Text("iPad Portrait (320pt)")
                            .font(.caption)
                        FeedHighlightCardView(post: post)
                            .frame(width: 500, height: 320)
                    }

                    VStack(spacing: 8) {
                        Text("iPad Landscape (240pt)")
                            .font(.caption)
                        FeedHighlightCardView(post: post)
                            .frame(width: 380, height: 240)
                    }
                }
            }
        }
        .padding()
    }
    .background(Color.gray.opacity(0.2))
}
#endif
