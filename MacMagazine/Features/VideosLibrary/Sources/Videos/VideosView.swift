import MacMagazineLibrary
import StorageLibrary
import SwiftUI
import UIComponentsLibrary
import YouTubeLibrary

public struct VideosView: View {
    @Environment(\.theme) private var theme: ThemeColor
    var viewModel: VideosViewModel
    @State private var search: String = ""
    @Binding private var favorite: Bool

    public init(
        storage: Database,
        favorite: Binding<Bool>
    ) {
        self.viewModel = VideosViewModel(storage: storage)
        _favorite = favorite
    }

    public var body: some View {
        YouTubeLibrary.VideosView(
            api: viewModel.youtube,
            favorite: favorite,
            search: search,
            theme: theme,
            type: .classic
        )

        .task {
            try? await viewModel.youtube.getVideos()
        }
    }
}

#Preview {
    let storage = Database(models: [VideoDB.self], inMemory: true)
    VideosView(storage: storage, favorite: .constant(false))
        .environment(\.theme, ThemeColor())
}
