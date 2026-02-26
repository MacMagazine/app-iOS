import AnalyticsLibrary
import FeedLibrary
import MacMagazineLibrary
import MacMagazineUILibrary
import StorageLibrary
import SwiftData
import SwiftUI
import UIComponentsLibrary

// MARK: - News View

public struct NewsView: View {

    // MARK: - Feature Flags

    /// Enable or disable auto-scroll for highlights carousel.
    /// Set to `true` to enable automatic advancement of cards.
    private let isAutoScrollEnabled = false

    // MARK: - Environment

    @Environment(\.theme) private var theme: ThemeColor
    @Environment(\.modelContext) private var modelContext
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    @Environment(\.verticalSizeClass) private var verticalSizeClass

    @EnvironmentObject private var sessionState: SessionState
    @EnvironmentObject private var analytics: AnalyticsManager

    // MARK: - Properties

    var viewModel: NewsViewModel

    @Binding private var favorite: Bool
    @Binding private var category: NewsCategory
    @Binding var scrollPosition: ScrollPosition

    @State private var search: String = ""
    @State private var readingNews = false

    @State private var scrolledHighlightID: String?

    @Query(sort: \FeedDB.pubDate, order: .reverse)
    private var allNews: [FeedDB]

    // MARK: - Initialization

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

    // MARK: - Body

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
            .navigationDestination(isPresented: $readingNews) {
                newsDetailView
            }
    }
}

// MARK: - Content

extension NewsView {
    @ViewBuilder
    var content: some View {
        if isLandscape && shouldShowHighlights {
            landscapeContent
        } else {
            portraitContent
        }
    }

    // MARK: - Portrait Layout

    @ViewBuilder
    private var portraitContent: some View {
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
                        highlights: Array(highlights.prefix(highlightsLimit)),
                        scrolledID: $scrolledHighlightID,
                        isAutoScrollEnabled: isAutoScrollEnabled,
                        onTap: { post in
                            handleTap(post)
                        }
                    )
                }
            },
            content: {
                newsCards
            },
            retryAction: favorite ? nil : retryAction
        )
    }

    // MARK: - Landscape Layout

    @ViewBuilder
    private var landscapeContent: some View {
        let retryAction: () -> Void = {
            Task {
                try? await viewModel.getNews()
            }
        }

        HStack(spacing: 0) {
            // Left column: Highlights (vertical scroll)
            FeedHighlightsVerticalView(
                highlights: Array(highlights.prefix(highlightsLimit)),
                scrolledID: $scrolledHighlightID,
                isAutoScrollEnabled: isAutoScrollEnabled,
                onTap: { post in
                    handleTap(post)
                }
            )
            .frame(maxWidth: .infinity)

            Divider()

            // Right column: Feed
            CollectionViewWithHeader(
                title: "Notícias",
                status: viewModel.status,
                usesDensity: true,
                scrollPosition: $scrollPosition,
                favorite: favorite,
                isSearching: !search.isEmpty,
                quantity: search.isEmpty ? news.count : 0,
                content: {
                    newsCards
                },
                retryAction: favorite ? nil : retryAction
            )
            .frame(maxWidth: .infinity)
        }
    }

    // MARK: - News Cards

    @ViewBuilder
    private var newsCards: some View {
        ForEach(0..<news.count, id: \.self) { index in
            Group {
                if !shouldShowHighlights,
                   news[index].categories.contains("NewsCategoryHighlights") {
                    FeedHighlightCardView(post: news[index])
                        .frame(height: 240)
                } else {
                    NewsCard(data: news[index].toCardContent(using: modelContext,
                                                             analytics: analytics,
                                                             screen: nil,
                                                             style: category.style)) {
                        handleTap(news[index])
                    }
                }
            }
            .onAppear {
                if !favorite && search.isEmpty {
                    viewModel.loadMoreIfNeeded(index: index)
                }
            }
        }
    }
}

