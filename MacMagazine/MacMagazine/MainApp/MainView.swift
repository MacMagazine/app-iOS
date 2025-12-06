import MacMagazineLibrary
import SettingsLibrary
import SwiftUI
import UIComponentsLibrary

struct MainView: View {
    @State var navigationState = NavigationState()
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    @Environment(\.shouldUseSidebar) private var shouldUseSidebar
    @Environment(\.theme) private var theme: ThemeColor
    @EnvironmentObject var viewModel: MainViewModel

    @State var searchText: String = ""

    var body: some View {
        ZStack {
            theme.main.background.color
                .edgesIgnoringSafeArea(.all)

            content
                .tint(theme.tertiary.background.color)
        }
        .animation(.easeInOut(duration: 0.3), value: shouldUseSidebar)
        .onChange(of: horizontalSizeClass) { old, new in
            navigationState.navigate(from: old, to: new, social: viewModel.social, news: viewModel.news)
        }
    }

    @ViewBuilder
    var content: some View {
        if shouldUseSidebar {
            sideBarContentView
        } else {
            tabContentView
                .onAppear {
                    viewModel.settingsViewModel.updateTabs()
                }
        }
    }
}

#if DEBUG
#Preview {
    MainView()
    .environment(\.theme, ThemeColor())
    .environmentObject(MainViewModel(inMemory: true))
}
#endif
