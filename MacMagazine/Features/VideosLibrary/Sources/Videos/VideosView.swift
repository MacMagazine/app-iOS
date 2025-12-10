import MacMagazineLibrary
import StorageLibrary
import SwiftUI
import UIComponentsLibrary
import YouTubeLibrary

public struct VideosView: View {
    @Environment(SessionState.self) private var sessionState
    var viewModel: VideosViewModel
    @State private var search: String = ""
    @Binding private var favorite: Bool
    @Binding var scrollPosition: ScrollPosition

    public init(
        storage: Database,
        favorite: Binding<Bool>,
        scrollPosition: Binding<ScrollPosition>
    ) {
        self.viewModel = VideosViewModel(storage: storage)
        _favorite = favorite
        _scrollPosition = scrollPosition
    }

    public var body: some View {
        Videos(
            card: AdaptiveVideoCard(context: viewModel.context),
            api: viewModel.youtube,
            scrollPosition: $scrollPosition,
            favorite: favorite,
            search: search
        )
        .onAppear {
            // Update the binding when view appears (before fetch happens)
            viewModel.youtube.update(hasFetchedVideos: Binding(
                get: { sessionState.hasFetchedVideos },
                set: { value in sessionState.hasFetchedVideos = value }
            ))
        }
    }
}

#Preview {
    let storage = Database(models: [VideoDB.self], inMemory: true)
    VideosView(
        storage: storage,
        favorite: .constant(false),
        scrollPosition: .constant(.init())
    )
    .environment(\.theme, ThemeColor())
}
