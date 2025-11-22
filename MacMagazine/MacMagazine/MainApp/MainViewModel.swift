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
    @Published var tab: AppTabs {
        didSet {
            if oldValue == previousTab {
                scrollToTopTrigger = tab
            }
            previousTab = tab
        }
    }
    private var previousTab: AppTabs?

    @Published var social: Social
    @Published var news: News
    @Published var scrollToTopTrigger: AppTabs?

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

        let settingsViewModel = SettingsViewModel(storage: self.storage)
        self.settingsViewModel = settingsViewModel
        self.tab = settingsViewModel.tabs.first ?? .news
        self.scrollToTopTrigger = settingsViewModel.tabs.first
        self.social = settingsViewModel.social.first ?? .videos
        self.news = settingsViewModel.news.first ?? .all

        settingsViewModel.$colorSchema
            .receive(on: DispatchQueue.main)
            .sink { [weak self] value in
                self?.colorSchema = value
            }
            .store(in: &cancellables)
    }
}
