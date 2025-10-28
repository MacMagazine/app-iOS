import Combine
import Foundation
import StorageLibrary

final public class AppearanceViewModel: ObservableObject {
    @Published public var mode: ColorScheme = .system
    var storage: Database?

    public init() {}
}

extension AppearanceViewModel {
    @MainActor
    func get() {
        mode = storage?.get()?.mode ?? .system
    }

    @MainActor
    func change(_ mode: ColorScheme) async {
        storage?.update(mode: mode)
    }
}
