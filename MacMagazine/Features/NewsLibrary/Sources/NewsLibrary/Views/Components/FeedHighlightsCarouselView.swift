import FeedLibrary
import MacMagazineLibrary
import SwiftUI
import UIKit

// MARK: - Feed Highlights Carousel View

/// Carousel for featured posts with centered card and peek on edges
public struct FeedHighlightsCarouselView: View {

    // MARK: - Properties

    let highlights: [FeedDB]
    let isAutoScrollEnabled: Bool
    let onTap: (FeedDB) -> Void

    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    @Environment(\.verticalSizeClass) private var verticalSizeClass
    @Environment(\.isSidebarVisible) private var isSidebarVisible

    @State private var currentIndex: Int = 0
    @State private var dragOffset: CGFloat = 0
    @State private var timer: Timer?
    @State private var lastInteractionDate = Date()
    @State private var isAutoScrollPaused = false
    @State private var containerWidth: CGFloat = 0

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
        static let padLeadingPadding: CGFloat = 16

        // Rubber band effect
        static let rubberBandFactor: CGFloat = 0.3
        static let maxRubberBandDrag: CGFloat = 40

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

    /// Detect iPad landscape by width (landscape is wider than 900pt typically)
    private func isIPadLandscapeMode(screenWidth: CGFloat) -> Bool {
        isIPad && screenWidth > 900
    }

    private var cardHeight: CGFloat {
        let height: CGFloat
        if isIPad {
            // Use containerWidth for landscape detection
            let isLandscapeMode = containerWidth > 900
            height = isLandscapeMode ? Layout.padLandscapeHeight : Layout.padPortraitHeight
        } else {
            height = isLandscape ? Layout.phoneLandscapeHeight : Layout.phonePortraitHeight
        }
        return max(height, 100)
    }

    private var peekWidth: CGFloat {
        isIPad ? Layout.padPeek : Layout.phonePeek
    }

    /// Number of visible cards based on device, orientation and sidebar visibility
    /// - Portrait with sidebar: 1 card
    /// - Portrait without sidebar: 2 cards
    /// - Landscape (with or without sidebar): 2 cards
    private func visibleCardCount(for screenWidth: CGFloat) -> Int {
        guard isIPad else { return 1 }

        // Detect landscape by screen width (> 900pt is typically landscape on iPad)
        let isLandscapeMode = screenWidth > 900

        if isLandscapeMode {
            return 2
        } else {
            return isSidebarVisible ? 1 : 2
        }
    }

    // MARK: - Initialization

    public init(
        highlights: [FeedDB],
        isAutoScrollEnabled: Bool = false,
        onTap: @escaping (FeedDB) -> Void
    ) {
        self.highlights = highlights
        self.isAutoScrollEnabled = isAutoScrollEnabled
        self.onTap = onTap
    }

    // MARK: - Body

    public var body: some View {
        GeometryReader { geometry in
            let metrics = calculateCardMetrics(screenWidth: geometry.size.width)

            ZStack {
                ForEach(Array(highlights.enumerated()), id: \.element.postId) { index, post in
                    cardView(
                        post: post,
                        index: index,
                        metrics: metrics,
                        screenWidth: geometry.size.width
                    )
                }
            }
            .frame(width: geometry.size.width, height: cardHeight)
            .contentShape(Rectangle())
            .overlay {
                HorizontalPanCaptureView(
                    onTap: {
                        guard highlights.indices.contains(currentIndex) else { return }
                        onTap(highlights[currentIndex])
                    },
                    onChanged: { delta in
                        handleDragChanged(delta: delta)
                    },
                    onEnded: { delta, velocity in
                        handleDragEnded(delta: delta, velocity: velocity)
                    }
                )
            }
            .onAppear {
                containerWidth = geometry.size.width
            }
            .onChange(of: geometry.size.width) { _, newWidth in
                containerWidth = newWidth
            }
        }
        .frame(height: cardHeight)
        .onAppear { startAutoScrollIfEnabled() }
        .onDisappear { stopAutoScroll() }
    }

    // MARK: - Card View

    @ViewBuilder
    private func cardView(
        post: FeedDB,
        index: Int,
        metrics: CardMetrics,
        screenWidth: CGFloat
    ) -> some View {
        let offset = calculateOffset(for: index, metrics: metrics, screenWidth: screenWidth)
        let scale = calculateScale(for: index)
        let opacity = calculateOpacity(for: index)

        FeedHighlightCardView(post: post)
            .frame(width: metrics.cardWidth, height: cardHeight)
            .scaleEffect(scale)
            .opacity(opacity)
            .offset(x: offset)
            .zIndex(index == currentIndex ? 1 : 0)
            .allowsHitTesting(index == currentIndex)
            .contentShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
            .onTapGesture {
                guard index == currentIndex else { return }
                onTap(post)
            }
            .animation(.easeOut(duration: 0.25), value: currentIndex)
            .animation(.interactiveSpring(response: 0.25, dampingFraction: 0.85), value: dragOffset)
    }

