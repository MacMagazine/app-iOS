import FeedLibrary
import MacMagazineLibrary
import StorageLibrary
import SwiftData
import SwiftUI
import UIComponentsLibrary

public struct PodcastView: View {
    @Environment(\.theme) private var theme: ThemeColor
    var viewModel: PodcastViewModel

    @Binding private var favorite: Bool
    @Binding var scrollPosition: ScrollPosition

    @State private var search: String = ""
    @State private var playerManager = PodcastPlayerManager()
    @State private var showFullPlayer = false

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
        _podcasts = Query(filter: favorite ? predicate : nil,
                          sort: \PodcastDB.pubDate,
                          order: .reverse,
                          animation: .smooth)
    }

    public var body: some View {
        content.overlay {
            miniPlayer
                .animation(.spring(response: 0.4,
                                   dampingFraction: 0.8),
                           value: playerManager.currentPodcast?.id)
                .frame(maxWidth: 420)
        }

        .task {
            if viewModel.status == .idle {
                try? await viewModel.getPodcasts()
            }
        }

        .sheet(isPresented: $showFullPlayer) {
            PodcastPlayerView(playerManager: playerManager,
                              backgroundGradientStyle: .fourTone)
                .presentationDragIndicator(.visible)
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
                    AdaptivePodcastCardView(podcast: podcast.toCardContent(using: viewModel.context)) {
                        playerManager.loadPodcast(podcast)
                    }
                }
            },
            retryAction: favorite ? nil : retryAction
        )
    }

    @ViewBuilder
    var miniPlayer: some View {
        if let currentPodcast = playerManager.currentPodcast {
            VStack {
                Spacer()
                MiniPlayerView(
                    playerManager: playerManager,
                    currentPodcast: currentPodcast
                ) {
                    showFullPlayer = true
                }
            }
            .transition(.move(edge: .bottom))
        }
    }
}
