import FeedLibrary
import MacMagazineLibrary
import StorageLibrary
import SwiftData
import SwiftUI
import UIComponentsLibrary
import YouTubeLibrary

public struct PodcastView: View {
    @Environment(\.theme) private var theme: ThemeColor
    var viewModel: PodcastViewModel
    @State private var search: String = ""
    @Binding private var favorite: Bool
    @Binding var scrollPosition: ScrollPosition

    @Query(filter: #Predicate<PodcastDB> { !$0.favorite },
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
        content
            .task {
                try? await viewModel.getPodcasts()
            }
    }
}

extension PodcastView {
    var content: some View {
        ScrollView {
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 240), spacing: 16, alignment: .top)],
                      spacing: 16) {
                ForEach(podcasts) { podcast in
                    Text(podcast.title)
                }
            }.padding()
        }
    }
}

#Preview {
    let storage = Database(models: [PodcastDB.self], inMemory: true)
    PodcastView(storage: storage, favorite: .constant(false), scrollPosition: .constant(.init()))
        .environment(\.theme, ThemeColor())
}
