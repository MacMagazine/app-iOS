import FeedLibrary
import MacMagazineLibrary
import SwiftUI

// MARK: - Feed Highlights Carousel View

/// Carousel for featured posts with centered card and peek on edges.
/// Uses native ScrollView paging APIs for snap-to-card behavior.
public struct FeedHighlightsCarouselView: View {

    // MARK: - Properties

    let highlights: [FeedDB]
    let isAutoScrollEnabled: Bool
    let onTap: (FeedDB) -> Void

    @Binding var scrolledID: String?

    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    @Environment(\.verticalSizeClass) private var verticalSizeClass
    @Environment(\.isSidebarVisible) private var isSidebarVisible

    @State private var timer: Timer?
    @State private var lastInteractionDate = Date()
    @State private var isAutoScrollPaused = false

    // MARK: - Layout Constants

    private enum Layout {
        // Card heights
        static let phonePortraitHeight: CGFloat = 280
        static let phoneLandscapeHeight: CGFloat = 180
        static let padPortraitHeight: CGFloat = 320
        static let padLandscapeHeight: CGFloat = 240

        // Spacing and peek
        static let spacing: CGFloat = 12
        static let phonePeek: CGFloat = 40
        static let padPeek: CGFloat = 60

        // Auto-scroll timing
        static let autoScrollInterval: TimeInterval = 8.0
        static let pauseDuration: TimeInterval = 30.0
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
            height = Layout.padPortraitHeight
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
        isAutoScrollEnabled: Bool = false,
        onTap: @escaping (FeedDB) -> Void
    ) {
        self.highlights = highlights
        self._scrolledID = scrolledID
        self.isAutoScrollEnabled = isAutoScrollEnabled
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
                            .frame(height: cardHeight)
                    }
                    .buttonStyle(.plain)
                    .scrollTransition(.interactive) { content, phase in
                        content
                            .scaleEffect(phase.isIdentity ? 1.0 : 0.95)
                            .opacity(phase.isIdentity ? 1.0 : 0.85)
                    }
                }
            }
            .scrollTargetLayout()
        }
        .scrollTargetBehavior(.viewAligned)
        .scrollPosition(id: $scrolledID)
        .safeAreaPadding(.horizontal, peekWidth)
        .frame(height: cardHeight)
        .onScrollPhaseChange { _, newPhase in
            if newPhase == .interacting {
                pauseAutoScroll()
            }
        }
        .onAppear { startAutoScrollIfEnabled() }
        .onDisappear { stopAutoScroll() }
    }

    // MARK: - Auto Scroll

    private func startAutoScrollIfEnabled() {
        guard isAutoScrollEnabled else { return }
        startAutoScroll()
    }

    private func startAutoScroll() {
        stopAutoScroll()

        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            Task { @MainActor in
                checkAndAdvance()
            }
        }
    }

    private func stopAutoScroll() {
        timer?.invalidate()
        timer = nil
    }

    private func pauseAutoScroll() {
        guard isAutoScrollEnabled else { return }
        lastInteractionDate = Date()
        isAutoScrollPaused = true
    }

    private func checkAndAdvance() {
        let timeSinceInteraction = Date().timeIntervalSince(lastInteractionDate)

        if isAutoScrollPaused {
            if timeSinceInteraction >= Layout.pauseDuration {
                isAutoScrollPaused = false
                lastInteractionDate = Date()
            }
            return
        }

        if timeSinceInteraction >= Layout.autoScrollInterval {
            advanceToNextSlide()
            lastInteractionDate = Date()
        }
    }

    private func advanceToNextSlide() {
        guard !highlights.isEmpty else { return }

        let currentIdx = highlights.firstIndex(where: { $0.postId == scrolledID }) ?? 0
        let nextIdx = currentIdx + 1 < highlights.count ? currentIdx + 1 : 0

        withAnimation(.easeInOut(duration: 0.5)) {
            scrolledID = highlights[nextIdx].postId
        }
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
                isAutoScrollEnabled: false,
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
                isAutoScrollEnabled: false,
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
                isAutoScrollEnabled: false,
                onTap: { _ in }
            )

            Spacer()
        }
    }
}
#endif
