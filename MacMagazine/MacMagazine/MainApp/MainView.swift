import MacMagazineLibrary
import SettingsLibrary
import SwiftUI
import UIComponentsLibrary

struct MainView: View {
    private var navigationState = NavigationState()
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    @Environment(\.theme) private var theme: ThemeColor
    @EnvironmentObject private var viewModel: MainViewModel

    @State private var searchText: String = ""

    private var shouldUseSidebar: Bool {
        horizontalSizeClass == .regular
    }

    var body: some View {
        ZStack {
            theme.main.background.color
                .edgesIgnoringSafeArea(.all)

            content
                .tint(theme.tertiary.background.color)
        }
            .animation(.easeInOut(duration: 0.3), value: shouldUseSidebar)
            .onChange(of: horizontalSizeClass) { old, new in
                navigationState.navigate(from: old, to: new)
            }
    }
}

// MARK: - Views -

private extension MainView {
    @ViewBuilder
    var content: some View {
        if shouldUseSidebar {
            sideBarContentView
        } else {
            tabContentView
        }
    }

    @ViewBuilder
    var sideBarContentView: some View {
        contentView(for: .social)
    }

    @ViewBuilder
    var tabContentView: some View {
        TabView(selection: $viewModel.tab) {
            ForEach(viewModel.settingsViewModel.tabs, id: \.self) { tab in
                Tab(tab.rawValue, systemImage: tab.icon, value: tab, role: tab == .search ? .search : .none) {
                    AnyView(contentView(for: tab))
                }
            }
        }
    }

    @ViewBuilder
    func contentView(for tab: AppTabs) -> some View {
        switch tab {
        case .live: Text("MMLiveView()")
        case .news: NewsView(storage: viewModel.storage)
        case .social: SocialView(storage: viewModel.storage)
        case .settings: SettingsView()
        case .search: Text("SearchView(searchText: $searchText)")
        }
    }
}

// MARK: - Methods -

private extension MainView {
}

#if DEBUG
// MARK: - Preview -

import StorageLibrary

#Preview {
    let storage = Database(models: [SettingsDB.self], inMemory: true)

    MainView()
    .environment(\.theme, ThemeColor())
    .environmentObject(SettingsViewModel(storage: storage))
}
#endif
