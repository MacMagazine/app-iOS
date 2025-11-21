import MacMagazineLibrary
import SettingsLibrary
import SwiftUI
import UIComponentsLibrary

struct MainView: View {
    @Environment(\.theme) private var theme: ThemeColor
    @EnvironmentObject private var viewModel: MainViewModel

    @State var selection = Tabs.home
    @State private var searchText: String = ""

    var body: some View {
        ZStack {
            theme.main.background.color
                .edgesIgnoringSafeArea(.all)

            TabView(selection: $selection) {
                Tab("Home", systemImage: "house", value: .home) {
                    Text("HomeView()")
                }

                Tab("Social", systemImage: "point.3.filled.connected.trianglepath.dotted", value: .social) {
                    SocialView(storage: viewModel.storage)
                }

                Tab("Ajustes", systemImage: "gearshape", value: .settings) {
                    SettingsView()
                }

                Tab("Search", systemImage: "magnifyingglass", value: .search, role: .search) {
                    Text("SearchView(searchText: $searchText)")
                }
            }
            .tint(theme.tertiary.background.color)
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