    // MARK: - Card Metrics

    private struct CardMetrics {
        let cardWidth: CGFloat
        let totalCardSpace: CGFloat
        let initialOffset: CGFloat
    }

    private func calculateCardMetrics(screenWidth: CGFloat) -> CardMetrics {
        let cardWidth: CGFloat
        let initialOffset: CGFloat
        let cardCount = visibleCardCount(for: screenWidth)

        if isIPad {
            // iPad: align to leading edge with peek on right
            let availableWidth = screenWidth - Layout.padLeadingPadding - Layout.padPeek
            let spacingTotal = Layout.spacing * CGFloat(max(cardCount - 1, 0))
            let calculated = (availableWidth - spacingTotal) / CGFloat(max(cardCount, 1))
            cardWidth = max(calculated, 100)
            initialOffset = 0
        } else {
            // iPhone: single card centered with peek on both sides
            let availableWidth = screenWidth - (peekWidth * 2)
            cardWidth = max(availableWidth, 100)
            initialOffset = 0
        }

        let totalCardSpace = cardWidth + Layout.spacing

        return CardMetrics(cardWidth: cardWidth, totalCardSpace: totalCardSpace, initialOffset: initialOffset)
    }

    // MARK: - Drag Handling

    private func handleDragChanged(delta: CGFloat) {
        pauseAutoScroll()

        let isAtStart = currentIndex == 0
        let isAtEnd = currentIndex >= highlights.count - 1

        // Apply rubber band effect at boundaries
        if (isAtStart && delta > 0) || (isAtEnd && delta < 0) {
            let rubberBandDelta = rubberBand(delta: delta)
            dragOffset = rubberBandDelta
        } else {
            dragOffset = delta
        }
    }

    private func handleDragEnded(delta: CGFloat, velocity: CGFloat) {
        let threshold: CGFloat = 50
        let velocityThreshold: CGFloat = 500

        withAnimation(.easeOut(duration: 0.25)) {
            let shouldAdvance = delta < -threshold || velocity < -velocityThreshold
            let shouldRetreat = delta > threshold || velocity > velocityThreshold

            if shouldAdvance && currentIndex < highlights.count - 1 {
                currentIndex += 1
            } else if shouldRetreat && currentIndex > 0 {
                currentIndex -= 1
            }

            dragOffset = 0
        }
    }

    /// Rubber band effect for edge resistance
    private func rubberBand(delta: CGFloat) -> CGFloat {
        let sign: CGFloat = delta > 0 ? 1 : -1
        let magnitude = abs(delta)
        let dampened = magnitude * Layout.rubberBandFactor
        let capped = min(dampened, Layout.maxRubberBandDrag)
        return sign * capped
    }

    // MARK: - Layout Calculations

    private func calculateOffset(for index: Int, metrics: CardMetrics, screenWidth: CGFloat) -> CGFloat {
        if isIPad {
            // iPad: align cards to leading edge with peek on right
            let leadingEdge = -screenWidth / 2 + Layout.padLeadingPadding + metrics.cardWidth / 2
            let cardPosition = leadingEdge + CGFloat(index) * metrics.totalCardSpace
            let scrollOffset = CGFloat(currentIndex) * metrics.totalCardSpace
            return cardPosition - scrollOffset + dragOffset
        } else {
            // iPhone: centered card behavior
            let diff = index - currentIndex
            let baseOffset = CGFloat(diff) * metrics.totalCardSpace
            return baseOffset + dragOffset
        }
    }

    private func calculateScale(for index: Int) -> CGFloat {
        index == currentIndex ? 1.0 : 0.95
    }

    private func calculateOpacity(for index: Int) -> Double {
        let diff = abs(index - currentIndex)
        switch diff {
        case 0:
            return 1.0
        case 1:
            return 0.85
        case 2:
            return 0.5
        default:
            return 0
        }
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

        withAnimation(.easeInOut(duration: 0.5)) {
            if currentIndex < highlights.count - 1 {
                currentIndex += 1
            } else {
                currentIndex = 0
            }
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
                isAutoScrollEnabled: false,
                onTap: { _ in }
            )

            Spacer()
        }
    }
}
#endif
