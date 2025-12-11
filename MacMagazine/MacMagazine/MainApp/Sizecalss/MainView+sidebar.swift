import MMLiveLibrary
import PodcastLibrary
import SettingsLibrary
import SwiftUI

extension MainView {
    var sideBarContentView: some View {
        NavigationSplitView {
            sidebar
                .searchable(text: $searchText, prompt: "Search items")
        } detail: {
            animateContentStackView(for: navigationState.selectedItem)
                .podcastMiniPlayer {
                    if let social = navigationState.selectedItem as? Social {
                        return social == .podcast
                    } else {
                        return true
                    }
                }
        }
        .navigationSplitViewStyle(.balanced)
    }

    var sidebar: some View {
        List(selection: Binding(
            get: { id(for: navigationState.selectedItem) },
            set: { _ in }
        )) {
            ForEach(viewModel.settingsViewModel.tabs, id: \.self) { tab in
                switch tab {
                case .news: news(tab: tab).id(id(for: tab))
                case .social: social(tab: tab).id(id(for: tab))
                default: EmptyView()
                }
            }
        }
        .navigationTitle("MacMagazine")
        .navigationBarTitleDisplayMode(.large)
        .toolbar {
            ToolbarItem(placement: .bottomBar) {
                HStack {
                    if viewModel.settingsViewModel.isLive {
                        Button(action: { process(AppTabs.live) },
                               label: {
                            HStack {
                                Image(systemName: AppTabs.live.icon)
                                Text(AppTabs.live.rawValue)
                            }
                        })
                    }

                    Button(action: { process(AppTabs.settings) },
                           label: {
                        HStack {
                            Image(systemName: AppTabs.settings.icon)
                            Text(AppTabs.settings.rawValue)
                        }
                    })

                    Spacer()
                }
            }
        }
    }
}

private extension MainView {
    func social(tab: AppTabs) -> some View {
        Section {
            ForEach(viewModel.settingsViewModel.social, id: \.self) { option in
                show(destination: option, title: option.rawValue, icon: option.icon)
                    .padding(.leading)
            }
        } header: {
            Text(tab.rawValue)
        }
    }
}

private extension MainView {
    func news(tab: AppTabs) -> some View {
        Section {
            ForEach(viewModel.settingsViewModel.news, id: \.self) { option in
                show(destination: option, title: option.rawValue, icon: option.icon)
                    .padding(.leading)
            }
        } header: {
            Text(tab.rawValue)
        }
    }
}

private extension MainView {
    func show(
        destination: any CaseIterable & Equatable,
        title: String,
        icon: String
    ) -> some View {
        Button(title, systemImage: icon) {
            process(destination)
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
    func animateContentStackView(for item: any CaseIterable & Equatable) -> some View {
        NavigationStack(path: Binding(
            get: { navigationState.navigationPath },
            set: { navigationState.navigationPath = $0 }
        )) {
            contentView(for: navigationState.selectedItem)
        }
    }

    @ViewBuilder
    func contentView(for item: any CaseIterable & Equatable) -> some View {
        switch item {
        case AppTabs.news: NewsView()
        case AppTabs.social: SocialView()
        case AppTabs.settings: SettingsView()
        case AppTabs.live: MMLiveWebView(colorSchema: viewModel.settingsViewModel.colorSchema)
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
        withAnimation(.easeInOut(duration: 0.4)) {
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

    func id(for destination: any CaseIterable & Equatable) -> String {
        switch destination {
        case is Social: (destination as? Social)?.rawValue ?? UUID().uuidString
        case is News: (destination as? News)?.rawValue ?? UUID().uuidString
        case is AppTabs: (destination as? AppTabs)?.rawValue ?? UUID().uuidString
        default: UUID().uuidString
        }
    }
}
