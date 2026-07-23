# Graph Report - MacMagazine  (2026-07-23)

## Corpus Check
- 337 files · ~364,352 words
- Verdict: corpus is large enough that graph structure adds value.

## Summary
- 2859 nodes · 5349 edges · 206 communities (177 shown, 29 thin omitted)
- Extraction: 88% EXTRACTED · 12% INFERRED · 0% AMBIGUOUS · INFERRED: 635 edges (avg confidence: 0.8)
- Token cost: 0 input · 0 output

## Graph Freshness
- Built from commit: `9b3f28cd`
- Run `git rev-parse HEAD` and compare to check if the graph is stale.
- Run `graphify update .` after code changes (no API cost).

## Community Hubs (Navigation)
- Settings & Subscriptions
- Live Content & Notifications
- Analytics Library
- Analytics Event Constants
- XML Feed Parsing
- WebView HTML & Disqus
- .claude Config & Hooks
- News Feature
- Feed Service
- FeedLibrary Imports
- WebView Cookies
- Podcast Feature
- In-App Purchases
- FeedDB Model & Tests
- API Endpoints
- Podcast Full Player UI
- PodcastDB Model & Tests
- Card Content & Menus
- Search ViewModel Tests
- Podcast Chapter Colors
- Search System
- Podcast Player Manager
- Community 22
- Community 23
- Community 24
- Community 25
- Community 26
- Community 27
- Community 28
- Community 29
- Community 30
- Community 31
- Community 32
- Community 33
- Community 34
- Community 35
- Community 36
- Community 37
- Community 38
- Community 39
- Community 40
- Community 41
- Community 42
- Community 43
- Community 44
- Community 45
- Community 46
- Community 47
- Community 48
- Community 49
- Community 50
- Community 51
- Community 52
- Community 53
- Community 54
- Community 55
- Community 56
- Community 57
- Community 58
- Community 59
- Community 60
- Community 61
- Community 62
- Community 63
- Community 64
- Community 65
- Community 66
- Community 67
- Community 68
- Community 69
- Community 70
- Community 71
- Community 72
- Community 73
- Community 74
- Community 75
- Community 76
- Community 77
- Community 78
- Community 79
- Community 80
- Community 81
- Community 82
- Community 83
- Community 84
- Community 85
- Community 86
- Community 87
- Community 88
- Community 89
- Community 90
- Community 91
- Community 92
- Community 93
- Community 94
- Community 95
- Community 96
- Community 97
- Community 98
- Community 99
- Community 100
- Community 101
- Community 102
- Community 103
- Community 104
- Community 105
- Community 106
- Community 107
- Community 108
- Community 109
- Community 110
- Community 111
- Community 112
- Community 113
- Community 114
- Community 115
- Community 116
- Community 117
- Community 118
- Community 119
- Community 120
- Community 121
- Community 122
- Community 123
- Community 124
- Community 125
- Community 126
- Community 127
- Community 128
- Community 129
- Community 130
- Community 131
- Community 132
- Community 133
- Community 134
- Community 135
- Community 136
- Community 137
- Community 138
- Community 139
- Community 140
- Community 141
- Community 142
- Community 143
- Community 144
- Community 145
- Community 146
- Community 147
- Community 148
- Community 149
- Community 150
- Community 151
- Community 152
- Community 153
- Community 154
- Community 155
- Community 156
- Community 157
- Community 158
- Community 159
- App do MacMagazine para iOS
- Firebase Configuration
- iOS Design Guidelines for MacMagazine
- MMWebView
- Guia de Contribuição
- YOUR PRIME DIRECTIVES
- NewsCategory
- Anti-hallucination & pattern-fidelity contract
- Skills Quick Reference
- Criando um Pull Request
- Git workflow
- Swift Style — naming, optionals, lint, comments
- Critical Requirements (Zero Tolerance)
- PULL_REQUEST_TEMPLATE.md
- WalletPassService
- Testing — Swift Testing
- Configuração do ambiente
- Concurrency — Swift 6.2, structured only
- MinimumTouchTarget
- View
- Validações automáticas
- Fluxo de trabalho
- swift-code-reviewer.md
- .makeHTML
- PodcastPlayerManager.swift
- Options
- Padrões de código
- Troubleshooting
- architecture-guardian.md
- test-runner.md
- ThemeColor.swift
- NewsCategory
- AppearanceViewModel
- MMNavigationDecider
- Associated Domains (Universal Links)
- AppDefinitionsTests.swift
- Options
- NewsCategoryExtensions.swift
- ArrayExtensions.swift
- AppDefinitionsTests.swift
- OnboardingCoordinatorTests.swift
- .change
- WidgetView
- CMTime
- EnvironmentValuesExtensions.swift

## God Nodes (most connected - your core abstractions)
1. `SwiftUI` - 121 edges
2. `Foundation` - 113 edges
3. `MacMagazineLibrary` - 96 edges
4. `Database` - 79 edges
5. `ButtonID` - 65 edges
6. `FeedLibrary` - 56 edges
7. `FeedDB` - 51 edges
8. `StorageLibrary` - 50 edges
9. `AnalyticsLibrary` - 48 edges
10. `Database` - 48 edges

## Surprising Connections (you probably didn't know these)
- `MacMagazineTimelineProvider` --calls--> `FeedViewModel`  [INFERRED]
  MacMagazine/Widget/Timeline/MacMagazineTimelineProvider.swift → MacMagazine/Features/FeedLibrary/Sources/FeedLibrary/ViewModel/FeedViewModel.swift
- `MainViewModel` --calls--> `ThemeColor`  [INFERRED]
  MacMagazine/MacMagazine/MainApp/MainViewModel.swift → MacMagazine/Features/MacMagazineLibrary/Sources/MacMagazineLibrary/ThemeColor.swift
