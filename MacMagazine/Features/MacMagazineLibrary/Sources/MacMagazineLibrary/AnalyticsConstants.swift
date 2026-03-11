import Foundation

/// Central repository for all analytics tracking constants
///
/// This enum provides type-safe constants for analytics tracking throughout the app.
/// Use these constants instead of hardcoded strings to prevent typos and improve maintainability.
///
/// Example usage:
/// ```swift
/// // Track a screen view
/// .trackScreen(AnalyticsConstants.Screen.videos.name, analytics: analytics)
///
/// // Track a button tap with static ID
/// analytics.track(.buttonTap(
///     buttonId: AnalyticsConstants.ButtonID.share.id,
///     screen: AnalyticsConstants.Screen.videos.name
/// ))
///
/// // Track a button tap with dynamic ID
/// analytics.track(.buttonTap(
///     buttonId: AnalyticsConstants.ButtonID.videoStarted(id: videoId).id,
///     screen: AnalyticsConstants.Screen.videos.name
/// ))
/// ```
public enum AnalyticsConstants {

    // MARK: - Screens

    /// Screen names for analytics tracking
    public enum Screen {
        // News
        case news

        // Podcast
        case podcastFullPlayer
        case podcastMiniPlayer
        case podcast
        case podcastChapters

        // Videos
        case videos

        // Settings
        case settings
        case settingsAppearance
        case settingsPosts

        // Social (derived from Social enum)
        case socialVideos
        case socialPodcast
        case socialInstagram

        // Live
        case live

        // Search
        case search

        // Deep Link
        case deepLinkDetail

        // Other
        case loginPatroes

        // Onboarding
        case onboardingWelcome
        case onboardingFeatures
        case onboardingPermissions

        // Widget
        case widget(String)

        public var name: String {
            switch self {
            // News
            case .news: "Notícias"

            // Podcast
            case .podcastFullPlayer: "Podcast Full-player"
            case .podcastMiniPlayer: "Podcast Mini-player"
            case .podcast: "Podcast"
            case .podcastChapters: "Podcast Chapters"

            // Videos
            case .videos: "Vídeos"

            // Settings
            case .settings: "Ajustes"
            case .settingsAppearance: "Ajustes > Aparência"
            case .settingsPosts: "Ajustes > Posts"

            // Social
            case .socialVideos: "Vídeos"
            case .socialPodcast: "Podcast"
            case .socialInstagram: "Instagram"

            // Live
            case .live: "Live"

            // Search
            case .search: "Busca"

            // Deep Link
            case .deepLinkDetail: "Deep Link"

            // Other
            case .loginPatroes: "Login para patrões"

            // Onboarding
            case .onboardingWelcome: "Onboarding > Welcome"
            case .onboardingFeatures: "Onboarding > Features"
            case .onboardingPermissions: "Onboarding > Permissions"

            // Widget
            case let .widget(type): "Widget \(type)"
            }
        }
    }

    // MARK: - Button IDs

    /// Button identifiers for analytics tracking
    /// Organized by feature/screen for easy discovery
    public enum ButtonID {

        // MARK: News - Content
        case newsStarted(postId: Int)
        case newsFavorite
        case news(filter: NewsCategory)

        // MARK: Podcast Player - Full Player
        case podcastCloseFullPlayer
        case podcastShowChapters
        case podcastPreviousChapter
        case podcastNextChapter

        // MARK: Podcast Player - Mini Player
        case podcastCloseMiniPlayer
        case podcastOpenFullPlayer

        // MARK: Podcast Player - Playback Controls (Shared)
        case podcastTogglePlayPause
        case podcastSkipMinus15
        case podcastSkipPlus15

        // MARK: Podcast Player - Speed Controls
        case podcastSpeedButton
        case podcastSpeed(Double)
        case podcastSpeedAdvanced(Double)

        // MARK: Podcast - Content
        case podcastStarted(postId: Int)
        case podcastFavorite

        // MARK: Videos
        case videoStarted(id: String)
        case videoStopped
        case videoFavorite

        // MARK: Share & Favorite (Common)
        case share
        case favoriteButton

        // MARK: Settings - Appearance
        case theme(String)
        case icon(String)

        // MARK: Settings - Posts Visibility
        case countPostsOnBadge(Bool)
        case cleanPostsOptions
        case cleanPosts
        case cleanAllPosts
        case cleanOnboarding
        case allPostsRead

        // MARK: Settings - Push Notifications
        case pushNotifications(String)

        // MARK: Settings - Subscription
        case restorePurchase
        case manageSubscription
        case loginPatrao
        case logoffPatrao

        // MARK: Settings - About
        case reportProblem
        case termsConditions
        case privacyPolicy

        // MARK: Navigation
        case tabSelected(String)
        case sidebarItemSelected(String)
        case categoryFilterChanged(String)
        case deepLinkOpened(String)

        // MARK: Search
        case searchResultSelected(type: String, id: String)
        case recentSearchTapped
        case recentSearchCleared
        case recentSearchRemoved

        // MARK: Content Interactions
        case highlightCardTapped(String)
        case pullToRefresh(String)

