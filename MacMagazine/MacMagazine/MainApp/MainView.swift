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
        .onChange(of: horizontalSizeClass) { old, new in
            navigationState.navigate(
                from: old,
                to: new,
                viewModel: viewModel
            )
        }
        .onAppear {
            viewModel.settingsViewModel.updateTabs(currentTab: $viewModel.tab)
        }
    }

    @ViewBuilder
    var content: some View {
        Group {
            if shouldUseSidebar {
                sideBarContentView
            } else {
                tabContentView
            }
        }
        .id(shouldUseSidebar ? "sidebar" : "tabbar")
        .transaction { transaction in
            transaction.disablesAnimations = true
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