- `ContentPreview` --calls--> `CardContent`  [INFERRED]
  MacMagazine/Features/MacMagazineUILibrary/Sources/MacMagazineUILibrary/PreviewData/ContentPreview.swift → MacMagazine/Features/MacMagazineUILibrary/Sources/MacMagazineUILibrary/Cards/Model/CardContent.swift
- `DisqusSheet` --calls--> `DisqusNewWindowHandler`  [INFERRED]
  MacMagazine/Features/MacMagazineUILibrary/Sources/MacMagazineUILibrary/Webview/Disqus/DisqusWebView.swift → MacMagazine/Features/MacMagazineUILibrary/Sources/MacMagazineUILibrary/Webview/Disqus/DisqusNewWindowHandler.swift
- `MMWebView` --calls--> `GalleryStateMessageHandler`  [INFERRED]
  MacMagazine/Features/MacMagazineUILibrary/Sources/MacMagazineUILibrary/Webview/MMWebView.swift → MacMagazine/Features/MacMagazineUILibrary/Sources/MacMagazineUILibrary/Webview/GalleryStateMessageHandler.swift

## Import Cycles
- None detected.

## Communities (206 total, 29 thin omitted)

### Community 0 - "Settings & Subscriptions"
Cohesion: 0.14
Nodes (4): SettingsViewModel, Database, PersistentModel, SettingsViewModelTests

### Community 1 - "Live Content & Notifications"
Cohesion: 0.05
Nodes (45): Date, Bool, String, MMLive, PushNotification, PushNotificationProtocol, Storage, MMLiveViewModel (+37 more)

### Community 2 - "Analytics Library"
Cohesion: 0.09
Nodes (7): DynamicTypeSize, Bool, MacMagazineLibrary, StoreKit, SwiftUI, UIComponentsLibrary, UtilityLibrary

### Community 3 - "Analytics Event Constants"
Cohesion: 0.03
Nodes (64): ButtonID, appLaunched, categoryFilterChanged, cleanAllPosts, cleanOnboarding, cleanPosts, cleanPostsOptions, deepLinkOpened (+56 more)

### Community 4 - "XML Feed Parsing"
Cohesion: 0.06
Nodes (22): DateFormatter, APIXMLParser, Bool, CheckedContinuation, Error, Int, String, DateParser (+14 more)

### Community 5 - "WebView HTML & Disqus"
Cohesion: 0.12
Nodes (12): Int, Bool, Utils, HTTPCookie, ColorScheme, dark, light, system (+4 more)

### Community 6 - ".claude Config & Hooks"
Cohesion: 0.04
Nodes (47): hooks, PostToolUse, PreToolUse, Stop, permissions, allow, ask, deny (+39 more)

### Community 7 - "News Feature"
Cohesion: 0.09
Nodes (22): Filter, NewsViewModel, APIStatus, Database, FeedDB, Int, NetworkMockData, Options (+14 more)

### Community 8 - "Feed Service"
Cohesion: 0.10
Nodes (17): FeedViewModel, Bool, CheckedContinuation, Data, Database, Error, FeedDB, Int (+9 more)

### Community 9 - "FeedLibrary Imports"
Cohesion: 0.08
Nodes (11): FeedLibrary, Foundation, String, APIDefinitions, URLs, MMLiveLibrary, NetworkLibrary, StorageLibrary (+3 more)

### Community 10 - "WebView Cookies"
Cohesion: 0.08
Nodes (7): Cookies, Bool, HTTPCookie, String, TimeInterval, CookiesTests, WKHTTPCookieStore

### Community 11 - "Podcast Feature"
Cohesion: 0.11
Nodes (20): PodcastViewModel, APIStatus, Database, Int, NetworkMockData, Options, PodcastView, AnalyticsManager (+12 more)

### Community 12 - "In-App Purchases"
Cohesion: 0.13
Nodes (16): InAppManager, InAppProduct, InAppStatus, Status, error, idle, loading, purchasable (+8 more)

### Community 13 - "FeedDB Model & Tests"
Cohesion: 0.09
Nodes (5): FeedDB, Bool, ModelContext, String, FeedDBTests

### Community 14 - "API Endpoints"
Cohesion: 0.13
Nodes (17): Array, CardAccessibilityModifier, CardButton, favorite, read, share, CardLabel, author (+9 more)

### Community 15 - "Podcast Full Player UI"
Cohesion: 0.09
Nodes (23): Data, FullPlayerView, PlayerAccessibilityPriority, PodcastBackgroundGradientStyle, fourTone, threeTone, twoTone, AnalyticsManager (+15 more)

### Community 16 - "PodcastDB Model & Tests"
Cohesion: 0.10
Nodes (6): PodcastDB, Bool, Double, ModelContext, String, PodcastDBTests

### Community 17 - "Card Content & Menus"
Cohesion: 0.09
Nodes (24): CardContent, AnalyticsManager, Bool, CGFloat, Int, String, Void, MenuButton (+16 more)

### Community 18 - "Search ViewModel Tests"
Cohesion: 0.16
Nodes (10): makeResult(), MockLocalSearchService, MockMerger, MockRemoteSearchService, SearchViewModelTests, Error, Int, ModelContext (+2 more)

### Community 19 - "Podcast Chapter Colors"
Cohesion: 0.15
Nodes (5): Color, createChapter(), PodcastChapterTests, Double, String

### Community 20 - "Search System"
Cohesion: 0.12
Nodes (17): RecentSearchDB, String, LocalSearchServiceProtocol, RemoteSearchServiceProtocol, SearchResultMerger, SearchResultMergerProtocol, SearchViewModel, Bool (+9 more)

