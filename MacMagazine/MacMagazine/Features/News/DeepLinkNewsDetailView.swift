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
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        Button {
                            onDismiss()
                        } label: {
                            Image(systemName: "xmark")
                        }
                    }
                    ToolbarItem(placement: .topBarTrailing) {
                        HStack(spacing: 20) {
                            favoriteView
                            shareView
                        }.padding(.horizontal)
                    }
                }
        }
    }

    @ViewBuilder
    private var favoriteView: some View {
        if let post {
            FavoriteButton(
                name: post.title,
                favorite: post.favorite,
                action: {
                    post.favorite.toggle()
                    post.modifiedAt = Date()
                    try? modelContext.save()
                    analytics.track(.buttonTap(
                        buttonId: AnalyticsConstants.ButtonID.newsFavorite.id,
                        screen: AnalyticsConstants.Screen.news.name
                    ))
                }
            )
        }
    }

    @ViewBuilder
    private var shareView: some View {
        ShareButton(
            title: post?.title ?? "",
            url: url,
            action: {
                analytics.track(
                    .buttonTap(
                        buttonId: AnalyticsConstants.ButtonID.share.id,
                        screen: AnalyticsConstants.Screen.news.name
                    )
                )
            }
        )
    }
}
