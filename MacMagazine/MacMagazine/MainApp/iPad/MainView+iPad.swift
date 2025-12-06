import SettingsLibrary
import SwiftUI

extension MainView {
    var sideBarContentView: some View {
        NavigationSplitView {
            sidebar
                .searchable(text: $searchText, prompt: "Search items")
        } detail: {
            NavigationStack {
                contentView(for: navigationState.selectedItem)
            }
        }
        .navigationSplitViewStyle(.balanced)
    }

    var sidebar: some View {
        List {
            ForEach(viewModel.settingsViewModel.tabs, id: \.self) { tab in
                switch tab {
                case .news: news(tab: tab)
                case .social: social(tab: tab)
                case .search: EmptyView()
                default:
                    show(destination: tab, title: tab.rawValue, icon: tab.icon)
                }
            }
        }
        .listStyle(.sidebar)
        .navigationTitle("MacMagazine")
        .navigationBarTitleDisplayMode(.large)
    }
}

private extension MainView {
    func social(tab: AppTabs) -> some View {
        Section {
            ForEach(viewModel.settingsViewModel.social, id: \.self) { option in
                show(destination: option, title: option.rawValue, icon: option.icon)
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
                show(destination: option, title: option.rawValue, icon: option.icon)
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
    func show(destination: any CaseIterable & Equatable, title: String, icon: String) -> some View {
        Button {
            process(destination)
        } label: {
            HStack {
                Image(systemName: icon)
                Text(title)
            }
        }
        .listRowBackground(
            RoundedRectangle(cornerRadius: 18)
                .fill(
                    areEqual(navigationState.selectedItem, destination) ? Color.accentColor.opacity(0.2) : Color.clear
                )
        )
    }
}

private extension MainView {
    @ViewBuilder
    func contentView(for item: any CaseIterable & Equatable) -> some View {
        switch item {
        case AppTabs.live: Text("MMLiveView()")
        case AppTabs.news: NewsView()
        case AppTabs.social: SocialView()
        case AppTabs.settings: SettingsView()
        case Social.videos: SocialView()
        case Social.podcast: SocialView()
        case Social.instagram: SocialView()
        case News.all: NewsView()
        case News.news: NewsView()
        case News.highlights: NewsView()
        case News.appletv: NewsView()
        case News.reviews: NewsView()
        case News.rumors: NewsView()
        case News.tutoriais: NewsView()
        default:
            ContentUnavailableView(
                "Página em construção",
                systemImage: "square.and.arrow.down.badge.xmark",
                description: Text("Conteúdo ainda em desenvolvimento e estará disponível em breve.")
            )
        }
    }
}

private extension MainView {
    func process(_ destination: any CaseIterable & Equatable) {
        switch destination {
        case Social.videos: viewModel.social = .videos
        case Social.podcast: viewModel.social = .podcast
        case Social.instagram: viewModel.social = .instagram
        case News.all: viewModel.news = .all
        case News.news: viewModel.news = .news
        case News.highlights: viewModel.news = .highlights
        case News.appletv: viewModel.news = .appletv
        case News.reviews: viewModel.news = .reviews
        case News.rumors: viewModel.news = .rumors
        case News.tutoriais: viewModel.news = .tutoriais
        default: break
        }
        navigationState.navigate(to: destination)
    }
}
