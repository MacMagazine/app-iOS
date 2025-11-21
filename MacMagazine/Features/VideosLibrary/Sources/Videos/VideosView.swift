import MacMagazineLibrary
import StorageLibrary
import SwiftUI
import UIComponentsLibrary
import YouTubeLibrary

public struct VideosView: View {
    @Environment(\.theme) private var theme: ThemeColor
    @ObservedObject var viewModel: VideosViewModel
    @State private var search: String = ""

    public init(storage: Database) {
        self.viewModel = VideosViewModel(storage: storage)
    }

    public var body: some View {
        VStack {
            ErrorView(message: viewModel.status.reason).padding(.top)
            YouTubeLibrary.VideosView(
                api: viewModel.youtube,
                favorite: viewModel.options == .favorite,
                search: search,
                theme: theme
            )
            Spacer()
        }

        .task {
            try? await viewModel.youtube.getVideos()
        }
    }
}

#Preview {
    let storage = Database(models: [VideoDB.self], inMemory: true)
    VideosView(storage: storage)
        .environment(\.theme, ThemeColor())
}
