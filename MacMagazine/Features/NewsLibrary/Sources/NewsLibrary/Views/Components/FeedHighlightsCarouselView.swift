import FeedLibrary
import MacMagazineLibrary
import SwiftUI
import UIKit

// MARK: - Feed Highlights Carousel View

/// Auto-scrolling carousel for featured posts with large centered card and peek on edges
public struct FeedHighlightsCarouselView: View {

    // MARK: - Properties

    let highlights: [FeedDB]
    let sectionId: String
    let heroNamespace: Namespace.ID?
    let onTap: (FeedDB) -> Void

    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    @Environment(\.verticalSizeClass) private var verticalSizeClass

    @State private var currentIndex: Int = 0
    @State private var timer: Timer?
    @State private var lastInteractionDate = Date()
    @State private var isAutoScrollPaused = false
    @State private var dragOffset: CGFloat = 0

    // Auto-scroll settings
    private let autoScrollInterval: TimeInterval = 10.0
    private let pauseDuration: TimeInterval = 30.0

    // MARK: - Computed Properties

    /// Check if device is in landscape mode
    private var isLandscape: Bool {
        verticalSizeClass == .compact
    }

    /// Check if running on iPad
    private var isIPad: Bool {
        horizontalSizeClass == .regular && verticalSizeClass == .regular
    }

    /// Card height based on orientation
    private var cardHeight: CGFloat {
        if isIPad {
            return 500
        }
        return isLandscape ? 240 : 420
    }

    /// Spacing between cards
    private var spacing: CGFloat {
        if isIPad {
            return 20
        }
        return isLandscape ? 24 : 0
    }

    /// Peek width (visible portion of adjacent cards)
    private var peekWidth: CGFloat {
        if isIPad {
            return 80
        }
        return isLandscape ? 10 : 25
    }

    // MARK: - Initialization

    public init(
        highlights: [FeedDB],
        sectionId: String = "highlights",
        heroNamespace: Namespace.ID? = nil,
        onTap: @escaping (FeedDB) -> Void
    ) {
        self.highlights = highlights
        self.sectionId = sectionId
        self.heroNamespace = heroNamespace
        self.onTap = onTap
    }

    // MARK: - Body

    public var body: some View {
        GeometryReader { geometry in
            let screenWidth = geometry.size.width
            let cardWidth = screenWidth - (peekWidth * 2) - spacing

            ZStack {
                ForEach(Array(highlights.enumerated()), id: \.element.postId) { index, post in
                    let offset = calculateOffset(
                        for: index,
                        currentIndex: currentIndex,
                        cardWidth: cardWidth,
                        spacing: spacing,
                        dragOffset: dragOffset
                    )

                    let scale = calculateScale(for: index, currentIndex: currentIndex)
                    let opacity = calculateOpacity(for: index, currentIndex: currentIndex)

                    FeedHighlightCardView(post: post)
                        .frame(width: cardWidth, height: cardHeight)
                        .scaleEffect(scale)
                        .opacity(opacity)
                        .offset(x: offset)
                        .zIndex(index == currentIndex ? 1 : 0)
                        .allowsHitTesting(index == currentIndex)
                        .contentShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                        .onTapGesture {
                            guard index == currentIndex else { return }
                            onTap(post)
                        }
                        .animation(.easeInOut(duration: 0.3), value: currentIndex)
                        .animation(.interactiveSpring(response: 0.3, dampingFraction: 0.8), value: dragOffset)
                }
            }
            .frame(width: screenWidth, height: cardHeight + 20)
            .contentShape(Rectangle())
            .overlay {
                HorizontalPanCaptureView(
                    onTap: {
                        guard highlights.indices.contains(currentIndex) else { return }
                        onTap(highlights[currentIndex])
                    },
                    onChanged: { value in
                        pauseAutoScroll()
                        dragOffset = value
                    },
                    onEnded: { translationX, velocityX in
                        handlePanEnded(translationX: translationX,
                                       velocityX: velocityX)
                    }
                )
            }
        }
        .frame(height: cardHeight + 20)
        .onAppear { startAutoScroll() }
        .onDisappear { stopAutoScroll() }
    }

    // MARK: - Pan Handling (UIKit)

    private func handlePanEnded(translationX: CGFloat, velocityX: CGFloat) {
        let threshold: CGFloat = 50

        withAnimation(.easeInOut(duration: 0.3)) {
            if translationX < -threshold || velocityX < -600 {
                if currentIndex < highlights.count - 1 {
                    currentIndex += 1
                }
            } else if translationX > threshold || velocityX > 600 {
                if currentIndex > 0 {
                    currentIndex -= 1
                }
            }
            dragOffset = 0
        }
    }

    // MARK: - Layout Calculations

    private func calculateOffset(
        for index: Int,
        currentIndex: Int,
        cardWidth: CGFloat,
        spacing: CGFloat,
        dragOffset: CGFloat
    ) -> CGFloat {
        let diff = index - currentIndex
        let baseOffset = CGFloat(diff) * (cardWidth + spacing)
        return baseOffset + dragOffset
    }

    private func calculateScale(for index: Int, currentIndex: Int) -> CGFloat {
        index == currentIndex ? 1.0 : 0.92
    }

    private func calculateOpacity(for index: Int, currentIndex: Int) -> Double {
        let diff = abs(index - currentIndex)
        switch diff {
        case 0: return 1.0
        case 1: return 0.7
        case 2: return 0.4
        default: return 0
        }
    }

    // MARK: - Auto Scroll Control

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
        lastInteractionDate = Date()
        isAutoScrollPaused = true
    }

    private func checkAndAdvance() {
        let timeSinceInteraction = Date().timeIntervalSince(lastInteractionDate)

        if isAutoScrollPaused {
            if timeSinceInteraction >= pauseDuration {
                isAutoScrollPaused = false
                lastInteractionDate = Date()
            }
            return
        }

        if timeSinceInteraction >= autoScrollInterval {
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
                onTap: { _ in }
            )

            Spacer()
        }
    }
}
#endif
