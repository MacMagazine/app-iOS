import AnalyticsLibrary
import FeedLibrary
import MacMagazineLibrary
import MacMagazineUILibrary
import SwiftData
import SwiftUI

// MARK: - Feed Highlight Card View

/// Card view for featured/highlighted posts in the carousel.
/// Delegates rendering to the shared GlassCardView.
struct FeedHighlightCardView: View {

    // MARK: - Properties

    let post: FeedDB
    let onTap: ((FeedDB) -> Void)?

    @Environment(\.modelContext) private var modelContext
    @Environment(\.highlightPostRead) private var highlightPostRead
    @EnvironmentObject private var analytics: AnalyticsManager

    // MARK: - Body

    var body: some View {
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
            .cardAccessibility(
                data: data,
                labels: [.title, .dateWithTime, .author] + (highlightPostRead ? [.read] : []) + [.favorite],
                buttons: (highlightPostRead ? [.read] : []) + [.favorite, .share],
                hint: "Duplo toque para abrir a notícia."
            )
            .peekAndPop(
                item: post,
                open: onTap,
                favorite: data.favoriteAction,
                read: highlightPostRead ? data.readAction : nil
            )
    }

    // MARK: - Init

    public init(
        post: FeedDB,
        onTap: ((FeedDB) -> Void)? = nil
    ) {
        self.post = post
        self.onTap = onTap
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
