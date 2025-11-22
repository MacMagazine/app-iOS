import MacMagazineLibrary
import SettingsLibrary
import SwiftUI
import UIComponentsLibrary

struct MainView: View {
    @Environment(\.theme) private var theme: ThemeColor
    @EnvironmentObject private var viewModel: MainViewModel

    @State private var searchText: String = ""

    var body: some View {
        ZStack {
            theme.main.background.color
                .edgesIgnoringSafeArea(.all)

            TabView(selection: $viewModel.tab) {
                ForEach(viewModel.settingsViewModel.tabs, id: \.self) { tab in
                    Tab(tab.rawValue, systemImage: tab.icon, value: tab, role: tab == .search ? .search : .none) {
                        AnyView(contentView(for: tab))
                    }
                }
            }
            .tint(theme.tertiary.background.color)
        }
    }

    @ViewBuilder
    private func contentView(for tab: AppTabs) -> some View {
        switch tab {
        case .live: Text("MMLiveView()")
        case .news: NewsView(storage: viewModel.storage)
        case .social: SocialView(storage: viewModel.storage)
        case .settings: SettingsView()
        case .search: Text("SearchView(searchText: $searchText)")
        }
    }
}

#if DEBUG
import StorageLibrary

#Preview {
    let storage = Database(models: [SettingsDB.self], inMemory: true)

    MainView()
    .environment(\.theme, ThemeColor())
    .environmentObject(SettingsViewModel(storage: storage))
}
#endif
