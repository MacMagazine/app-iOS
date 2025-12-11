import MacMagazineLibrary
import PodcastLibrary
import SettingsLibrary
import SwiftUI
import UIComponentsLibrary

struct MainView: View {
    @State var navigationState = NavigationState()
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    @Environment(\.shouldUseSidebar) private var shouldUseSidebar
    @Environment(\.theme) private var theme: ThemeColor
    @Environment(MainViewModel.self) var viewModel
    @Environment(PodcastPlayerManager.self) private var podcastManager

    @State var searchText: String = ""

    var body: some View {
        @Bindable var bindableViewModel = viewModel

        content
            .tint(theme.tertiary.background.color)
            .id(shouldUseSidebar ? "sidebar" : "tabbar")
            .transaction { transaction in
                transaction.disablesAnimations = true
            }

            .podcastMiniPlayer {
                if viewModel.tab == .social {
                    return viewModel.social == .podcast
                } else {
                    return true
                }
            }

            .onChange(of: horizontalSizeClass) { old, new in
                navigationState.navigate(
                    from: old,
                    to: new,
                    viewModel: viewModel
                )
            }

            .onAppear {
                viewModel.settingsViewModel.updateTabs(currentTab: $bindableViewModel.tab)
            }

            .onChange(of: viewModel.social) { _, newValue in
                if viewModel.tab == .social,
                   newValue == .videos || newValue == .instagram {
                    if podcastManager.isPlaying {
                        podcastManager.pause()
                    }
                }
            }
    }

    // MARK: - Layout root

    @ViewBuilder
    var content: some View {
        tabContentView
    }
}

#if DEBUG
#Preview {
    MainView()
        .environment(\.theme, ThemeColor())
        .environment(MainViewModel(inMemory: true))
}
#endif
