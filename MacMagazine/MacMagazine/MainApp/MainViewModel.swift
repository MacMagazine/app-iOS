import AnalyticsLibrary
import FeedLibrary
import LoggerLibrary
import MacMagazineLibrary
import OnboardingLibrary
import SearchLibrary
import SettingsLibrary
import StorageLibrary
import SwiftData
import SwiftUI
import VideosLibrary
import YouTubeLibrary

@MainActor
@Observable
class MainViewModel {
    var videosViewModel: VideosViewModel
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
    var onboardingCoordinator: OnboardingCoordinator?
    var deepLinkPostURL: String?

    let analytics = AnalyticsManager()
    let pushNotification: PushNotification
    let sessionState = SessionState()
    let storage: Database
    let theme = ThemeColor()
    let logger: LoggerProtocol?

    @ObservationIgnored
    private lazy var _searchViewModel = SearchViewModel(storage: storage)
    var searchViewModel: SearchViewModel { _searchViewModel }

    let models: [any PersistentModel.Type]

    init(
        pushNotification: PushNotification,
        logger: LoggerProtocol? = nil,
        inMemory: Bool = false
    ) {
        self.pushNotification = pushNotification
        self.logger = logger ?? Logger(category: "MacMagazineV5")

        self.models = [
            FeedDB.self,
            PodcastDB.self,
            VideoDB.self,
            SettingsDB.self,
            CustomizationDB.self,
            RecentSearchDB.self
        ]

        self.storage = Database(
            models: models,
            cloudKitDatabase: .private("iCloud.com.brit.macmagazine.cloudkit"),
            inMemory: inMemory
        )

        let settingsViewModel = SettingsViewModel(storage: self.storage, models: models)
        self.settingsViewModel = settingsViewModel

        let videosViewModel = VideosViewModel(storage: self.storage)
        self.videosViewModel = videosViewModel

        self.tab = settingsViewModel.tabs.first ?? .news
        self.scrollToTopTrigger = settingsViewModel.tabs.first
        self.social = settingsViewModel.social.first ?? .videos
        self.news = settingsViewModel.news.first ?? .all

        // Observe storage status changes
        observeStorageStatus()
    }
}

// MARK: - Onboarding

extension MainViewModel {
    var showOnboarding: Bool { onboardingCoordinator != nil }

    func initializeOnboarding() async {
        guard let coordinator = await OnboardingCoordinator.createIfNeeded(
            analytics: analytics,
            pushNotification: pushNotification
        ) else {
            onboardingCoordinator = nil
            return
        }

        coordinator.onComplete = { [weak self] in
            self?.onboardingCoordinator = nil
        }

        onboardingCoordinator = coordinator
    }
}

extension MainViewModel {
    private func observeStorageStatus() {
        func track() {
            withObservationTracking {
                _ = storage.status
            } onChange: {
                Task { @MainActor in
                    switch self.storage.status {
                    case let .done(type):
                        if type == .imported {
                            self.deduplicate()
                        }
                    default: break
                    }
                    track()
                }
            }
        }
        track()
    }

    func deduplicate() {
        models.forEach {
            ($0 as? any ModelDuplicable.Type)?.deduplicate(using: storage.sharedModelContainer.mainContext)
        }
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
