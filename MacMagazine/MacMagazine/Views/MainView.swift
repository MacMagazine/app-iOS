import CommonLibrary
import News
import SwiftUI
import UIComponentsLibrarySpecial
import Videos

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

                Tab("Videos", systemImage: "play.rectangle.fill", value: .videos) {
                    VideosView()
                        .ignoresSafeArea(edges: .bottom)
                }

                Tab("Ajustes", systemImage: "gearshape", value: .settings) {
                    SettingsView()
                }

                Tab("Search", systemImage: "magnifyingglass", value: .search, role: .search) {
                    SearchView(searchText: $searchText)
                }
            }
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
