import MMLiveLibrary
import SettingsLibrary
import SwiftUI

extension MainView {
    @ViewBuilder
    var tabContentView: some View {
        @Bindable var bindableViewModel = viewModel

        TabView(selection: $bindableViewModel.tab) {
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
        case .news: NewsView()
        case .social: SocialView()
        case .settings: SettingsView()
        case .live: MMLiveWebView()
        default:
            ContentUnavailableView(
                "Página em construção",
                systemImage: "square.and.arrow.down.badge.xmark",
                description: Text("Conteúdo ainda em desenvolvimento e estará disponível em breve.")
            )
        }
    }
}
