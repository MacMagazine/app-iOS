import AnalyticsLibrary
import MacMagazineLibrary
import MacMagazineUILibrary
import PodcastLibrary
import SettingsLibrary
import SwiftUI

extension MainView {

    @ViewBuilder
    var tabContentView: some View {
        @Bindable var bindableViewModel = viewModel

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
        .podcastMiniPlayer()
    }

    @ViewBuilder
    func contentView(for tab: AppTabs) -> some View {
        switch tab {
        case .news: NewsView()
        case .social: SocialView()
        case .settings: SettingsView()
        case .search: SearchView()

        case .live:
            MMWebView(url: "https://macmagazine.com.br/live", cacheKey: "macmagazine_live")
                .trackScreen(
                    tab.analyticsScreen?.name ?? tab.rawValue,
                    previous: nil,
                    analytics: viewModel.analytics
                )
        default:
            ContentUnavailableView(
                "Página em construção",
                systemImage: "square.and.arrow.down.badge.xmark",
                description: Text("Conteúdo ainda em desenvolvimento e estará disponível em breve.")
            )
        }
    }
}
