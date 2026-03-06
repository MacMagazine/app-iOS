import FeedLibrary
import MacMagazineLibrary
import MacMagazineUILibrary
import PodcastLibrary
import StorageLibrary
import SwiftUI
import YouTubeLibrary

public struct SearchView: View {
    @Environment(\.theme) private var theme: ThemeColor
    @Environment(PodcastPlayerManager.self) private var podcastPlayerManager
    @Environment(SearchViewModel.self) private var viewModel

    @State private var selectedLink: String?
    @State private var showingWebView = false

    public init() {}

    public var body: some View {
        @Bindable var bindableViewModel = viewModel

        ZStack(alignment: .top) {
            (theme.main.background.color ?? Color.secondary).ignoresSafeArea()
            content
        }
        .navigationTitle("Busca")
        .searchable(
            text: $bindableViewModel.searchText,
            prompt: "Buscar notícias, podcasts e vídeos"
        )
        .onChange(of: viewModel.searchText) {
            viewModel.performSearch()
        }
        .navigationDestination(isPresented: $showingWebView) {
            if let link = selectedLink {
                MMWebView(url: link)
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

    var idleContent: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                RecentSearchesView(
                    searches: viewModel.recentSearches,
                    onSelect: { viewModel.selectRecentSearch($0) },
                    onClear: { viewModel.clearRecentSearches() },
                    onRemove: { viewModel.removeRecentSearch($0) }
                )
            }
            .padding(.top)
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
            ContentUnavailableView.search(text: viewModel.searchText)
        } else {
            resultsList
        }
    }

    var resultsList: some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                if viewModel.status == .localResults {
                    ProgressView()
                        .padding(.top, 8)
                }

                SearchResultsList(
                    results: viewModel.results,
                    onSelectNews: { handleNewsSelection($0) },
                    onSelectPodcast: { handlePodcastSelection($0) },
                    onSelectVideo: { handleVideoSelection($0) },
                    onSelectLink: { handleLinkSelection($0) }
                )
            }
            .padding(.vertical)
        }
    }

    func errorContent(reason: String) -> some View {
        ContentUnavailableView(
            "Erro na busca",
            systemImage: "exclamationmark.triangle",
            description: Text(reason)
        )
    }
}

// MARK: - Navigation

private extension SearchView {

    func handleNewsSelection(_ feed: FeedDB) {
        selectedLink = feed.link
        showingWebView = true
    }

    func handlePodcastSelection(_ podcast: PodcastDB) {
        podcastPlayerManager.loadPodcast(podcast)
        podcastPlayerManager.seek(to: podcast.current)
    }

    func handleVideoSelection(_ video: VideoDB) {
        let url = "https://www.youtube.com/watch?v=\(video.videoId)"
        selectedLink = url
        showingWebView = true
    }

    func handleLinkSelection(_ link: String) {
        selectedLink = link
        showingWebView = true
    }
}