        // MARK: Lifecycle
        case appLaunched

        // MARK: Onboarding
        case onboardingWelcomeSkip
        case onboardingWelcomeContinue
        case onboardingFeaturesSkip
        case onboardingFeaturesContinue
        case onboardingFeaturePage(Int)
        case onboardingPushSkip
        case onboardingPushContinue
        case onboardingPushAccepted
        case onboardingPushDenied
        case onboardingATTContinue
        case onboardingATTAccepted
        case onboardingATTDenied
        case onboardingComplete

        public var id: String {
            switch self {
            // Podcast - Content
            case let .newsStarted(postId): "news_\(postId)_started"
            case .newsFavorite: "favorite_news"
            case let .news(filter): "news_\(filter)"

            // Podcast Player - Full Player
            case .podcastCloseFullPlayer: "close_fullplayer"
            case .podcastShowChapters: "show_chapters"
            case .podcastPreviousChapter: "previous_chapter"
            case .podcastNextChapter: "next_chapter"

            // Podcast Player - Mini Player
            case .podcastCloseMiniPlayer: "close_miniplayer"
            case .podcastOpenFullPlayer: "open_fullplayer"

            // Podcast Player - Playback Controls
            case .podcastTogglePlayPause: "toggle_play_pause"
            case .podcastSkipMinus15: "skip_minus_15"
            case .podcastSkipPlus15: "skip_plus_15"

            // Podcast Player - Speed Controls
            case .podcastSpeedButton: "speed_button"
            case let .podcastSpeed(speed): "speed_\(speed)"
            case let .podcastSpeedAdvanced(value): "speed_advanced_\(value)"

            // Podcast - Content
            case let .podcastStarted(postId): "podcast_\(postId)_started"
            case .podcastFavorite: "favorite_podcast"

            // Videos
            case let .videoStarted(id): "video_\(id)_started"
            case .videoStopped: "video_stopped"
            case .videoFavorite: "favorite_video"

            // Share & Favorite
            case .share: "share"
            case .favoriteButton: "favorite_button"

            // Settings - Appearance
            case let .theme(scheme): "tema \(scheme)"
            case let .icon(type): "icone \(type)"

            // Settings - Posts Visibility
            case let .countPostsOnBadge(value): "count_posts_on_badge \(value)"
            case .cleanPostsOptions: "clean_posts_options"
            case .cleanPosts: "clean_posts"
            case .cleanAllPosts: "clean_all_posts"
            case .cleanOnboarding: "clean_onboarding"
            case .allPostsRead: "all_posts_read"

            // Settings - Push Notifications
            case let .pushNotifications(value): "push_notifications \(value)"

            // Settings - Subscription
            case .restorePurchase: "restore_purchase"
            case .manageSubscription: "manage_subscription"
            case .loginPatrao: "login_patrao"
            case .logoffPatrao: "logoff_patrao"

            // Settings - About
            case .reportProblem: "report_problem"
            case .termsConditions: "terms_conditions"
            case .privacyPolicy: "privacy_policy"

            // Navigation
            case let .tabSelected(tab): "tab_\(tab)"
            case let .sidebarItemSelected(item): "sidebar_\(item)"
            case let .categoryFilterChanged(category): "category_\(category)"
            case let .deepLinkOpened(source): "deep_link_\(source)"

            // Search
            case let .searchResultSelected(type, id): "search_result_\(type)_\(id)"
            case .recentSearchTapped: "recent_search_tapped"
            case .recentSearchCleared: "recent_search_cleared"
            case .recentSearchRemoved: "recent_search_removed"

            // Content Interactions
            case let .highlightCardTapped(postId): "highlight_\(postId)_tapped"
            case let .pullToRefresh(screen): "pull_to_refresh_\(screen)"

            // Lifecycle
            case .appLaunched: "app_launched"

            // Onboarding
            case .onboardingWelcomeSkip: "onboarding_welcome_skip"
            case .onboardingWelcomeContinue: "onboarding_welcome_continue"
            case .onboardingFeaturesSkip: "onboarding_features_skip"
            case .onboardingFeaturesContinue: "onboarding_features_continue"
            case let .onboardingFeaturePage(page): "onboarding_feature_page_\(page)"
            case .onboardingPushSkip: "onboarding_push_skip"
            case .onboardingPushContinue: "onboarding_push_continue"
            case .onboardingPushAccepted: "onboarding_push_accepted"
            case .onboardingPushDenied: "onboarding_push_denied"
            case .onboardingATTContinue: "onboarding_att_continue"
            case .onboardingATTAccepted: "onboarding_att_accepted"
            case .onboardingATTDenied: "onboarding_att_denied"
            case .onboardingComplete: "onboarding_complete"
            }
        }
    }

    // MARK: - Generic Events

    /// Generic event names for analytics tracking
    public enum GenericEvent {
        case newsOrder
        case tabOrder
        case socialOrder

        public var name: String {
            switch self {
            case .newsOrder: "news_order"
            case .tabOrder: "tab_order"
            case .socialOrder: "social_order"
            }
        }
    }
}
