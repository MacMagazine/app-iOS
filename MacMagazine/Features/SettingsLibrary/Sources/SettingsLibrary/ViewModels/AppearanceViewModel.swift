import Foundation
import StorageLibrary

@Observable
final class AppearanceViewModel {
    var mode: ColorScheme = .system
    var storage: Database?
}

extension AppearanceViewModel {
    @MainActor
    func get() {
        mode = storage?.settings?.mode ?? .system
    }

    @MainActor
    func change(_ mode: ColorScheme) async {
        storage?.update(mode: mode)
    }
}
