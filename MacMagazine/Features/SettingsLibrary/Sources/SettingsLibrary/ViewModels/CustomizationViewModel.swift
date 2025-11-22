import Combine
import Foundation
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
        tabs = storage?.get()?.tabs ?? AppTabs.allCases
        social = storage?.get()?.social ?? Social.allCases
        news = storage?.get()?.news ?? News.allCases
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
