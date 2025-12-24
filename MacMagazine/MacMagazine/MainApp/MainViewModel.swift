import AnalyticsLibrary
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

    let analytics = AnalyticsManager()
    let sessionState = SessionState()
    let storage: Database
    let theme = ThemeColor()

    init(inMemory: Bool = false) {
        let modelsAllowedToClean: [any PersistentModel.Type] = [
            FeedDB.self,
            PodcastDB.self,
            VideoDB.self
        ]

        let models: [any PersistentModel.Type] = [
            SettingsDB.self,
            CustomizationDB.self
        ]

        self.storage = Database(
            models: models + modelsAllowedToClean,
            inMemory: inMemory
        )

        let settingsViewModel = SettingsViewModel(storage: self.storage, models: modelsAllowedToClean)
        self.settingsViewModel = settingsViewModel
        self.tab = settingsViewModel.tabs.first ?? .news
        self.scrollToTopTrigger = settingsViewModel.tabs.first
        self.social = settingsViewModel.social.first ?? .videos
        self.news = settingsViewModel.news.first ?? .all
    }
}

extension News {
    var toNewsCategory: NewsCategory {
        switch self {
        case .all: .all
        case .news: .news
        case .highlights: .highlights
        case .appletv: .appletv
        case .reviews: .reviews
        case .rumors: .rumors
        case .tutoriais: .tutorials
        }
    }
}
