import Combine
import SettingsLibrary
import SwiftUI

@Observable
class NavigationState {
    var selectedItem: any CaseIterable = AppTabs.news
    var navigationPath = NavigationPath()

    func navigate(to item: any CaseIterable) {
        selectedItem = item
    }

    func navigate(from old: UserInterfaceSizeClass?, to new: UserInterfaceSizeClass?) {
        switch new {
        case .regular: // tabbar -> sidebar
            switch selectedItem {
            case AppTabs.social:
                selectedItem = Social.videos

            default: break
            }

        case .compact: // sidebar -> tabbar
            switch selectedItem {
            case Social.videos, Social.podcast, Social.instagram:
                selectedItem = AppTabs.social

            default: break
            }

        default: break
        }
    }
}
