import AnalyticsLibrary
import FeedLibrary
import LoggerLibrary
import MacMagazineLibrary
import OnboardingLibrary
import SafeguardLibrary
import SearchLibrary
import SettingsLibrary
import StorageLibrary
import SwiftData
import SwiftUI
import VideosLibrary
import WidgetKit
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
    private(set) var safeguardCoordinator: SafeguardCoordinator?
    var deepLinkPostURL: String?

    @ObservationIgnored
    private var hasInitializedOnboarding = false

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
    let safeguardModels: [any PersistentModel.Type]

    private let isCloudSyncEnabled: Bool

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

        self.safeguardModels = [
            FeedDB.self,
            PodcastDB.self,
            VideoDB.self
        ]

        self.isCloudSyncEnabled = !inMemory

        self.storage = Database(
            models: models,
            appGroupID: inMemory ? nil : "group.com.brit.macmagazine.data",
            cloudKitDatabase: .automatic,
            inMemory: inMemory
        )

        let settingsViewModel = SettingsViewModel(storage: self.storage, models: models)
        self.settingsViewModel = settingsViewModel

        let videosViewModel = VideosViewModel(storage: self.storage)
        self.videosViewModel = videosViewModel

        self.tab = settingsViewModel.tabs.first ?? .news
        self.scrollToTopTrigger = settingsViewModel.tabs.first
        self.social = settingsViewModel.social.first ?? .videos
        self.news = settingsViewModel.filter ?? settingsViewModel.news.first ?? .all

        // Observe storage status changes
        observeStorageStatus()

        makeSafeguardCoordinator()
    }
}

// MARK: - Deep Link

extension MainViewModel {
    func openDeepLink(_ url: URL, source: String = "widget") {
        deepLinkPostURL = url.absoluteString
        analytics.track(.buttonTap(
            buttonId: AnalyticsConstants.ButtonID.deepLinkOpened(source).id,
            screen: AnalyticsConstants.Screen.deepLinkDetail.name
        ))
    }
}

// MARK: - Onboarding

extension MainViewModel {
    var showOnboarding: Bool { onboardingCoordinator != nil }

    /// Held back while the safeguard flow owns the screen - that flow's `onComplete` calls this
    /// instead, so the two can never be presented at once. The one-shot flag is set before the
    /// first `await` so the two entry points cannot both get through.
    func initializeOnboarding() async {
        guard safeguardCoordinator == nil, !hasInitializedOnboarding else { return }
        hasInitializedOnboarding = true

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

// MARK: - Safeguard

extension MainViewModel {
    /// Decided synchronously during `init`, never from a `.task`: every feature view inside
    /// `MainView` fetches on appear, so the gate has to be resolved before the first render can
    /// compose any of them. The flow itself still runs asynchronously, from `SafeguardView`.
    private func makeSafeguardCoordinator() {
        guard let coordinator = SafeguardCoordinator.createIfNeeded(
            models: safeguardModels,
            mainContext: storage.sharedModelContainer.mainContext,
            statusSource: StorageStatusSource(storage: storage, isSyncEnabled: isCloudSyncEnabled),
            fetch: { [weak self] in await self?.refreshContent() },
            deduplicate: { [weak self] in self?.deduplicate() }
        ) else { return }

        coordinator.onComplete = { [weak self] in
            WidgetCenter.shared.reloadAllTimelines()
            self?.safeguardCoordinator = nil
            Task { await self?.initializeOnboarding() }
        }

        safeguardCoordinator = coordinator
    }

    private func refreshContent() async {
        let feedService = FeedViewModel(storage: storage)
        try? await feedService.getFeed()
        try? await feedService.getPodcast()
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
