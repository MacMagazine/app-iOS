import CommonLibrary
import News
import SwiftUI
import UIComponentsLibrarySpecial

struct MainView: View {
    @Environment(\.theme) private var theme: ThemeColor

    @State var selection = MainViewModel.Page.home
    @State private var searchText: String = ""

    var body: some View {
        ZStack {
            theme.main.background.color
                .edgesIgnoringSafeArea(.all)
            
            TabView(selection: $selection) {
                Tab("Home", systemImage: "house", value: .home) {
                    HomeView()
                }

                Tab("Social", systemImage: "point.3.filled.connected.trianglepath.dotted", value: .videos) {
                    SocialView()
                        .ignoresSafeArea(edges: .bottom)
                }

                Tab("Ajustes", systemImage: "gearshape", value: .settings) {
                    SettingsView()
                }

                Tab("Search", systemImage: "magnifyingglass", value: .search, role: .search) {
                    SearchView(searchText: $searchText)
                }
            }
            .tint(theme.tertiary.background.color)
        }
    }
}

#Preview {
    let viewModel = MainViewModel()
    return MainView()
        .environmentObject(viewModel)
        .environmentObject(NewsViewModel(inMemory: true))
        .environment(\.theme, ThemeColor())
        .task {
            viewModel.isLoading = false
        }
}
