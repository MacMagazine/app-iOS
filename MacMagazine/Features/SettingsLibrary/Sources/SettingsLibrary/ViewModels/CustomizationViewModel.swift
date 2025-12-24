import Combine
import Foundation
import MacMagazineLibrary
import StorageLibrary

@Observable
final class CustomizationViewModel {
    var tabs = AppTabs.allCases
    var social = Social.allCases
    var news = News.allCases

    var storage: Database?
}

extension CustomizationViewModel {
    @MainActor
    func get() {
        tabs = storage?.customization?.tabs ?? AppTabs.allCases
        social = storage?.customization?.social ?? Social.allCases
        news = storage?.customization?.news ?? News.allCases
    }

    @MainActor
    func change(_ tabs: [AppTabs]) async {
        storage?.update(tabs: tabs)
    }

    @MainActor
    func change(_ social: [Social]) async {
        storage?.update(social: social)
    }

    @MainActor
    func change(_ news: [News]) async {
        storage?.update(news: news)
    }
}
