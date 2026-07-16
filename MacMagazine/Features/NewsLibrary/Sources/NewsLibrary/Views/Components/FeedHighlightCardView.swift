import AnalyticsLibrary
import FeedLibrary
import MacMagazineLibrary
import MacMagazineUILibrary
import SwiftData
import SwiftUI

// MARK: - Feed Highlight Card View

/// Card view for featured/highlighted posts in the carousel.
/// Delegates rendering to the shared GlassCardView.
public struct FeedHighlightCardView: View {

    // MARK: - Properties

    let post: FeedDB

    @Environment(\.modelContext) private var modelContext
    @Environment(\.highlightPostRead) private var highlightPostRead
    @EnvironmentObject private var analytics: AnalyticsManager

    // MARK: - Body

    public var body: some View {
        let data = post.toCardContent(
            using: modelContext,
            analytics: analytics,
            screen: AnalyticsConstants.Screen.news.name,
            style: .header,
            aspectRatio: nil
        )
        GlassCardView(data: data)
            .opacity(post.read && highlightPostRead ? 0.6 : 1)
            .compositingGroup()
    }

    // MARK: - Init

    public init(post: FeedDB) {
        self.post = post
    }
}

// MARK: - Preview

#if DEBUG
#Preview("Card") {
    ZStack {
        Color.black.opacity(0.9).ignoresSafeArea()

        if let post = PreviewData.sampleHighlights.first {
            FeedHighlightCardView(post: post)
                .frame(width: 320, height: 280)
                .padding()
        }
    }
}
#endif
