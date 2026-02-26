import FeedLibrary
import SwiftUI

// MARK: - Feed Highlights Vertical View

/// Vertical carousel for highlight cards in landscape mode.
/// Uses native ScrollView paging APIs for snap-to-card behavior.
struct FeedHighlightsVerticalView: View {

    // MARK: - Properties

    let highlights: [FeedDB]
    let isAutoScrollEnabled: Bool
    let onTap: (FeedDB) -> Void

    @Binding var scrolledID: String?

    @State private var timer: Timer?
    @State private var lastInteractionDate = Date()
    @State private var isAutoScrollPaused = false

    // MARK: - Layout Constants

    private enum Layout {
        static let horizontalPadding: CGFloat = 16
        static let spacing: CGFloat = 12
        static let peekHeight: CGFloat = 16

        // Auto-scroll timing
        static let autoScrollInterval: TimeInterval = 8.0
        static let pauseDuration: TimeInterval = 30.0
    }

    // MARK: - Initialization

    init(
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

    var body: some View {
        ScrollView(.vertical) {
            LazyVStack(spacing: Layout.spacing) {
                ForEach(highlights, id: \.postId) { post in
                    Button {
                        onTap(post)
                    } label: {
                        FeedHighlightCardView(post: post)
                            .containerRelativeFrame(.vertical, count: 1, spacing: Layout.spacing)
                            .padding(.horizontal, Layout.horizontalPadding)
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
        .safeAreaPadding(.vertical, Layout.peekHeight)
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
#Preview("Vertical Highlights") {
    FeedHighlightsVerticalView(
        highlights: PreviewData.sampleHighlights,
        scrolledID: .constant(nil),
        isAutoScrollEnabled: false,
        onTap: { _ in }
    )
    .background(Color.gray.opacity(0.1))
}

#Preview("Vertical Highlights - Landscape", traits: .landscapeLeft) {
    HStack(spacing: 0) {
        FeedHighlightsVerticalView(
            highlights: PreviewData.sampleHighlights,
            scrolledID: .constant(nil),
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
