import Combine
import StorageLibrary
import SwiftData
import SwiftUI

@MainActor
final public class SettingsViewModel: ObservableObject {
    @Published public var colorSchema: SwiftUI.ColorScheme?
    let storage: Database

    public init(storage: Database) {
        self.storage = storage

        NotificationCenter.default.addObserver(
            forName: ModelContext.didSave,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            Task { @MainActor in
                self?.updateSchema()
            }
        }
    }
}

extension SettingsViewModel {
    private func updateSchema() {
        guard let mode = storage.get()?.mode else {
            colorSchema = nil
            return
        }
        colorSchema = switch mode {
        case .light: SwiftUI.ColorScheme.light
        case .dark: SwiftUI.ColorScheme.dark
        case .system: nil
        }
    }
}
