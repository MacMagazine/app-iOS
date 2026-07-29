import AnalyticsLibrary
import FeedLibrary
import MacMagazineLibrary
import MacMagazineUILibrary
import SwiftData
import SwiftUI

struct DeepLinkNewsDetailView: View {
    @Environment(\.modelContext) private var modelContext
    @EnvironmentObject private var analytics: AnalyticsManager

    @Query(sort: \FeedDB.pubDate, order: .reverse) private var allNews: [FeedDB]

    let url: String
    let onDismiss: () -> Void

    private var post: FeedDB? {
        let link = url.removingPercentEncoding ?? url
        return allNews.first(where: { $0.link == link })
    }

    var body: some View {
        NavigationStack {
            MMWebView(url: url)
                .trackScreen(
                    AnalyticsConstants.Screen.deepLinkDetail.name,
                    previous: nil,
                    analytics: analytics
                )
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        Button(action: onDismiss,
                               label: { Image(systemName: "xmark") })
                        .tint(.primary)
                        .accessibilityLabel("Fechar")
                    }
                    ToolbarItem(placement: .automatic) {
                        favoriteView
                    }
                    .sharedBackgroundVisibility(.hidden)
                    ToolbarItem(placement: .automatic) {
                        shareView
                    }
                    .sharedBackgroundVisibility(.hidden)
                }
                .onAppear {
                    post?.markAsRead()
                    try? modelContext.save()
                }
        }
    }

    @ViewBuilder
    private var favoriteView: some View {
        if let post {
            FavoriteButton(
                favorite: post.favorite,
                action: {
                    post.toggleFavorite()
                    try? modelContext.save()
                    analytics.track(.buttonTap(
                        buttonId: AnalyticsConstants.ButtonID.newsFavorite.id,
                        screen: AnalyticsConstants.Screen.news.name
                    ))
                }
            )
            .minimumTouchTarget()
        }
    }

    @ViewBuilder
    private var shareView: some View {
        ShareButton(
            title: post?.title ?? "",
            url: url
        )
        .minimumTouchTarget()
    }
}
