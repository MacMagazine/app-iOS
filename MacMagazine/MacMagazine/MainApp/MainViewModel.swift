import Combine
import MacMagazineLibrary
import Settings
import StorageLibrary
import SwiftData
import SwiftUI

class MainViewModel: ObservableObject {
    @ObservedObject var settingsViewModel: SettingsViewModel
    @Published var colorSchema: SwiftUI.ColorScheme?

    let storage: Database
    let theme = ThemeColor()
    var cancellables: Set<AnyCancellable> = []

    init() {
        self.storage = Database(models: [SettingsDB.self], inMemory: false)
        self.settingsViewModel = SettingsViewModel(storage: self.storage)

        settingsViewModel.$colorSchema
            .receive(on: RunLoop.main)
            .sink { [weak self] value in
                self?.colorSchema = value
            }
            .store(in: &cancellables)
    }
}
