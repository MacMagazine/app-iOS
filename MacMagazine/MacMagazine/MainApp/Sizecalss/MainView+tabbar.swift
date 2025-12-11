import MMLiveLibrary
import SettingsLibrary
import SwiftUI

extension MainView {

    @ViewBuilder
    var tabContentView: some View {
        @Bindable var bindableViewModel = viewModel

        if UIDevice.current.userInterfaceIdiom == .pad {

            TabView(selection: $bindableViewModel.tab) {

                ForEach(viewModel.settingsViewModel.tabs, id: \.self) { tab in
                    Tab(
                        tab.rawValue,
                        systemImage: tab.icon,
                        value: tab,
                        role: tab == .search ? .search : .none
                    ) {
                        NavigationStack {
                            AnyView(contentView(for: tab))
                        }
                    }
                    .defaultVisibility(.visible, for: .tabBar)
                }

                TabSection("Notícias") {
                    ForEach(viewModel.settingsViewModel.news, id: \.self) { newsItem in
                        Tab(
                            newsItem.rawValue,
                            systemImage: newsItem.icon,

                            value: AppTabs.news,
                            role: .none
                        ) {
                            NavigationStack {
                                contentView(for: newsItem)
                            }
                        }
                        .defaultVisibility(.visible, for: .sidebar)
                            // e opcionalmente esconder na TabBar:
                        .defaultVisibility(.hidden, for: .tabBar)
                    }
                }
                .defaultVisibility(.hidden, for: .tabBar)

                TabSection("Social") {
                    ForEach(viewModel.settingsViewModel.social, id: \.self) { socialItem in
                        Tab(
                            socialItem.rawValue,
                            systemImage: socialItem.icon,
                            value: AppTabs.social,
                            role: .none
                        ) {
                            NavigationStack {
                                contentView(for: socialItem)
                            }
                        }
                        .defaultVisibility(.visible, for: .sidebar)
                        .defaultVisibility(.hidden, for: .tabBar)
                    }
                }
                .defaultVisibility(.hidden, for: .tabBar)

            }
            .tabViewStyle(.sidebarAdaptable)

        } else if UIDevice.current.userInterfaceIdiom == .phone {

            TabView(selection: $bindableViewModel.tab) {
                ForEach(viewModel.settingsViewModel.tabs, id: \.self) { tab in
                    Tab(
                        tab.rawValue,
                        systemImage: tab.icon,
                        value: tab,
                        role: tab == .search ? .search : .none
                    ) {
                        NavigationStack {
                            AnyView(contentView(for: tab))
                        }
                    }
                }
            }
        }
    }
}

    // MARK: - Helpers de lista / navegação (mantidos como você tinha)

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
                case Social.videos:    viewModel.social = .videos
                case Social.podcast:   viewModel.social = .podcast
                case Social.instagram: viewModel.social = .instagram

                case News.all:         viewModel.news = .all
                case News.news:        viewModel.news = .news
                case News.highlights:  viewModel.news = .highlights
                case News.appletv:     viewModel.news = .appletv
                case News.reviews:     viewModel.news = .reviews
                case News.rumors:      viewModel.news = .rumors
                case News.tutoriais:   viewModel.news = .tutoriais

                default: break
            }
            navigationState.navigate(to: destination)
        }
    }

    func id(for destination: any CaseIterable & Equatable) -> String {
        switch destination {
            case is Social: (destination as? Social)?.rawValue ?? UUID().uuidString
            case is News:   (destination as? News)?.rawValue ?? UUID().uuidString
            case is AppTabs: (destination as? AppTabs)?.rawValue ?? UUID().uuidString
            default: UUID().uuidString
        }
    }
}
