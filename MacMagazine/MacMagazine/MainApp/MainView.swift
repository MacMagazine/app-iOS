import MacMagazineLibrary
import SettingsLibrary
import SwiftUI
import UIComponentsLibrary

struct MainView: View {
    @Environment(\.theme) private var theme: ThemeColor

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
                    Text("SocialView()")
                        .ignoresSafeArea(edges: .bottom)
                }

                Tab("Ajustes", systemImage: "gearshape", value: .settings) {
                    SettingsView(type: .custom)
                }

                Tab("Ajustes", systemImage: "gearshape.2", value: .settings) {
                    SettingsView(type: .native)
                }

                Tab("Search", systemImage: "magnifyingglass", value: .search, role: .search) {
                    Text("SearchView(searchText: $searchText)")
                }
            }
            .tint(theme.tertiary.background.color)
        }
    }
}

#Preview {
    MainView()
}