### Community 21 - "Podcast Player Manager"
Cohesion: 0.15
Nodes (8): AVPlayer, AVPlayerItem, Float, PodcastPlayerManager, Any, Double, PodcastDB, TimeInterval

### Community 23 - "Community 23"
Cohesion: 0.10
Nodes (18): CaseIterable, NewsCategory, all, appletv, highlights, news, podcast, reviews (+10 more)

### Community 24 - "Community 24"
Cohesion: 0.13
Nodes (7): FirebaseCore, InAppLibrary, LoggerLibrary, OneSignalFramework, os, PassKit, UIKit

### Community 26 - "Community 26"
Cohesion: 0.15
Nodes (5): createChapter(), createTestChapters(), PodcastPlayerManagerTests, Double, String

### Community 27 - "Community 27"
Cohesion: 0.10
Nodes (16): SearchStatus, done, error, idle, localResults, searching, SearchView, AnalyticsManager (+8 more)

### Community 28 - "Community 28"
Cohesion: 0.14
Nodes (15): ActivityAttributes, ActivityKit, Codable, News, all, appletv, highlights, news (+7 more)

### Community 29 - "Community 29"
Cohesion: 0.19
Nodes (4): QueryProcessor, String, QueryProcessorTests, NaturalLanguage

### Community 30 - "Community 30"
Cohesion: 0.10
Nodes (21): Screen, deepLinkDetail, live, loginPatroes, news, onboardingFeatures, onboardingPermissions, onboardingWelcome (+13 more)

### Community 31 - "Community 31"
Cohesion: 0.16
Nodes (8): APIStatus, Database, ModelContext, NetworkMockData, Options, YouTubeAPI, VideosViewModel, VideosViewModelTests

### Community 32 - "Community 32"
Cohesion: 0.16
Nodes (13): PodcastChapter, Data, Double, String, ChaptersView, AnalyticsManager, Binding, Bool (+5 more)

### Community 33 - "Community 33"
Cohesion: 0.14
Nodes (3): Database, Set, StorageServiceTests

### Community 34 - "Community 34"
Cohesion: 0.22
Nodes (8): BridgeViewController, InteractivePopGestureBridge, Bool, Context, UIGestureRecognizer, UIGestureRecognizerDelegate, UIViewController, UIViewControllerRepresentable

### Community 35 - "Community 35"
Cohesion: 0.17
Nodes (9): PermissionManager, AnalyticsManager, Bool, PushNotification, String, OnboardingSheetPreviewHost, WelcomeSheetPreviewHost, FeaturesViewSheetPreviewHost (+1 more)

### Community 36 - "Community 36"
Cohesion: 0.12
Nodes (12): AnalyticsLibrary, Constants, News, NewsCategory, MacMagazineUILibrary, NewsLibrary, OnboardingLibrary, PodcastLibrary (+4 more)

### Community 37 - "Community 37"
Cohesion: 0.24
Nodes (5): RemoteFeedSearchServiceTests, FeedDB, PodcastDB, SearchResult, String

### Community 38 - "Community 38"
Cohesion: 0.20
Nodes (9): areEqual(), Equatable, Bool, AreEqualTests, Text, MainView, CaseIterable, String (+1 more)

### Community 39 - "Community 39"
Cohesion: 0.18
Nodes (12): Context, Sendable, WidgetData, WidgetEntry, WatchWidgetProvider, MacMagazineTimelineProvider, Context, Void (+4 more)

### Community 40 - "Community 40"
Cohesion: 0.23
Nodes (6): SearchResult, String, SearchResultMergerTests, Bool, SearchResult, String

### Community 41 - "Community 41"
Cohesion: 0.17
Nodes (11): Any, AnyHashable, Bool, Data, Error, UIApplication, UIScene, UISceneSession (+3 more)

### Community 42 - "Community 42"
Cohesion: 0.16
Nodes (9): LinearGradient, CardDensity, Bool, CGFloat, Font, Int, GlassCardView, AnalyticsManager (+1 more)

### Community 43 - "Community 43"
Cohesion: 0.16
Nodes (3): Subscription, Bool, SubscriptionTests

### Community 44 - "Community 44"
Cohesion: 0.17
Nodes (10): AppTabs, live, news, search, settings, social, AppTabsTests, SocialView (+2 more)

### Community 45 - "Community 45"
Cohesion: 0.14
Nodes (13): OnboardingCoordinator, AnalyticsManager, Bool, PushNotification, Void, OnboardingContainerView, Bool, Bool (+5 more)

### Community 46 - "Community 46"
Cohesion: 0.12
Nodes (16): Card views, Data Layer — SwiftData, search, podcast, multi-platform, Data sources, External dependencies, Key types, Mini player, Multi-platform, NLP pipeline (Apple NaturalLanguage framework) (+8 more)

### Community 47 - "Community 47"
Cohesion: 0.17
Nodes (9): GalleryStateMessageHandler, Bool, Void, WKScriptMessage, WKUserContentController, Bool, String, WebPage (+1 more)

### Community 48 - "Community 48"
Cohesion: 0.18
Nodes (10): AboutViewModel, MailDelegate, Error, AboutView, AnalyticsManager, MessageUI, MFMailComposeResult, MFMailComposeViewController (+2 more)

### Community 49 - "Community 49"
Cohesion: 0.22
Nodes (9): LeftIcon, SpeedWheelPicker, Binding, CGFloat, Double, Int, String, Wrapper (+1 more)

### Community 50 - "Community 50"
Cohesion: 0.19
Nodes (6): CardContentType, news, podcast, video, NewsCategory, CardContentTypeTests

