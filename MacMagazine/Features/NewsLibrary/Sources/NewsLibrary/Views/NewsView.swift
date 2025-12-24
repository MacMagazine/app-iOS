import AnalyticsLibrary
import FeedLibrary
import MacMagazineLibrary
import MacMagazineUILibrary
import StorageLibrary
import SwiftData
import SwiftUI
import UIComponentsLibrary

public struct NewsView: View {
    @Environment(\.theme) private var theme: ThemeColor
    @Environment(\.modelContext) private var modelContext
    @EnvironmentObject private var sessionState: SessionState
    @EnvironmentObject private var analytics: AnalyticsManager

    var viewModel: NewsViewModel

    @Binding private var favorite: Bool
    @Binding private var category: NewsCategory
    @Binding var scrollPosition: ScrollPosition

    @State private var search: String = ""

    @Query private var news: [FeedDB]

    public init(
        storage: Database,
        favorite: Binding<Bool>,
        category: Binding<NewsCategory>,
        scrollPosition: Binding<ScrollPosition>
    ) {
        self.viewModel = NewsViewModel(storage: storage)
        _favorite = favorite
        _category = category
        _scrollPosition = scrollPosition

        let favorite = favorite.wrappedValue
        let predicate = #Predicate<FeedDB> {
            $0.favorite == favorite
        }
        _news = Query(
            filter: favorite ? predicate : nil,
            sort: \FeedDB.pubDate,
            order: .reverse,
            animation: .smooth
        )
    }

    public var body: some View {
        content
            .refreshable {
                if search.isEmpty {
                    try? await viewModel.getNews()
                }
            }
            .task {
                if viewModel.status == .idle && !sessionState.hasFetchedFeed {
                    try? await viewModel.getNews(status: .loading)
                    sessionState.hasFetchedFeed = true
                }
            }
    }
}
extension NewsView {
    @ViewBuilder
    var content: some View {
        let retryAction: () -> Void = {
            Task {
                try? await viewModel.getNews()
            }
        }

        let news = if category == .all {
            news
        } else {
            news.filter { $0.categories.contains(category.filterKey) }
        }

        CollectionView(
            title: "Notícias",
            status: viewModel.status,
            usesDensity: true,
            scrollPosition: $scrollPosition,
            favorite: favorite,
            isSearching: !search.isEmpty,
            quantity: search.isEmpty ? news.count : 0,
            content: {
                ForEach(
                    0..<news.count,
                    id: \.self
                ) { index in
                    NewsCardView(data: news[index].toCardContent(
                        using: modelContext,
                        analytics: analytics,
                        screen: nil
                    )) {
                        analytics.track(.buttonTap(
                            buttonId: AnalyticsConstants.ButtonID.newsStarted(postId: Int(news[index].postId) ?? 0).id,
                            screen: AnalyticsConstants.Screen.news.name
                        ))
                    }
                    .onAppear {
                        if !favorite && search.isEmpty {
                            viewModel.loadMoreIfNeeded(index: index)
                        }
                    }
                }
            },
            retryAction: favorite ? nil : retryAction
        )
    }
}