// MARK: - Actions

extension NewsView {
    private func handleTap(_ post: FeedDB) {
        viewModel.selectedNews = post
        readingNews.toggle()

        analytics.track(.buttonTap(
            buttonId: AnalyticsConstants.ButtonID.newsStarted(postId: Int(post.postId) ?? 0).id,
            screen: AnalyticsConstants.Screen.news.name)
        )
    }
}

// MARK: - Details

extension NewsView {
    @ViewBuilder
    var newsDetailView: some View {
        MMWebView(url: viewModel.selectedNews?.link)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    HStack(spacing: 20) {
                        favoriteView
                        shareView
                    }.padding(.horizontal)
                }
            }
    }

    @ViewBuilder
    var favoriteView: some View {
        if let data = viewModel.selectedNews?.toCardContent(using: modelContext,
                                                            analytics: analytics,
                                                            screen: nil,
                                                            style: category.style) {
            FavoriteButton(
                name: data.title,
                favorite: data.favorite,
                action: data.favoriteAction
            )
        }
    }

    @ViewBuilder
    var shareView: some View {
        if let title = viewModel.selectedNews?.title,
           let url = viewModel.selectedNews?.link {
            ShareButton(
                title: title,
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
}

// MARK: - Computed Properties

extension NewsView {

    /// Check if device is iPad
    private var isIPad: Bool {
        horizontalSizeClass == .regular && verticalSizeClass == .regular
    }

    /// Check if device is in landscape mode (iPhone only)
    private var isLandscape: Bool {
        verticalSizeClass == .compact
    }

    /// Number of highlights to show (30 for iPad, 10 for iPhone)
    private var highlightsLimit: Int {
        isIPad ? 30 : 10
    }

    /// Filtered highlights from allNews
    private var highlights: [FeedDB] {
        allNews.filter { $0.categories.contains("NewsCategoryHighlights") }
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
}

// MARK: - Preview

#if DEBUG
#Preview("Portrait") {
    NewsViewPreview()
}

#Preview("Landscape", traits: .landscapeLeft) {
    NewsViewPreview()
}

private struct NewsViewPreview: View {
    @State private var favorite = false
    @State private var category: NewsCategory = .all
    @State private var scrollPosition = ScrollPosition()

    var body: some View {
        NavigationStack {
            NewsViewPreviewContent(
                favorite: $favorite,
                category: $category,
                scrollPosition: $scrollPosition
            )
            .navigationTitle("Notícias")
        }
    }
}

private struct NewsViewPreviewContent: View {
    @Environment(\.verticalSizeClass) private var verticalSizeClass

    @Binding var favorite: Bool
    @Binding var category: NewsCategory
    @Binding var scrollPosition: ScrollPosition

    @State private var scrolledHighlightID: String?

    private var isLandscape: Bool {
        verticalSizeClass == .compact
    }

    var body: some View {
        if isLandscape {
            HStack(spacing: 0) {
                FeedHighlightsVerticalView(
                    highlights: PreviewData.sampleHighlights,
                    scrolledID: $scrolledHighlightID,
                    onTap: { _ in }
                )
                .frame(maxWidth: .infinity)

                Divider()

                ScrollView {
                    LazyVStack(spacing: 16) {
                        ForEach(0..<10, id: \.self) { index in
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color.gray.opacity(0.2))
                                .frame(height: 100)
                                .overlay(Text("Card \(index)"))
                        }
                    }
                    .padding()
                }
                .frame(maxWidth: .infinity)
            }
        } else {
            VStack(spacing: 0) {
                FeedHighlightsCarouselView(
                    highlights: PreviewData.sampleHighlights,
                    scrolledID: $scrolledHighlightID,
                    onTap: { _ in }
                )
                .padding(.bottom, 16)

                Spacer()

                Text("Feed apareceria aqui")
                    .foregroundStyle(.secondary)

                Spacer()
            }
        }
    }
}
#endif
