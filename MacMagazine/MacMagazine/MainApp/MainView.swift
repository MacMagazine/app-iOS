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
                let isInSocialContext: Bool
                if shouldUseSidebar {
                    isInSocialContext = navigationState.selectedItem is Social
                } else {
                    isInSocialContext = (viewModel.tab == .social)
                }

                if isInSocialContext,
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
        if shouldUseSidebar {
            sideBarContentView
        } else {
            tabContentView
                .podcastMiniPlayer {
                    if viewModel.tab == .social {
                        return viewModel.social == .podcast
                    } else {
                        return true
                    }
                }
        }
    }
}

#if DEBUG
#Preview {
    let viewModel = MainViewModel(inMemory: true)
    let podcastManager = PodcastPlayerManager()

    MainView()
        .environment(\.theme, ThemeColor())
        .environment(viewModel)
        .environment(podcastManager)
}
#endif
