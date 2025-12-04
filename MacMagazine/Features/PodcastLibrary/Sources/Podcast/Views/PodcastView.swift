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

    @Query(
        filter: #Predicate<PodcastDB> { !$0.favorite },
        sort: \PodcastDB.pubDate, order: .reverse
    ) private var podcasts: [PodcastDB]

    public init(
        storage: Database,
        favorite: Binding<Bool>,
        scrollPosition: Binding<ScrollPosition>
    ) {
        self.viewModel = PodcastViewModel(storage: storage)
        _favorite = favorite
        _scrollPosition = scrollPosition
    }

    public var body: some View {
        content.overlay {
            miniPlayer
                .animation(.spring(response: 0.4, dampingFraction: 0.8), value: playerManager.currentPodcast?.id)
        }

        .task {
            try? await viewModel.getPodcasts()
        }

        .sheet(isPresented: $showFullPlayer) {
            PodcastPlayerView(playerManager: playerManager)
                .presentationDragIndicator(.visible)
        }
    }
}

extension PodcastView {
    var content: some View {
        ScrollView {
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 240), spacing: 16, alignment: .top)],
                      spacing: 16) {
                ForEach(podcasts) { podcast in
                    PodcastCardView(podcast: podcast) {
                        playerManager.loadPodcast(podcast)
                    }
                }
            }.padding()
        }
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

#Preview {
    let storage = Database(models: [PodcastDB.self], inMemory: true)
    PodcastView(storage: storage, favorite: .constant(false), scrollPosition: .constant(.init()))
        .environment(\.theme, ThemeColor())
}
