import Combine
import StorageLibrary
import UIKit

final class IconsViewModel: ObservableObject {
    @Published var icon: IconType = .normal
    var storage: Database?
}

extension IconsViewModel {
    @MainActor
    func get() {
        icon = storage?.settings?.icon ?? .normal
    }

    @MainActor
    func change(_ icon: IconType) async {
        guard UIApplication.shared.supportsAlternateIcons else {
            return
        }

        try? await UIApplication.shared.setAlternateIconName(icon.appIcon)
        storage?.update(appIcon: icon)
        self.icon = icon
    }
}
