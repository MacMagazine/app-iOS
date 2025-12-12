import MacMagazineLibrary
import SettingsLibrary
import SwiftUI
import UIComponentsLibrary

struct MainView: View {
    @State var navigationState = NavigationState()
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    @Environment(\.shouldUseSidebar) private var shouldUseSidebar
    @Environment(\.theme) private var theme: ThemeColor
    @Environment(MainViewModel.self) var viewModel

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

                // Initialize navigation state for sidebar mode
                if shouldUseSidebar {
                    switch viewModel.tab {
                    case .social:
                        navigationState.selectedItem = viewModel.social
                    case .news:
                        navigationState.selectedItem = viewModel.news
                    default:
                        navigationState.selectedItem = viewModel.tab
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
        }
    }
}

#if DEBUG
#Preview {
    let viewModel = MainViewModel(inMemory: true)

    MainView()
        .environment(\.theme, ThemeColor())
        .environment(viewModel)
}
#endif