### Community 51 - "Community 51"
Cohesion: 0.14
Nodes (7): Bool, ScenePhase, UUID, WebViewLoadPolicy, Bool, ScenePhase, WebViewLoadPolicyTests

### Community 52 - "Community 52"
Cohesion: 0.05
Nodes (39): Encodable, PushNotification, PushNotificationDefinition, PushPermissionStatus, authorized, denied, notDetermined, Any (+31 more)

### Community 53 - "Community 53"
Cohesion: 0.10
Nodes (9): WidgetAccessibility, Widget, WatchWidgetBundle, MacMagazineWidgetBundle, Widget, OneSignalExtension, UserNotifications, WidgetBundle (+1 more)

### Community 55 - "Community 55"
Cohesion: 0.15
Nodes (12): CustomizationViewModel, Database, News, CustomSocialView, AnalyticsManager, IndexSet, Int, CustomTabView (+4 more)

### Community 56 - "Community 56"
Cohesion: 0.15
Nodes (12): SessionState, Bool, SceneView, PushNotification, MainViewModel, Bool, Database, LoggerProtocol (+4 more)

### Community 57 - "Community 57"
Cohesion: 0.26
Nodes (7): AddPassesView, Coordinator, Context, Void, WalletPassSheet, PKAddPassesViewController, PKAddPassesViewControllerDelegate

### Community 58 - "Community 58"
Cohesion: 0.19
Nodes (4): Data, String, WidgetData, WidgetDataTests

### Community 59 - "Community 59"
Cohesion: 0.21
Nodes (8): RelevanceScorer, SearchResult, Double, SearchResult, String, RelevanceScorerTests, SearchResult, String

### Community 60 - "Community 60"
Cohesion: 0.24
Nodes (7): FeedMainViewModel, Bool, CGPoint, FeedDB, Int, ModelContext, String

### Community 61 - "Community 61"
Cohesion: 0.18
Nodes (7): AnalyticsConstants, Social, instagram, podcast, videos, SocialTests, Int

### Community 62 - "Community 62"
Cohesion: 0.25
Nodes (10): Edge, ManagedWebView, ManagedWebViewStyle, async, Binding, Bool, MainActor, UUID (+2 more)

### Community 63 - "Community 63"
Cohesion: 0.19
Nodes (8): DisqusDataStore, DisqusLoginWebView, DisqusSheet, MainActor, String, Void, WebPage, WKWebsiteDataStore

### Community 64 - "Community 64"
Cohesion: 0.15
Nodes (11): Cache, cleanAll, keepFavoritesAndStatus, PostsVisibilityViewModel, Database, ModelContext, PersistentModel, T (+3 more)

### Community 65 - "Community 65"
Cohesion: 0.19
Nodes (10): FailingNetworkStub, StubNetwork, Data, String, FeedDB, String, String, URL (+2 more)

### Community 66 - "Community 66"
Cohesion: 0.33
Nodes (8): AdaptiveBody, AdaptiveVideoCard, MMVideoDBPreview, AnalyticsManager, ModelContext, VideoDB, View, VideoCard

### Community 67 - "Community 67"
Cohesion: 0.19
Nodes (9): Identifiable, OnBoardingFeature, String, FeaturesView, Bool, CGFloat, GridItem, Int (+1 more)

### Community 68 - "Community 68"
Cohesion: 0.15
Nodes (12): CardStyle, glass, header, highlight, leadingImage, NewsCategory, FeedDB, AnalyticsManager (+4 more)

### Community 69 - "Community 69"
Cohesion: 0.27
Nodes (8): SearchResultsList, AnalyticsManager, FeedDB, PodcastDB, SearchResult, String, VideoDB, Void

### Community 70 - "Community 70"
Cohesion: 0.20
Nodes (8): PushPreferences, all, featured, Bool, PushOptionsViewModel, Database, PushOptionsView, AnalyticsManager

### Community 71 - "Community 71"
Cohesion: 0.26
Nodes (8): FeedRowPositionReporter, FeedScrollPositionKey, CGPoint, Content, String, View, View, PreferenceKey

### Community 72 - "Community 72"
Cohesion: 0.18
Nodes (11): PodcastImageView, Content, Data, FeedMainView, FeedDB, FeedMainViewModel, String, Void (+3 more)

### Community 73 - "Community 73"
Cohesion: 0.22
Nodes (8): ShortcutManager, ModelContext, String, UIApplicationShortcutItem, Bool, UIApplicationShortcutItem, Void, UIWindowScene

### Community 74 - "Community 74"
Cohesion: 0.33
Nodes (10): Header, CollectionViewWithHeader, APIStatus, Binding, Bool, Content, Int, ScrollPosition (+2 more)

### Community 77 - "Community 77"
Cohesion: 0.12
Nodes (15): 10. WebView System Integrity, 1. Obvious Comments, 2. Force Unwraps in Production Code, 3. @Observable Usage, 4. Card System Compliance, 5. Hardcoded Colors, 6. SwiftLint Compliance, 7. DRY Violations (+7 more)

### Community 78 - "Community 78"
Cohesion: 0.18
Nodes (4): String, MMWebViewUserScripts, WebKit, WKUserScript

### Community 80 - "Community 80"
Cohesion: 0.14
Nodes (18): NetworkService, Data, Network, ContentType, news, podcast, video, QueryIntent (+10 more)

### Community 81 - "Community 81"
Cohesion: 0.27
Nodes (9): NewsView, Content, Options, ToolbarModifier, ToolbarType, compact, normal, View (+1 more)

### Community 83 - "Community 83"
Cohesion: 0.12
Nodes (15): 1. Understand Requirements, 2. Search for Existing Code (Avoid Duplication), 3. Study Existing Implementations (CRITICAL), 4. Design Architecture, 5. Set Up Feature Branch, 6. Build System Reference, Architecture Patterns, Before Writing Code (+7 more)

