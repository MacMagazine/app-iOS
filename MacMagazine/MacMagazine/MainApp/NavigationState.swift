import Combine
import SettingsLibrary
import SwiftUI

@Observable
class NavigationState {
    var selectedItem: any CaseIterable & Equatable = AppTabs.news
    var navigationPath = NavigationPath()

    func navigate(to item: any CaseIterable & Equatable) {
        selectedItem = item
        navigationPath = NavigationPath()
    }

    func navigate(
        from old: UserInterfaceSizeClass?,
        to new: UserInterfaceSizeClass?,
        viewModel: MainViewModel
    ) {
        switch new {
        case .regular: // tabbar -> sidebar
            switch selectedItem {
            case AppTabs.social: selectedItem = viewModel.social
            case AppTabs.news: selectedItem = viewModel.news
            default: break
            }

        case .compact: // sidebar -> tabbar
            switch selectedItem {
            case is Social:
                selectedItem = AppTabs.social
                viewModel.tab = .social

            case is News:
                selectedItem = AppTabs.news
                viewModel.tab = .news

            default:
                if let tab = selectedItem as? AppTabs {
                    viewModel.tab = tab
                }
            }

        default: break
        }
    }
}
