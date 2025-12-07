import FeedLibrary
import MacMagazineLibrary
import SettingsLibrary
import StorageLibrary
import SwiftData
import SwiftUI
import YouTubeLibrary

@Observable
class MainViewModel {
    var settingsViewModel: SettingsViewModel
    var colorSchema: SwiftUI.ColorScheme?
    var tab: AppTabs {
        didSet {
            if oldValue == previousTab {
                scrollToTopTrigger = tab
            }
            previousTab = tab
        }
    }
    private var previousTab: AppTabs?

    var social: Social
    var news: News
    var scrollToTopTrigger: AppTabs?

    let storage: Database
    let theme = ThemeColor()

    init(inMemory: Bool = false) {
        self.storage = Database(
            models: [
                PodcastDB.self,
                VideoDB.self,
                SettingsDB.self,
                CustomizationDB.self
            ],
            inMemory: inMemory
        )

        let settingsViewModel = SettingsViewModel(storage: self.storage)
        self.settingsViewModel = settingsViewModel
        self.tab = settingsViewModel.tabs.first ?? .news
        self.scrollToTopTrigger = settingsViewModel.tabs.first
        self.social = settingsViewModel.social.first ?? .videos
        self.news = settingsViewModel.news.first ?? .all
        self.colorSchema = settingsViewModel.colorSchema
    }
}
