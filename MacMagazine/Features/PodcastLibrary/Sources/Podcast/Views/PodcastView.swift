import FeedLibrary
import MacMagazineLibrary
import StorageLibrary
import SwiftData
import SwiftUI
import UIComponentsLibrary

public struct PodcastView: View {
    @Environment(\.theme) private var theme: ThemeColor
    @Environment(\.shouldUseSidebar) private var shouldUseSidebar
    @Environment(PodcastPlayerManager.self) private var podcastPlayerManager
    @Environment(\.modelContext) private var modelContext
    @Environment(SessionState.self) private var sessionState
    var viewModel: PodcastViewModel

    @Binding private var favorite: Bool
    @Binding var scrollPosition: ScrollPosition

    @State private var search: String = ""

    @Query private var podcasts: [PodcastDB]

    public init(
        storage: Database,
        favorite: Binding<Bool>,
        scrollPosition: Binding<ScrollPosition>
    ) {
        self.viewModel = PodcastViewModel(storage: storage)
        _favorite = favorite
        _scrollPosition = scrollPosition

        let favorite = favorite.wrappedValue
        let predicate = #Predicate<PodcastDB> {
            $0.favorite == favorite
        }
        _podcasts = Query(
            filter: favorite ? predicate : nil,
            sort: \PodcastDB.pubDate,
            order: .reverse,
            animation: .smooth
        )
    }

    public var body: some View {
        content
            .task {
                if viewModel.status == .idle && !sessionState.hasFetchedPodcasts {
                    try? await viewModel.getPodcasts(status: .loading)
                    sessionState.hasFetchedPodcasts = true
                }
            }
            .refreshable {
                if search.isEmpty {
                    try? await viewModel.getPodcasts()
                }
            }

            .sheet(isPresented: Binding(get: { podcastPlayerManager.isFullscreen },
                                        set: { value in podcastPlayerManager.isFullscreen = value })) {
                FullPlayerView(
                    playerManager: podcastPlayerManager,
                    backgroundGradientStyle: .fourTone
                )
                .presentationDragIndicator(.visible)
                .presentationDetents(shouldUseSidebar ? [.large] : [.medium])
            }
    }
}
extension PodcastView {
    @ViewBuilder
    var content: some View {
        let retryAction: () -> Void = {
            Task {
                try? await viewModel.getPodcasts()
            }
        }

        CollectionView(
            title: "Podcast",
            status: viewModel.status,
            usesDensity: true,
            scrollPosition: $scrollPosition,
            favorite: favorite,
            isSearching: !search.isEmpty,
            quantity: search.isEmpty ? podcasts.count : 0,
            content: {
                ForEach(podcasts) { podcast in
                    AdaptivePodcastCardView(podcast: podcast.toCardContent(using: modelContext)) {
                        podcastPlayerManager.loadPodcast(podcast)
                        podcastPlayerManager.seek(to: podcast.current)
                    }
                }
            },
            retryAction: favorite ? nil : retryAction
        )
    }
}
