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

    @Query(sort: \FeedDB.pubDate, order: .reverse)
    private var allNews: [FeedDB]

    /// Filtered highlights from allNews
    private var highlights: [FeedDB] {
        allNews.filter { $0.categories.contains("Destaques") }
    }

    /// Filtered news based on favorite and category
    private var news: [FeedDB] {
        var filtered = favorite ? allNews.filter { $0.favorite } : allNews

        if category != .all {
            filtered = filtered.filter { $0.categories.contains(category.filterKey) }
        }

        return filtered
    }

    /// Show highlights only when not filtering and category is "all"
    private var shouldShowHighlights: Bool {
        !favorite && category == .all && !highlights.isEmpty
    }

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

        CollectionViewWithHeader(
            title: "Notícias",
            status: viewModel.status,
            usesDensity: true,
            scrollPosition: $scrollPosition,
            favorite: favorite,
            isSearching: !search.isEmpty,
            quantity: search.isEmpty ? news.count : 0,
            header: {
                if shouldShowHighlights {
                    FeedHighlightsCarouselView(
                        highlights: Array(highlights.prefix(10)),
                        onTap: { _ in }
                    )
                }
            },
            content: {
                ForEach(
                    0..<news.count,
                    id: \.self
                ) { index in
                    NewsCard(data: news[index].toCardContent(
                        using: modelContext,
                        analytics: analytics,
                        screen: nil,
                        style: category.style
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

// MARK: - Preview

#if DEBUG
#Preview {
    NewsViewPreview()
}

private struct NewsViewPreview: View {
    @State private var favorite = false
    @State private var category: NewsCategory = .all
    @State private var scrollPosition = ScrollPosition()

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                FeedHighlightsCarouselView(
                    highlights: PreviewData.sampleHighlights,
                    onTap: { _ in }
                )
                .padding(.bottom, 16)

                Spacer()

                Text("CollectionView apareceria aqui")
                    .foregroundStyle(.secondary)

                Spacer()
            }
            .navigationTitle("Notícias")
        }
    }
}
#endif
