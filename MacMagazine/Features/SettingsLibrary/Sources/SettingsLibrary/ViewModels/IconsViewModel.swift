import StorageLibrary
import UIKit

@Observable
final class IconsViewModel {
    var icon: IconType = .normal
    var error = false
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

        do {
            error = false
            try await UIApplication.shared.setAlternateIconName(icon.appIcon)
            storage?.update(appIcon: icon)
            self.icon = icon
        } catch {
            self.error = true
        }
    }
}
