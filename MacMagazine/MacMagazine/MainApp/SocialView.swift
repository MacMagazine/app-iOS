import MacMagazineLibrary
import StorageLibrary
import SwiftUI
import UIComponentsLibrary
import VideosLibrary

struct SocialView: View {
    enum Options: String, CaseIterable {
        case videos = "Videos"
        case podcast = "Podcast"
        case instagram = "Instagram"
    }

    @Environment(\.theme) private var theme: ThemeColor
    @State private var selected: Options = .videos
    let storage: Database

    var body: some View {
        ZStack {
            (theme.main.background.color ?? Color(uiColor: .systemGray6))
                .edgesIgnoringSafeArea(.all)

            VStack {
                menuView
                selectionView
                Spacer()
            }
        }
        .ignoresSafeArea(edges: .bottom)
    }
}

extension SocialView {
    @ViewBuilder
    private var menuView: some View {
        MenuView(menu: Options.allCases,
                 selected: $selected)
        .padding(.horizontal)
    }
}

extension SocialView {
    @ViewBuilder
    private var selectionView: some View {
        switch selected {
        case .videos: VideosView(storage: storage)
        case .podcast: Text("Podcast")
        case .instagram: Text("Instagram")
        }
    }
}

#Preview {
    let storage = Database(models: [], inMemory: true)
    SocialView(storage: storage)
        .environment(\.theme, ThemeColor())
}