### Community 84 - "Community 84"
Cohesion: 0.33
Nodes (6): HeaderWidgetModifier, OverlayHeaderWidgetModifier, CGFloat, Content, String, View

### Community 85 - "Community 85"
Cohesion: 0.18
Nodes (10): String, URLClassification, appStore, comments, external, instagram, macmagazinePost, walletPass (+2 more)

### Community 88 - "Community 88"
Cohesion: 0.27
Nodes (9): FeedHighlightsCarouselView, Layout, Binding, Bool, CGFloat, FeedDB, Int, ScrollPosition (+1 more)

### Community 89 - "Community 89"
Cohesion: 0.33
Nodes (5): PortugueseLexicon, Bool, NewsCategory, Set, String

### Community 90 - "Community 90"
Cohesion: 0.14
Nodes (13): Adding a new module, Architecture — modular SPM, MVVM, environment injection, Build targets, Custom environment values, Deep linking, Dependency rules (enforced by review + the architecture-guardian agent), Environment injection (MacMagazineApp), Modular SPM structure (+5 more)

### Community 91 - "Community 91"
Cohesion: 0.18
Nodes (11): String, WidgetConfiguration, WatchWidget, MacMagazineWidget, String, WidgetConfiguration, MacMagazineWidgetLiveActivity, WidgetConfiguration (+3 more)

### Community 92 - "Community 92"
Cohesion: 0.36
Nodes (6): PeekPopModifier, Content, FeedDB, String, Void, View

### Community 93 - "Community 93"
Cohesion: 0.31
Nodes (6): NetworkService, Data, Int, Network, NewsCategory, String

### Community 94 - "Community 94"
Cohesion: 0.33
Nodes (7): PermissionCard, PermissionCardStatus, denied, granted, notDetermined, String, Void

### Community 95 - "Community 95"
Cohesion: 0.33
Nodes (7): CustomizationDB, Bool, Int, ModelContext, News, String, UUID

### Community 96 - "Community 96"
Cohesion: 0.31
Nodes (6): ReadingPreferencesViewModel, Bool, Database, PersistentModel, ReadingPreferencesView, AnalyticsManager

### Community 97 - "Community 97"
Cohesion: 0.25
Nodes (8): LayoutType, sidebar, tabbar, MainView, NavigationState, CaseIterable, NavigationSplitViewVisibility, UserInterfaceSizeClass

### Community 98 - "Community 98"
Cohesion: 0.32
Nodes (7): App, MacMagazineApp, Scene, Database, FeedMainViewModel, Scene, WatchApp

### Community 99 - "Community 99"
Cohesion: 0.36
Nodes (5): PaginatedForEach, Bool, Content, Element, Int

### Community 100 - "Community 100"
Cohesion: 0.25
Nodes (6): DisqusNewWindowHandler, MainActor, Void, WKScriptMessage, WKUserContentController, WKScriptMessageHandler

### Community 101 - "Community 101"
Cohesion: 0.29
Nodes (7): String, WebViewStatus, done, error, idle, loading, WebViewStatusOverlay

### Community 102 - "Community 102"
Cohesion: 0.36
Nodes (3): Bool, Double, View

### Community 103 - "Community 103"
Cohesion: 0.31
Nodes (5): PodcastMiniPlayerModifier, AnalyticsManager, Content, View, ViewModifier

### Community 104 - "Community 104"
Cohesion: 0.32
Nodes (5): RemoteFeedSearchService, Database, Int, SearchResult, String

### Community 105 - "Community 105"
Cohesion: 0.36
Nodes (5): PlainButtonTextStyle, Color, Content, Font, View

### Community 106 - "Community 106"
Cohesion: 0.50
Nodes (4): CGFloat, Image, WidgetData, WidgetElementView

### Community 107 - "Community 107"
Cohesion: 0.31
Nodes (7): CustomProductViewStyle, Configuration, String, Themeable, View, Void, ProductViewStyle

### Community 108 - "Community 108"
Cohesion: 0.33
Nodes (5): Glass, MenuView, Binding, Bool, T

### Community 109 - "Community 109"
Cohesion: 0.18
Nodes (8): CustomHost, APIDefinitions, Endpoint, Int, Self, String, Endpoint, Self

### Community 110 - "Community 110"
Cohesion: 0.33
Nodes (5): GenericEvent, newsOrder, socialOrder, tabOrder, String

### Community 111 - "Community 111"
Cohesion: 0.40
Nodes (3): AccessibilityChildBehavior, String, View

### Community 112 - "Community 112"
Cohesion: 0.29
Nodes (5): OnboardingFadeModifier, Bool, Content, Double, View

### Community 113 - "Community 113"
Cohesion: 0.38
Nodes (5): PodcastDB, AnalyticsManager, Double, ModelContext, String

### Community 114 - "Community 114"
Cohesion: 0.31
Nodes (7): ContentSheet, PatronLoginSheet, SettingsView, AnalyticsManager, String, Void, WebPage

### Community 115 - "Community 115"
Cohesion: 0.38
Nodes (4): AnalyticsManager, ModelContext, String, VideoDB

### Community 116 - "Community 116"
Cohesion: 0.43
Nodes (5): NavigationModifier, Bool, Content, String, View

### Community 117 - "Community 117"
Cohesion: 0.38
Nodes (4): FeedDotsIndicatorView, CGFloat, Color, Int

### Community 118 - "Community 118"
Cohesion: 0.33
Nodes (4): AccessibilityChildBehavior, String, View, WidgetAccessibility

### Community 119 - "Community 119"
Cohesion: 0.48
Nodes (4): SmallWidgetStyleModifier, Content, Image, View

