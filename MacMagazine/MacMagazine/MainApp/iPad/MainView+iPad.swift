import SettingsLibrary
import SwiftUI

extension MainView {
    var sideBarContentView: some View {
        NavigationSplitView {
            sidebar
                .searchable(text: $searchText, prompt: "Search items")
        } detail: {
            NavigationStack {
                SocialView()
            }
        }
    }

    var sidebar: some View {
        List {
            ForEach(viewModel.settingsViewModel.tabs, id: \.self) { tab in
                switch tab {
                case .news: news(tab: tab)
                case .social: social(tab: tab)
                case .search: EmptyView()
                default:
                    HStack {
                        Image(systemName: tab.icon)
                        Text(tab.rawValue)
                    }
                }
            }
        }
        .navigationTitle("MacMagazine")
        .navigationBarTitleDisplayMode(.large)
    }
}

private extension MainView {
    func social(tab: AppTabs) -> some View {
        Section {
            ForEach(viewModel.settingsViewModel.social, id: \.self) { option in
                HStack {
                    Image(systemName: option.icon)
                    Text(option.rawValue)
                }
            }
        } header: {
            HStack {
                Image(systemName: tab.icon)
                Text(tab.rawValue)
            }
        }
    }
}

private extension MainView {
    func news(tab: AppTabs) -> some View {
        Section {
            ForEach(viewModel.settingsViewModel.news, id: \.self) { option in
                HStack {
                    Image(systemName: option.icon)
                    Text(option.rawValue)
                }
            }
        } header: {
            HStack {
                Image(systemName: tab.icon)
                Text(tab.rawValue)
            }
        }
    }
}
