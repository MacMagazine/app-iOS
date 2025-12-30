import FeedLibrary
import SwiftUI
import UIKit

// MARK: - Feed Highlights Vertical View

/// Vertical carousel for highlight cards in landscape mode.
/// Shows centered card with peek of adjacent cards, same behavior as horizontal carousel.
struct FeedHighlightsVerticalView: View {

    // MARK: - Properties

    let highlights: [FeedDB]
    let isAutoScrollEnabled: Bool
    let onTap: (FeedDB) -> Void

    @Binding var currentIndex: Int

    @State private var dragOffset: CGFloat = 0
    @State private var timer: Timer?
    @State private var lastInteractionDate = Date()
    @State private var isAutoScrollPaused = false

    // MARK: - Layout Constants

    private enum Layout {
        static let horizontalPadding: CGFloat = 16
        static let spacing: CGFloat = 12
        static let peekHeight: CGFloat = 16

        // Rubber band effect
        static let rubberBandFactor: CGFloat = 0.3
        static let maxRubberBandDrag: CGFloat = 40

        // Auto-scroll timing
        static let autoScrollInterval: TimeInterval = 8.0
        static let pauseDuration: TimeInterval = 30.0
    }

    // MARK: - Initialization

    // MARK: - Initialization

    init(
        highlights: [FeedDB],
        currentIndex: Binding<Int>,
        isAutoScrollEnabled: Bool = false,
        onTap: @escaping (FeedDB) -> Void
    ) {
        self.highlights = highlights
        self._currentIndex = currentIndex
        self.isAutoScrollEnabled = isAutoScrollEnabled
        self.onTap = onTap
    }

    // MARK: - Body

    var body: some View {
        GeometryReader { geometry in
            let metrics = calculateCardMetrics(availableHeight: geometry.size.height)
            let cardWidth = geometry.size.width - (Layout.horizontalPadding * 2)

            ZStack {
                ForEach(Array(highlights.enumerated()), id: \.element.postId) { index, post in
                    cardView(
                        post: post,
                        index: index,
                        cardWidth: cardWidth,
                        metrics: metrics
                    )
                }
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
            .contentShape(Rectangle())
            .gesture(dragGesture)
        }
        .onAppear { startAutoScrollIfEnabled() }
        .onDisappear { stopAutoScroll() }
    }

    // MARK: - Card View

    @ViewBuilder
    private func cardView(
        post: FeedDB,
        index: Int,
        cardWidth: CGFloat,
        metrics: CardMetrics
    ) -> some View {
        let offset = calculateOffset(for: index, metrics: metrics)
        let scale = calculateScale(for: index)
        let opacity = calculateOpacity(for: index)

        FeedHighlightCardView(post: post)
            .frame(width: cardWidth, height: metrics.cardHeight)
            .scaleEffect(scale)
            .opacity(opacity)
            .offset(y: offset)
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

    // MARK: - Drag Gesture

    private var dragGesture: some Gesture {
        DragGesture()
            .onChanged { value in
                handleDragChanged(delta: value.translation.height)
            }
            .onEnded { value in
                handleDragEnded(
                    delta: value.translation.height,
                    velocity: value.predictedEndTranslation.height - value.translation.height
                )
            }
    }

    // MARK: - Card Metrics

    private struct CardMetrics {
        let cardHeight: CGFloat
        let totalCardSpace: CGFloat
    }

    private func calculateCardMetrics(availableHeight: CGFloat) -> CardMetrics {
        let cardHeight = availableHeight - (Layout.peekHeight * 2) - Layout.spacing
        let totalCardSpace = cardHeight + Layout.spacing
        return CardMetrics(cardHeight: cardHeight, totalCardSpace: totalCardSpace)
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

    private func calculateOffset(for index: Int, metrics: CardMetrics) -> CGFloat {
        let diff = index - currentIndex
        let baseOffset = CGFloat(diff) * metrics.totalCardSpace
        return baseOffset + dragOffset
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
#Preview("Vertical Highlights") {
    FeedHighlightsVerticalView(
        highlights: PreviewData.sampleHighlights,
        currentIndex: .constant(0),
        isAutoScrollEnabled: false,
        onTap: { _ in }
    )
    .background(Color.gray.opacity(0.1))
}

#Preview("Vertical Highlights - Landscape", traits: .landscapeLeft) {
    HStack(spacing: 0) {
        FeedHighlightsVerticalView(
            highlights: PreviewData.sampleHighlights,
            currentIndex: .constant(0),
            isAutoScrollEnabled: false,
            onTap: { _ in }
        )
        .frame(maxWidth: .infinity)
        .background(Color.gray.opacity(0.1))

        Divider()

        Rectangle()
            .fill(Color.blue.opacity(0.1))
            .frame(maxWidth: .infinity)
            .overlay(Text("Feed"))
    }
}
#endif
