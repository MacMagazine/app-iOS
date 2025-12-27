import MacMagazineLibrary
import SettingsLibrary
import SwiftUI
import UIComponentsLibrary

struct MainView: View {
    private enum LayoutType: String {
        case sidebar
        case tabbar
    }

    @State var navigationState = NavigationState()
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    @Environment(\.shouldUseSidebar) private var shouldUseSidebar
    @Environment(\.iPad) private var iPad
    @Environment(\.theme) private var theme: ThemeColor
    @Environment(MainViewModel.self) var viewModel

    @State var searchText: String = ""
    @State var splitViewVisibility: NavigationSplitViewVisibility = .all

    @State private var currentlayout: LayoutType = .tabbar

    var body: some View {
        @Bindable var bindableViewModel = viewModel

        content
            .tint(theme.tertiary.background.color)
            .id(currentlayout.rawValue)

            .onChange(of: horizontalSizeClass) { old, new in
                if iPad && viewModel.sessionState.notPlaying {
                    currentlayout = shouldUseSidebar ? .sidebar : .tabbar
                    navigationState.navigate(
                        from: old,
                        to: new,
                        viewModel: viewModel
                    )
                }
            }

            .onAppear {
                print("==> \(clearOnboarding)")
                currentlayout = shouldUseSidebar ? .sidebar : .tabbar
                viewModel.settingsViewModel.updateTabs(currentTab: $bindableViewModel.tab)

                // Initialize navigation state for sidebar mode
                if currentlayout == .sidebar {
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
        if currentlayout == .sidebar {
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
