import Combine
import SettingsLibrary
import SwiftUI

@Observable
class NavigationState {
    var selectedItem: any CaseIterable & Equatable = AppTabs.news

    func navigate(to item: any CaseIterable & Equatable) {
        selectedItem = item
    }

    func navigate(
        from old: UserInterfaceSizeClass?,
        to new: UserInterfaceSizeClass?,
        social: Social,
        news: News
    ) {
        switch new {
        case .regular: // tabbar -> sidebar
            switch selectedItem {
            case AppTabs.social:
                selectedItem = social
            case AppTabs.news:
                selectedItem = news
            default: break
            }

        case .compact: // sidebar -> tabbar
            switch selectedItem {
            case is Social:
                selectedItem = AppTabs.social
            case is News:
                selectedItem = AppTabs.news
            default: break
            }

        default: break
        }
    }
}
