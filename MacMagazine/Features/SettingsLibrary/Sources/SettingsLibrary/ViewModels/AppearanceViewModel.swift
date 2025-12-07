import Combine
import Foundation
import StorageLibrary

final class AppearanceViewModel: ObservableObject {
    @Published var mode: ColorScheme = .system
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