### Community 120 - "Community 120"
Cohesion: 0.60
Nodes (5): AnyObject, ModelDuplicable, ModelFavoritable, ModelReadable, PersistentModel

### Community 121 - "Community 121"
Cohesion: 0.33
Nodes (6): Hashable, OnboardingScreen, features, permissions, welcome, String

### Community 122 - "Community 122"
Cohesion: 0.29
Nodes (6): Gesture, MiniPlayerView, AnalyticsManager, Color, PodcastDB, String

### Community 123 - "Community 123"
Cohesion: 0.32
Nodes (7): AnalyticsManager, Binding, Bool, Database, ScrollPosition, String, VideosView

### Community 124 - "Community 124"
Cohesion: 0.47
Nodes (3): ButtonWithGlassEffect, Content, View

### Community 125 - "Community 125"
Cohesion: 0.40
Nodes (3): OnboardingLogoView, CGFloat, CGFloat

### Community 126 - "Community 126"
Cohesion: 0.14
Nodes (13): Common MacMagazine Bug Patterns, Enforcement, FAIL Conditions, iOS Bug Fix & Refactoring, Remote search missing podcasts/videos, Search results showing wrong card type, Step 1: Investigation (MANDATORY), Step 2: Fix Implementation (+5 more)

### Community 127 - "Community 127"
Cohesion: 0.40
Nodes (4): FeedMainViewModel, FeedPreviewHost, Bool, ModelContainer

### Community 128 - "Community 128"
Cohesion: 0.60
Nodes (3): FavoriteView, FavoriteShareGlassContainer, ShareView

### Community 129 - "Community 129"
Cohesion: 0.40
Nodes (5): Status, done, error, idle, loading

### Community 130 - "Community 130"
Cohesion: 0.22
Nodes (9): View, FavoriteButton, Bool, Void, ReadButton, Bool, Void, ShareButton (+1 more)

### Community 131 - "Community 131"
Cohesion: 0.50
Nodes (4): PreviewData, Bool, FeedDB, String

### Community 132 - "Community 132"
Cohesion: 0.40
Nodes (3): Array, Element, Int

### Community 133 - "Community 133"
Cohesion: 0.40
Nodes (5): ATTPermissionStatus, authorized, denied, notDetermined, restricted

### Community 134 - "Community 134"
Cohesion: 0.29
Nodes (5): AppDelegate, LoggerProtocol, PushNotification, Notification, UIApplicationDelegate

### Community 135 - "Community 135"
Cohesion: 0.70
Nodes (4): OnboardingTitleView, Bool, Double, String

### Community 136 - "Community 136"
Cohesion: 0.40
Nodes (5): DeepLinkNewsDetailView, AnalyticsManager, FeedDB, String, Void

### Community 137 - "Community 137"
Cohesion: 0.40
Nodes (3): String, WidgetEntry, WatchWidgetEntryView

### Community 138 - "Community 138"
Cohesion: 0.53
Nodes (4): FeedDB, ModelContext, NewsCategory, PodcastDB

### Community 139 - "Community 139"
Cohesion: 0.15
Nodes (13): Agents (`.claude/agents/`), Anti-hallucination contract (the most important section), Build Commands, CLAUDE.md — MacMagazine, Conventions, Definition of Done (all must hold before you say "done"), graphify, Guardrails (deterministic — see `.claude/settings.json` + `.claude/hooks/`) (+5 more)

### Community 141 - "Community 141"
Cohesion: 0.60
Nodes (4): FeedHighlightCardView, AnalyticsManager, FeedDB, Void

### Community 142 - "Community 142"
Cohesion: 0.83
Nodes (3): OnboardingSkipButton, String, Void

### Community 143 - "Community 143"
Cohesion: 0.83
Nodes (3): FeedDetailView, FeedDB, FeedMainViewModel

### Community 146 - "Community 146"
Cohesion: 0.28
Nodes (6): AVKit, Context, SystemVolumeView, MediaPlayer, MPVolumeView, UIViewRepresentable

### Community 147 - "Community 147"
Cohesion: 0.15
Nodes (12): Accessibility, Card system (MacMagazineUILibrary), CardContent — universal data model, CardContentType — content variants, CardStyle — layout variants, Category-to-style mapping (NewsCategory.style), NewsCard — smart dispatcher, Theme system (+4 more)

### Community 148 - "Community 148"
Cohesion: 0.33
Nodes (4): CGSize, CGFloat, UIColor, UIImage

### Community 149 - "Community 149"
Cohesion: 0.33
Nodes (5): View, ImageLocation, background, chapter, player

### Community 150 - "Community 150"
Cohesion: 0.15
Nodes (12): Enforcement Rules, FAIL Conditions — Start Over If You:, iOS Feature Implementation, Phase 1: Pre-Flight (NO CODE YET), Phase 2: Planning, Phase 3: Implementation (Step by Step), Phase 4: Definition of Done, SUCCESS Conditions (+4 more)

### Community 152 - "Community 152"
Cohesion: 0.21
Nodes (9): SettingsDB, Bool, ModelContext, String, UUID, Bool, Int, News (+1 more)

### Community 160 - "App do MacMagazine para iOS"
Cohesion: 0.15
Nodes (13): App do MacMagazine para iOS, Bug Reporting e Feature Requests, Começando, Como funciona, Como usar, Configuração rápida, Contribuindo, Desenvolvimento com IA (Claude Code) (+5 more)

### Community 161 - "Firebase Configuration"
Cohesion: 0.17
Nodes (8): CI/CD Setup (Bitrise), Firebase Configuration, How It Works, Option 1: Using Environment Variables (Recommended), Option 2: Using Secure File Storage, Overview, Security Notes, Setup for Local Development

