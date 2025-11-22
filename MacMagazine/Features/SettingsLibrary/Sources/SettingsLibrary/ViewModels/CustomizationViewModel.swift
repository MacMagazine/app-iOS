import Combine
import Foundation
import StorageLibrary

@Observable
final class CustomizationViewModel {
    var tabs = AppTabs.allCases
    var storage: Database?
}

extension CustomizationViewModel {
    @MainActor
    func get() {
        tabs = storage?.get()?.tabs ?? AppTabs.allCases
    }

    @MainActor
    func change(_ tabs: [AppTabs]) async {
        storage?.update(tabs: tabs)
    }
}
