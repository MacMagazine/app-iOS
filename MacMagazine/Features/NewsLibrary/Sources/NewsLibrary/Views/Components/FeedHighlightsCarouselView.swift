import FeedLibrary
import MacMagazineLibrary
import SwiftUI

// MARK: - Feed Highlights Carousel View

/// Carousel for featured posts with centered card and peek on edges.
/// Uses native ScrollView paging APIs for snap-to-card behavior.
public struct FeedHighlightsCarouselView: View {

    // MARK: - Properties

    let highlights: [FeedDB]
    let onTap: (FeedDB) -> Void

    @Binding var scrolledID: String?

    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    @Environment(\.verticalSizeClass) private var verticalSizeClass
    @Environment(\.isSidebarVisible) private var isSidebarVisible

    // MARK: - Layout Constants

    private enum Layout {
        // Card heights
        static let phonePortraitHeight: CGFloat = 280
        static let phoneLandscapeHeight: CGFloat = 180
        static let padHeight: CGFloat = 320

        // Spacing and peek
        static let spacing: CGFloat = 12
        static let phonePeek: CGFloat = 40
        static let padPeek: CGFloat = 60
    }

    // MARK: - Computed Properties

    private var isIPad: Bool {
        horizontalSizeClass == .regular && verticalSizeClass == .regular
    }

    private var isLandscape: Bool {
        verticalSizeClass == .compact
    }

    private var cardHeight: CGFloat {
        let height: CGFloat
        if isIPad {
            height = Layout.padHeight
        } else {
            height = isLandscape ? Layout.phoneLandscapeHeight : Layout.phonePortraitHeight
        }
        return max(height, 100)
    }

    private var peekWidth: CGFloat {
        isIPad ? Layout.padPeek : Layout.phonePeek
    }

    /// Number of visible cards based on device and sidebar visibility
    private var visibleCardCount: Int {
        guard isIPad else { return 1 }
        return isSidebarVisible ? 1 : 2
    }

    // MARK: - Initialization

    public init(
        highlights: [FeedDB],
        scrolledID: Binding<String?>,
        onTap: @escaping (FeedDB) -> Void
    ) {
        self.highlights = highlights
        self._scrolledID = scrolledID
        self.onTap = onTap
    }

    // MARK: - Body

    public var body: some View {
        ScrollView(.horizontal) {
            LazyHStack(spacing: Layout.spacing) {
                ForEach(highlights, id: \.postId) { post in
                    Button {
                        onTap(post)
                    } label: {
                        FeedHighlightCardView(post: post)
                            .containerRelativeFrame(
                                .horizontal,
                                count: visibleCardCount,
                                spacing: Layout.spacing
                            )
                    }
                    .scrollTransition(.interactive) { content, phase in
                        content
                            .scaleEffect(phase.isIdentity ? 1.0 : 0.95)
                            .opacity(phase.isIdentity ? 1.0 : 0.85)
                    }
                }
            }
            .scrollTargetLayout()
        }
        .scrollIndicators(.hidden)
        .scrollTargetBehavior(.viewAligned)
        .scrollPosition(id: $scrolledID)
        .safeAreaPadding(.horizontal, peekWidth)
        .frame(height: cardHeight)
    }
}

// MARK: - Preview

#if DEBUG
#Preview("iPhone Portrait") {
    ZStack {
        Color.gray.opacity(0.2).ignoresSafeArea()

        VStack {
            FeedHighlightsCarouselView(
                highlights: PreviewData.sampleHighlights,
                scrolledID: .constant(nil),
                onTap: { _ in }
            )

            Spacer()
        }
    }
}

#Preview("iPhone Landscape", traits: .landscapeLeft) {
    ZStack {
        Color.gray.opacity(0.2).ignoresSafeArea()

        VStack {
            FeedHighlightsCarouselView(
                highlights: PreviewData.sampleHighlights,
                scrolledID: .constant(nil),
                onTap: { _ in }
            )

            Spacer()
        }
    }
}

#Preview("iPad", traits: .landscapeLeft) {
    ZStack {
        Color.gray.opacity(0.2).ignoresSafeArea()

        VStack {
            FeedHighlightsCarouselView(
                highlights: PreviewData.sampleHighlights,
                scrolledID: .constant(nil),
                onTap: { _ in }
            )

            Spacer()
        }
    }
}
#endif