### Community 162 - "iOS Design Guidelines for MacMagazine"
Cohesion: 0.17
Nodes (11): Accessibility, Card System, CardStyle Reference, Dark Mode, iOS Design Guidelines for MacMagazine, Standard Background Pattern, Theme System, Theme Tokens (+3 more)

### Community 163 - "MMWebView"
Cohesion: 0.29
Nodes (6): MMWebView, async, MainActor, String, Void, WebPage

### Community 164 - "Guia de Contribuição"
Cohesion: 0.17
Nodes (12): 1. Aguarde revisão, 2. Responda aos comentários, 3. Atualize seu PR, 4. Aprovação e merge, Dúvidas?, Executando testes, Guia de Contribuição, Processo de revisão (+4 more)

### Community 165 - "YOUR PRIME DIRECTIVES"
Cohesion: 0.18
Nodes (10): DIRECTIVE 1: READ BEFORE YOU WRITE — NO EXCEPTIONS, DIRECTIVE 2: FOLLOW CLAUDE.md AND `.claude/rules/` AS ABSOLUTE LAW, DIRECTIVE 3: ARCHITECTURE COMPLIANCE, DIRECTIVE 4: SOLID, DRY, AND CLEAN CODE, DIRECTIVE 5: SELF-VERIFICATION CHECKLIST, DIRECTIVE 6: WHEN IN DOUBT, READ MORE CODE, DIRECTIVE 7: PROACTIVE EXCELLENCE, HARD-LEARNED LESSONS (+2 more)

### Community 166 - "NewsCategory"
Cohesion: 0.33
Nodes (5): ShortcutActions, none, openLastSeenPost, openMostRecentPost, openSearchPost

### Community 167 - "Anti-hallucination & pattern-fidelity contract"
Cohesion: 0.22
Nodes (8): 1. Never invent APIs or symbols, 2. Mirror the project's patterns — don't freelance, 3. Cite where you act, 4. Never fabricate results, 5. Prefer "I don't know" over a plausible guess, 6. Stay in scope, 7. Self-check before declaring done, Anti-hallucination & pattern-fidelity contract

### Community 168 - "Skills Quick Reference"
Cohesion: 0.22
Nodes (8): Built-in Skills (Claude Code), Decision Tree, Project Agents (`.claude/agents/`), Project Skills (this folder), Reference, Skill Integration, Skills Quick Reference, Workflow

### Community 169 - "Criando um Pull Request"
Cohesion: 0.22
Nodes (9): 1. Push da sua branch, 2. Abra o Pull Request, 3. Título do PR (IMPORTANTE), 4. Preencha o template, 5. Verifique a base branch, Criando um Pull Request, Exemplos de títulos válidos, Regra especial para `fix` (+1 more)

### Community 170 - "Git workflow"
Cohesion: 0.25
Nodes (7): Auto-commit and push (project policy), Blocked regardless (PreToolUse hook + settings.json deny), Branches, Commits / PR titles, Git workflow, Never commit, The gate (before every commit)

### Community 171 - "Swift Style — naming, optionals, lint, comments"
Cohesion: 0.25
Nodes (7): API design, Comments — zero tolerance for obvious comments, Files & layout, Naming, Optionals & errors, Swift Style — naming, optionals, lint, comments, SwiftLint configuration highlights

### Community 172 - "Critical Requirements (Zero Tolerance)"
Cohesion: 0.25
Nodes (7): Build & Tests, Card System Compliance, Code Quality (SOLID + DRY), Critical Requirements (Zero Tolerance), Git Workflow, iOS Definition of Done Checklist, Self-Review Questions

### Community 173 - "PULL_REQUEST_TEMPLATE.md"
Cohesion: 0.25
Nodes (7): Additional Notes, Checklist, Description, Related Issue, Screenshots/Videos, Testing, Type of Change

### Community 174 - "WalletPassService"
Cohesion: 0.36
Nodes (5): Network, Sendable, WalletPassService, WalletPassServiceTests, PKPass

### Community 175 - "Testing — Swift Testing"
Cohesion: 0.29
Nodes (6): Definition of tested, Pattern, Rules, Testing — Swift Testing, What to test, Where tests live

### Community 176 - "Configuração do ambiente"
Cohesion: 0.29
Nodes (7): 1. Clone o repositório, 2. Configure o Firebase, 3. Abra o projeto no Xcode, 4. Resolva as dependências, 5. Selecione o scheme e dispositivo, 6. Build inicial, Configuração do ambiente

### Community 177 - "Concurrency — Swift 6.2, structured only"
Cohesion: 0.33
Nodes (5): Banned (the PostToolUse hook blocks these), Concurrency — Swift 6.2, structured only, Example shape, Legacy (migrate when touching, never write new), Required patterns

### Community 178 - "MinimumTouchTarget"
Cohesion: 0.26
Nodes (8): ButtonStyle, MinimumTouchTarget, MinimumTouchTargetButtonStyle, Bool, Color, Configuration, Content, View

### Community 179 - "View"
Cohesion: 0.27
Nodes (9): SceneDelegate, Set, UIScene, UISceneSession, NSUserActivity, UIOpenURLContext, UIResponder, UIWindow (+1 more)

### Community 180 - "Validações automáticas"
Cohesion: 0.33
Nodes (6): 1. Branch atualizada, 2. Título do PR, 3. SwiftLint, 4. Testes, Status das validações, Validações automáticas

### Community 181 - "Fluxo de trabalho"
Cohesion: 0.40
Nodes (5): 1. Mantenha seu fork atualizado, 2. Crie uma branch, 3. Desenvolva, 4. Teste localmente, Fluxo de trabalho

