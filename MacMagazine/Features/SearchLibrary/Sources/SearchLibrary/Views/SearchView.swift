import AnalyticsLibrary
import FeedLibrary
import MacMagazineLibrary
import MacMagazineUILibrary
import PodcastLibrary
import StorageLibrary
import SwiftUI
import UIComponentsLibrary
import YouTubeLibrary

public struct SearchView: View {
    @Environment(\.theme) private var theme: ThemeColor
    @Environment(PodcastPlayerManager.self) private var podcastPlayerManager
    @Environment(SearchViewModel.self) private var viewModel
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    @Environment(\.verticalSizeClass) private var verticalSizeClass
    @EnvironmentObject private var analytics: AnalyticsManager

    @State private var cardWidth = CGFloat.zero
    @State private var selectedTitle: String?
    @State private var selectedLink: String?
    @State private var showingWebView = false
    @State private var action: YouTubePlayerAction = .idle
    @State private var selectedVideo: VideoDB?

    private let api: YouTubeAPI

    public init(
        api: YouTubeAPI
    ) {
        self.api = api
    }

    public var body: some View {
        @Bindable var viewModel = viewModel

        NavigationStack {
            content
                .background {
                    (theme.main.background.color ?? Color.secondary).ignoresSafeArea()
                }
                .navigationTitle("Busca")
                .trackScreen(
                    AnalyticsConstants.Screen.search.name,
                    previous: nil,
                    analytics: analytics
                )
                .onChange(of: viewModel.searchText) {
                    viewModel.performSearch()
                }
                .onChange(of: viewModel.status) { _, newStatus in
                    trackSearchCompletion(newStatus)
                }
                .navigationDestination(isPresented: $showingWebView) {
                    details
                }
                .onChange(of: selectedVideo) { _, value in
                    api.selectedVideo = value
                }
                .player(api: api, action: $action)
                .if(!isIPad) { view in
                    view.searchable(
                        text: $viewModel.searchText,
                        prompt: "Buscar notícias, podcasts e vídeos"
                    )
                }
        }
    }
}

// MARK: - Content

private extension SearchView {

    @ViewBuilder
    var content: some View {
        switch viewModel.status {
        case .idle:
            idleContent
        case .searching:
            searchingContent
        case .localResults, .done:
            resultsContent
        case let .error(reason):
            errorContent(reason: reason)
        }
    }

    @ViewBuilder
    var idleContent: some View {
        if viewModel.recentSearches.isEmpty {
            ContentUnavailableView(
                "Busca",
                systemImage: "magnifyingglass",
                description: Text("Buscar notícias, podcasts e vídeos")
            )
        } else {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    RecentSearchesView(
                        searches: viewModel.recentSearches,
                        onSelect: {
                            analytics.track(.buttonTap(
                                buttonId: AnalyticsConstants.ButtonID.recentSearchTapped.id,
                                screen: AnalyticsConstants.Screen.search.name
                            ))
                            viewModel.selectRecentSearch($0)
                        },
                        onClear: {
                            analytics.track(.buttonTap(
                                buttonId: AnalyticsConstants.ButtonID.recentSearchCleared.id,
                                screen: AnalyticsConstants.Screen.search.name
                            ))
                            viewModel.clearRecentSearches()
                        },
                        onRemove: {
                            analytics.track(.buttonTap(
                                buttonId: AnalyticsConstants.ButtonID.recentSearchRemoved.id,
                                screen: AnalyticsConstants.Screen.search.name
                            ))
                            viewModel.removeRecentSearch($0)
                        }
                    )
                }
                .padding(.top)
            }
        }
    }

    var searchingContent: some View {
        VStack {
            if viewModel.results.isEmpty {
                ProgressView("Buscando...")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                resultsList
            }
        }
    }

    @ViewBuilder
    var resultsContent: some View {
        if viewModel.results.isEmpty {
            ContentUnavailableView(
                "Sem resultados para \"\(viewModel.searchText)\".",
                systemImage: "magnifyingglass",
                description: Text("Tente uma nova busca, por favor.")
            )
        } else {
            resultsList
        }
    }

    var resultsList: some View {
        ScrollView {
            VStack(spacing: 20) {
                if viewModel.status == .localResults {
                    ProgressView()
                        .padding(.top, 8)
                }

                LazyVGrid(
                    columns: Array(repeating: grid, count: density.columns),
                    spacing: 20
                ) {
                    SearchResultsList(
                        results: viewModel.results,
                        onSelectNews: { handleNewsSelection($0) },
                        onSelectPodcast: { handlePodcastSelection($0) },
                        selectedVideo: $selectedVideo,
                        onSelectLink: { handleLinkSelection($0) }
                    )
                }
                .padding(.horizontal)
            }
        }
        .contentWidth { value in
            cardWidth = value
        }
    }

    func errorContent(reason: String) -> some View {
        ContentUnavailableView(
            "Nenhum conteúdo encontrado",
            systemImage: "exclamationmark.triangle",
            description: Text(reason)
        )
    }
}

// MARK: - Properties

private extension SearchView {
    var grid: GridItem {
        GridItem(.adaptive(minimum: 280), spacing: 20, alignment: .top)
    }

    var density: CardDensity {
        .density(using: cardWidth)
    }
}

// MARK: - Navigation

private extension SearchView {
    func handleNewsSelection(_ feed: FeedDB) {
        analytics.track(.itemSelected(
            itemId: feed.postId,
            itemType: "news",
            position: viewModel.results.firstIndex(where: { $0.id == feed.postId }) ?? 0
        ))
        selectedTitle = feed.title
        selectedLink = feed.link
        showingWebView = true
    }

    func handlePodcastSelection(_ podcast: PodcastDB) {
        analytics.track(.itemSelected(
            itemId: podcast.postId,
            itemType: "podcast",
            position: viewModel.results.firstIndex(where: { $0.id == podcast.postId }) ?? 0
        ))
        podcastPlayerManager.loadPodcast(podcast)
        podcastPlayerManager.seek(to: podcast.current)
    }

    func handleLinkSelection(_ link: String) {
        analytics.track(.buttonTap(
            buttonId: AnalyticsConstants.ButtonID.searchResultSelected(type: "link", id: link).id,
            screen: AnalyticsConstants.Screen.search.name
        ))
        selectedLink = link
        showingWebView = true
    }
}

// MARK: - Analytics

private extension SearchView {
    func trackSearchCompletion(_ status: SearchStatus) {
        switch status {
        case .localResults, .done:
            analytics.track(.searchPerformed(
                query: viewModel.searchText,
                resultsCount: viewModel.results.count
            ))
        case .idle, .searching, .error:
            break
        }
    }
}

// MARK: - Layout

private extension SearchView {
    var isIPad: Bool {
        horizontalSizeClass == .regular && verticalSizeClass == .regular
    }
}

// MARK: - Details

private extension SearchView {
    @ViewBuilder
    var details: some View {
        if let selectedLink {
            MMWebView(url: selectedLink)
                .toolbar {
                    ToolbarItem(placement: .automatic) {
                        shareView
                    }
                }
        }
    }

    @ViewBuilder
    var shareView: some View {
        if let selectedTitle,
           let selectedLink {
            ShareButton(
                title: selectedTitle,
                url: selectedLink
            )
        }
    }
}
