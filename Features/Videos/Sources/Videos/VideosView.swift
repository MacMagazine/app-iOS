import CommonLibrary
import CoreData
import CoreLibrary
import SwiftUI
import UIComponentsLibrary
import YouTubeLibrary

public struct VideosView: View {
    @Environment(\.theme) private var theme: ThemeColor
    @EnvironmentObject private var viewModel: VideosViewModel
    @State private var search: String?

    public init() {}

    public var body: some View {
        VStack {
            ErrorView(message: viewModel.status.reason)
                .padding(.top)
            VideosFullscreenView(api: viewModel.youtube,
                                 favorite: viewModel.options == .favorite,
                                 search: search,
                                 theme: theme)
            Spacer()
        }
        .environment(\.managedObjectContext, viewModel.context)

        .task {
            try? await viewModel.youtube.getVideos()
        }
    }
}

#Preview {
    VideosView()
        .environmentObject(VideosViewModel())
        .environment(\.theme, ThemeColor())
}