### Community 182 - "swift-code-reviewer.md"
Cohesion: 0.50
Nodes (3): Output, Read first, Review for

### Community 184 - "PodcastPlayerManager.swift"
Cohesion: 0.17
Nodes (6): AppTrackingTransparency, AVFoundation, Combine, Array, Self, Observation

### Community 186 - "Options"
Cohesion: 0.50
Nodes (4): Options, home, search, String

### Community 187 - "Padrões de código"
Cohesion: 0.50
Nodes (4): Arquitetura, Code Style, Padrões de código, SwiftLint

### Community 188 - "Troubleshooting"
Cohesion: 0.50
Nodes (4): App won't build locally, Firebase disabled locally, Firebase not working on Bitrise, Troubleshooting

### Community 191 - "ThemeColor.swift"
Cohesion: 0.12
Nodes (17): EnvironmentValues, String, Color, ThemeColor, OnboardingCTAButton, Bool, String, Void (+9 more)

### Community 192 - "NewsCategory"
Cohesion: 0.40
Nodes (5): ButtonAction, none, privacy, terms, String

### Community 193 - "AppearanceViewModel"
Cohesion: 0.50
Nodes (4): SubscriptionView, AnalyticsManager, Bool, String

### Community 194 - "MMNavigationDecider"
Cohesion: 0.33
Nodes (5): MMNavigationDecider, String, Void, WebPage, WKNavigationActionPolicy

### Community 195 - "Associated Domains (Universal Links)"
Cohesion: 0.33
Nodes (5): App side (already in the repo), Associated Domains (Universal Links), Hosting requirements, Scope, Verify after hosting

### Community 196 - "AppDefinitionsTests.swift"
Cohesion: 0.50
Nodes (4): Options, home, search, String

### Community 197 - "Options"
Cohesion: 0.50
Nodes (4): Options, home, search, String

### Community 202 - ".change"
Cohesion: 0.50
Nodes (3): Bool, Int, News

### Community 203 - "WidgetView"
Cohesion: 0.50
Nodes (4): AnalyticsManager, WidgetData, WidgetEntry, WidgetView

## Knowledge Gaps
- **478 isolated node(s):** `post-tool-use.sh script`, `stop.sh script`, `$schema`, `Read`, `Grep` (+473 more)
  These have ≤1 connection - possible missing edges or undocumented components.
- **29 thin communities (<3 nodes) omitted from report** — run `graphify query` to explore isolated nodes.

## Suggested Questions
_Questions this graph is uniquely positioned to answer:_

- **Why does `Foundation` connect `FeedLibrary Imports` to `Live Content & Notifications`, `Analytics Library`, `XML Feed Parsing`, `Podcast Full Player UI`, `Card Content & Menus`, `Community 145`, `Search System`, `Community 23`, `Community 24`, `Community 29`, `Community 36`, `NewsCategory`, `Community 43`, `Community 51`, `Community 52`, `Community 53`, `PodcastPlayerManager.swift`, `Community 58`, `Community 59`, `Community 61`, `ThemeColor.swift`, `Community 63`, `Community 64`, `Community 65`, `Community 68`, `NewsCategoryExtensions.swift`, `ArrayExtensions.swift`, `AppDefinitionsTests.swift`, `OnboardingCoordinatorTests.swift`, `Community 70`, `Community 78`, `Community 80`, `Community 85`, `Community 100`, `Community 109`, `Community 110`, `Community 120`?**
  _High betweenness centrality (0.184) - this node is a cross-community bridge._
- **Why does `SwiftUI` connect `Analytics Library` to `Community 128`, `Live Content & Notifications`, `Settings & Subscriptions`, `Community 132`, `WebView HTML & Disqus`, `FeedLibrary Imports`, `Community 140`, `Podcast Full Player UI`, `Card Content & Menus`, `Community 146`, `Search System`, `Community 24`, `Community 28`, `Community 36`, `Community 49`, `MinimumTouchTarget`, `Community 51`, `Community 53`, `.makeHTML`, `PodcastPlayerManager.swift`, `ThemeColor.swift`, `Community 67`, `Community 71`, `EnvironmentValuesExtensions.swift`, `Community 78`, `Community 81`, `Community 92`, `Community 94`, `Community 99`, `Community 101`, `Community 102`, `Community 105`, `Community 112`, `Community 117`, `Community 118`, `Community 119`, `Community 124`, `Community 125`?**
  _High betweenness centrality (0.147) - this node is a cross-community bridge._
- **Why does `MacMagazineLibrary` connect `Analytics Library` to `Community 68`, `Community 36`, `NewsCategoryExtensions.swift`, `ArrayExtensions.swift`, `AppDefinitionsTests.swift`, `FeedLibrary Imports`, `OnboardingCoordinatorTests.swift`, `Community 78`, `Community 80`, `Community 145`, `Community 53`, `Community 24`, `Community 89`, `PodcastPlayerManager.swift`?**
  _High betweenness centrality (0.077) - this node is a cross-community bridge._
- **Are the 74 inferred relationships involving `Database` (e.g. with `.deduplicateHandlesMultipleGroups()` and `.deduplicateKeepsMostRecentlyModified()`) actually correct?**
  _`Database` has 74 INFERRED edges - model-reasoned connections that need verification._
- **What connects `post-tool-use.sh script`, `stop.sh script`, `$schema` to the rest of the system?**
  _478 weakly-connected nodes found - possible documentation gaps or missing edges._
- **Should `Settings & Subscriptions` be split into smaller, more focused modules?**
  _Cohesion score 0.14461538461538462 - nodes in this community are weakly interconnected._
- **Should `Live Content & Notifications` be split into smaller, more focused modules?**
  _Cohesion score 0.05209274314965372 - nodes in this community are weakly interconnected._