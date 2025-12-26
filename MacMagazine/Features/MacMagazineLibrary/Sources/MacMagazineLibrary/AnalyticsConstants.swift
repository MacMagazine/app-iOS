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
        case identifyPostsRead(Bool)
        case countPostsOnBadge(Bool)
        case allPostsRead
        case cleanPostsOptions
        case cleanPosts
        case cleanAllPosts

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
            // Podcast Player - Full Player
            case .podcastCloseFullPlayer: return "close_fullplayer"
            case .podcastShowChapters: return "show_chapters"
            case .podcastPreviousChapter: return "previous_chapter"
            case .podcastNextChapter: return "next_chapter"

            // Podcast Player - Mini Player
            case .podcastCloseMiniPlayer: return "close_miniplayer"
            case .podcastOpenFullPlayer: return "open_fullplayer"

            // Podcast Player - Playback Controls
            case .podcastTogglePlayPause: return "toggle_play_pause"
            case .podcastSkipMinus15: return "skip_minus_15"
            case .podcastSkipPlus15: return "skip_plus_15"

            // Podcast Player - Speed Controls
            case .podcastSpeedButton: return "speed_button"
            case .podcastSpeed(let speed): return "speed_\(speed)"
            case .podcastSpeedAdvanced(let value): return "speed_advanced_\(value)"

            // Podcast - Content
            case .podcastStarted(let postId): return "podcast_\(postId)_started"
            case .podcastFavorite: return "favorite_podcast"

            // Videos
            case .videoStarted(let id): return "video_\(id)_started"
            case .videoStopped: return "video_stopped"
            case .videoFavorite: return "favorite_video"

            // Share & Favorite
            case .share: return "share"
            case .favoriteButton: return "favorite_button"

            // Settings - Appearance
            case .theme(let scheme): return "tema \(scheme)"
            case .icon(let type): return "icone \(type)"

            // Settings - Posts Visibility
            case .identifyPostsRead(let value): return "identify_posts_read \(value)"
            case .countPostsOnBadge(let value): return "count_posts_on_badge \(value)"
            case .allPostsRead: return "all_posts_read"
            case .cleanPostsOptions: return "clean_posts_options"
            case .cleanPosts: return "clean_posts"
            case .cleanAllPosts: return "clean_all_posts"

            // Settings - Push Notifications
            case .pushNotifications(let value): return "push_notifications \(value)"

            // Settings - Subscription
            case .restorePurchase: return "restore_purchase"
            case .manageSubscription: return "manage_subscription"
            case .loginPatrao: return "login_patrao"
            case .logoffPatrao: return "logoff_patrao"

            // Settings - About
            case .reportProblem: return "report_problem"
            case .termsConditions: return "terms_conditions"
            case .privacyPolicy: return "privacy_policy"

            // Onboarding
            case .onboardingWelcomeSkip: return "onboarding_welcome_skip"
            case .onboardingWelcomeContinue: return "onboarding_welcome_continue"
            case .onboardingFeaturesSkip: return "onboarding_features_skip"
            case .onboardingFeaturesContinue: return "onboarding_features_continue"
            case .onboardingFeaturePage(let page): return "onboarding_feature_page_\(page)"
            case .onboardingPushSkip: return "onboarding_push_skip"
            case .onboardingPushContinue: return "onboarding_push_continue"
            case .onboardingPushAccepted: return "onboarding_push_accepted"
            case .onboardingPushDenied: return "onboarding_push_denied"
            case .onboardingATTContinue: return "onboarding_att_continue"
            case .onboardingATTAccepted: return "onboarding_att_accepted"
            case .onboardingATTDenied: return "onboarding_att_denied"
            case .onboardingComplete: return "onboarding_complete"
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
            case .newsOrder: return "news_order"
            case .tabOrder: return "tab_order"
            case .socialOrder: return "social_order"
            }
        }
    }
}
