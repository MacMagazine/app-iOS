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
            card: GlassCard(buttonColor: .white),
            api: viewModel.youtube,
            scrollPosition: $scrollPosition,
            favorite: favorite,
            search: search
        )
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
