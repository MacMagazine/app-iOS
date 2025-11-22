import Combine
import MacMagazineLibrary
import SettingsLibrary
import StorageLibrary
import SwiftData
import SwiftUI
import YouTubeLibrary

class MainViewModel: ObservableObject {
    @ObservedObject var settingsViewModel: SettingsViewModel
    @Published var colorSchema: SwiftUI.ColorScheme?

    let storage: Database
    let theme = ThemeColor()
    var cancellables: Set<AnyCancellable> = []

    init() {
        self.storage = Database(
            models: [
                VideoDB.self,
                SettingsDB.self
            ],
            inMemory: false
        )

        self.settingsViewModel = SettingsViewModel(storage: self.storage)

        settingsViewModel.$colorSchema
            .receive(on: DispatchQueue.main)
            .sink { [weak self] value in
                self?.colorSchema = value
            }
            .store(in: &cancellables)
    }
}
