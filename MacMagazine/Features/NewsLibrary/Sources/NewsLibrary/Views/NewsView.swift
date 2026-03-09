import AnalyticsLibrary
import FeedLibrary
import MacMagazineLibrary
import MacMagazineUILibrary
import StorageLibrary
import SwiftData
import SwiftUI
import UIComponentsLibrary

// MARK: - News View

public struct NewsView<Filter: View>: View {

    // MARK: - Environment

    @Environment(\.theme) private var theme: ThemeColor
    @Environment(\.modelContext) private var modelContext
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    @Environment(\.verticalSizeClass) private var verticalSizeClass

    @Environment(SessionState.self) private var sessionState
    @EnvironmentObject private var analytics: AnalyticsManager

    // MARK: - Properties

    var viewModel: NewsViewModel

    @Binding private var favorite: Bool
    @Binding private var category: NewsCategory
    @Binding var scrollPosition: ScrollPosition
    @State private var search: String = ""
    @State private var readingNews = false

    @Query private var allNews: [FeedDB]

    private let filters: Filter

    // MARK: - Initialization

    public init(
        storage: Database,
        favorite: Binding<Bool>,
        category: Binding<NewsCategory>,
        filters: Filter,
        scrollPosition: Binding<ScrollPosition>
    ) {
        self.viewModel = NewsViewModel(storage: storage)
        self.filters = filters
        _favorite = favorite
        _category = category
        _scrollPosition = scrollPosition

        let isFavorite = favorite.wrappedValue

        // Use @Query predicate for the favorite filter (simple Bool field, SwiftData-safe)
        if isFavorite {
            let predicate = #Predicate<FeedDB> { $0.favorite == true }
            _allNews = Query(
                filter: predicate,
                sort: \FeedDB.pubDate,
                order: .reverse
            )
        } else {
            _allNews = Query(
                sort: \FeedDB.pubDate,
                order: .reverse
            )
        }
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
    private var content: some View {
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
                filters
                if shouldShowHighlights {
                    FeedHighlightsCarouselView(
                        highlights: highlights,
                        scrollPosition: $scrollPosition,
                        onTap: { post in
                            handleTap(post)
                        }
                    ).padding(.bottom, 8)
                }
            },
            content: {
                newsCards
            },
            retryAction: favorite ? nil : retryAction
        )
    }

    // MARK: - News Cards

    @ViewBuilder
    private var newsCards: some View {
        PaginatedForEach(news) { index, item in
            let data = item.toCardContent(using: modelContext,
                                          analytics: analytics,
                                          screen: nil,
                                          style: category.style,
                                          aspectRatio: aspectRatio)

            NewsCard(data: data) {
                handleTap(item)
            }
            .cardAccessibility(
                data: data,
                labels: [.title, .date, .author],
                buttons: [.favorite, .share]
            )
            .contextMenu {
                MenuContent(data: data)
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
                ToolbarItem(placement: .automatic) {
                    favoriteView
                }
                ToolbarSpacer(.fixed)
                ToolbarItem(placement: .automatic) {
                    shareView
                }
            }
            .onAppear {
                viewModel.selectedNews?.read = true
                viewModel.selectedNews?.modifiedAt = Date()
                try? modelContext.save()
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
    /// Number of highlights to show (30 for iPad, 10 for iPhone)
    private var highlightsLimit: Int {
        5
    }

    /// Filtered highlights from allNews
    private var highlights: [FeedDB] {
        let highlights = allNews.filter { $0.categories.contains(NewsCategory.highlights.filterKey) }
        return Array(highlights.prefix(highlightsLimit))
    }

    /// Filtered news based on category
    private var news: [FeedDB] {
        if category != .all {
            return allNews.filter { $0.categories.contains(category.filterKey) }
        } else if shouldShowHighlights {
            let highlightIDs = Set(highlights.map(\.postId))
            return allNews.filter { !highlightIDs.contains($0.postId) }
        }
        return allNews
    }

    /// Show highlights only when not filtering and category is "all"
    private var shouldShowHighlights: Bool {
        !favorite && category == .all && !highlights.isEmpty
    }

    /// Aspect ratio of the image based on the category selected
    private var aspectRatio: CGFloat? {
        switch category {
        case .highlights: 16 / 9
        default: 2
        }
    }
}
