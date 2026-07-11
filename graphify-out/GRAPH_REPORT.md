# Graph Report - .  (2026-07-11)

## Corpus Check
- 376 files · ~361,182 words
- Verdict: corpus is large enough that graph structure adds value.

## Summary
- 2457 nodes · 4835 edges · 160 communities (134 shown, 26 thin omitted)
- Extraction: 87% EXTRACTED · 13% INFERRED · 0% AMBIGUOUS · INFERRED: 607 edges (avg confidence: 0.8)
- Token cost: 0 input · 0 output

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

## God Nodes (most connected - your core abstractions)
1. `SwiftUI` - 114 edges
2. `Foundation` - 108 edges
3. `MacMagazineLibrary` - 93 edges
4. `Database` - 70 edges
5. `ButtonID` - 65 edges
6. `FeedLibrary` - 57 edges
7. `StorageLibrary` - 49 edges
8. `PodcastPlayerManager` - 46 edges
9. `FeedDB` - 45 edges
10. `AnalyticsLibrary` - 45 edges

## Surprising Connections (you probably didn't know these)
- `MacMagazineTimelineProvider` --calls--> `FeedViewModel`  [INFERRED]
  MacMagazine/Widget/Timeline/MacMagazineTimelineProvider.swift → MacMagazine/Features/FeedLibrary/Sources/FeedLibrary/ViewModel/FeedViewModel.swift
- `MainViewModel` --calls--> `SessionState`  [INFERRED]
  MacMagazine/MacMagazine/MainApp/MainViewModel.swift → MacMagazine/Features/MacMagazineLibrary/Sources/MacMagazineLibrary/SessionState.swift
- `MainViewModel` --calls--> `ThemeColor`  [INFERRED]
  MacMagazine/MacMagazine/MainApp/MainViewModel.swift → MacMagazine/Features/MacMagazineLibrary/Sources/MacMagazineLibrary/ThemeColor.swift
- `ContentPreview` --calls--> `CardContent`  [INFERRED]
  MacMagazine/Features/MacMagazineUILibrary/Sources/MacMagazineUILibrary/PreviewData/ContentPreview.swift → MacMagazine/Features/MacMagazineUILibrary/Sources/MacMagazineUILibrary/Cards/Model/CardContent.swift
- `DisqusSheet` --calls--> `DisqusNewWindowHandler`  [INFERRED]
  MacMagazine/Features/MacMagazineUILibrary/Sources/MacMagazineUILibrary/Webview/Disqus/DisqusWebView.swift → MacMagazine/Features/MacMagazineUILibrary/Sources/MacMagazineUILibrary/Webview/Disqus/DisqusNewWindowHandler.swift

## Import Cycles
- None detected.

## Communities (160 total, 26 thin omitted)

### Community 0 - "Settings & Subscriptions"
Cohesion: 0.05
Nodes (16): SettingsDB, Bool, ModelContext, String, UUID, Subscription, Bool, Database (+8 more)

### Community 1 - "Live Content & Notifications"
Cohesion: 0.05
Nodes (44): Date, Bool, String, MMLive, PushNotification, PushNotificationProtocol, Storage, MMLiveViewModel (+36 more)

### Community 2 - "Analytics Library"
Cohesion: 0.09
Nodes (8): AnalyticsLibrary, Constants, MacMagazineLibrary, MacMagazineUILibrary, StoreKit, SwiftUI, UIComponentsLibrary, UtilityLibrary

### Community 3 - "Analytics Event Constants"
Cohesion: 0.03
Nodes (64): ButtonID, appLaunched, categoryFilterChanged, cleanAllPosts, cleanOnboarding, cleanPosts, cleanPostsOptions, deepLinkOpened (+56 more)

### Community 4 - "XML Feed Parsing"
Cohesion: 0.06
Nodes (22): DateFormatter, APIXMLParser, Bool, CheckedContinuation, Error, Int, String, DateParser (+14 more)

### Community 5 - "WebView HTML & Disqus"
Cohesion: 0.05
Nodes (31): Int, Bool, Utils, DisqusHTMLBuilder, String, GalleryStateMessageHandler, Bool, Void (+23 more)

### Community 6 - ".claude Config & Hooks"
Cohesion: 0.04
Nodes (48): hooks, PostToolUse, PreToolUse, Stop, permissions, allow, ask, deny (+40 more)

### Community 7 - "News Feature"
Cohesion: 0.09
Nodes (22): Filter, NewsViewModel, APIStatus, Database, FeedDB, Int, NetworkMockData, Options (+14 more)

### Community 8 - "Feed Service"
Cohesion: 0.10
Nodes (17): FeedViewModel, Bool, CheckedContinuation, Data, Database, Error, FeedDB, Int (+9 more)

### Community 9 - "FeedLibrary Imports"
Cohesion: 0.10
Nodes (9): AVFoundation, Combine, FeedLibrary, Foundation, String, Array, Self, URLs (+1 more)

### Community 10 - "WebView Cookies"
Cohesion: 0.08
Nodes (7): Cookies, Bool, HTTPCookie, String, TimeInterval, CookiesTests, WKHTTPCookieStore

### Community 11 - "Podcast Feature"
Cohesion: 0.11
Nodes (20): PodcastViewModel, APIStatus, Database, Int, NetworkMockData, Options, PodcastView, AnalyticsManager (+12 more)

### Community 12 - "In-App Purchases"
Cohesion: 0.08
Nodes (27): Configuration, InAppManager, InAppProduct, InAppStatus, Status, error, idle, loading (+19 more)

### Community 13 - "FeedDB Model & Tests"
Cohesion: 0.09
Nodes (5): FeedDB, Bool, ModelContext, String, FeedDBTests

### Community 14 - "API Endpoints"
Cohesion: 0.09
Nodes (8): APIDefinitions, Endpoint, Self, MMLiveLibrary, NetworkLibrary, StorageLibrary, SwiftData, WatchKit

### Community 15 - "Podcast Full Player UI"
Cohesion: 0.09
Nodes (23): Data, FullPlayerView, PlayerAccessibilityPriority, PodcastBackgroundGradientStyle, fourTone, threeTone, twoTone, AnalyticsManager (+15 more)

### Community 16 - "PodcastDB Model & Tests"
Cohesion: 0.10
Nodes (6): PodcastDB, Bool, Double, ModelContext, String, PodcastDBTests

### Community 17 - "Card Content & Menus"
Cohesion: 0.11
Nodes (19): CardContent, AnalyticsManager, Bool, CGFloat, String, Void, MenuButton, MenuContent (+11 more)

### Community 18 - "Search ViewModel Tests"
Cohesion: 0.16
Nodes (10): makeResult(), MockLocalSearchService, MockMerger, MockRemoteSearchService, SearchViewModelTests, Error, Int, ModelContext (+2 more)

### Community 19 - "Podcast Chapter Colors"
Cohesion: 0.15
Nodes (5): Color, createChapter(), PodcastChapterTests, Double, String

### Community 20 - "Search System"
Cohesion: 0.12
Nodes (15): RecentSearchDB, String, LocalSearchServiceProtocol, RemoteSearchServiceProtocol, SearchViewModel, Bool, Database, Duration (+7 more)

### Community 21 - "Podcast Player Manager"
Cohesion: 0.17
Nodes (8): AVPlayer, AVPlayerItem, Float, PodcastPlayerManager, Any, Double, PodcastDB, TimeInterval

### Community 22 - "Community 22"
Cohesion: 0.17
Nodes (4): OnboardingCoordinator, Bool, Void, OnboardingCoordinatorTests

### Community 23 - "Community 23"
Cohesion: 0.09
Nodes (20): CaseIterable, NewsCategory, all, appletv, highlights, news, podcast, reviews (+12 more)

### Community 24 - "Community 24"
Cohesion: 0.10
Nodes (10): AppTrackingTransparency, FirebaseCore, InAppLibrary, LoggerLibrary, Observation, OneSignalExtension, OneSignalFramework, os (+2 more)

### Community 26 - "Community 26"
Cohesion: 0.13
Nodes (5): createChapter(), createTestChapters(), PodcastPlayerManagerTests, Double, String

### Community 27 - "Community 27"
Cohesion: 0.10
Nodes (16): SearchStatus, done, error, idle, localResults, searching, SearchView, AnalyticsManager (+8 more)

### Community 28 - "Community 28"
Cohesion: 0.10
Nodes (16): areEqual(), Equatable, Bool, AreEqualTests, Options, home, search, String (+8 more)

### Community 29 - "Community 29"
Cohesion: 0.17
Nodes (4): QueryProcessor, String, QueryProcessorTests, NaturalLanguage

### Community 30 - "Community 30"
Cohesion: 0.10
Nodes (21): Screen, deepLinkDetail, live, loginPatroes, news, onboardingFeatures, onboardingPermissions, onboardingWelcome (+13 more)

### Community 31 - "Community 31"
Cohesion: 0.16
Nodes (8): APIStatus, Database, ModelContext, NetworkMockData, Options, YouTubeAPI, VideosViewModel, VideosViewModelTests

### Community 32 - "Community 32"
Cohesion: 0.18
Nodes (11): CMTime, PodcastChapter, Data, Double, String, ChaptersView, AnalyticsManager, Binding (+3 more)

### Community 34 - "Community 34"
Cohesion: 0.14
Nodes (13): BridgeViewController, InteractivePopGestureBridge, Bool, Context, View, ImageLocation, background, chapter (+5 more)

### Community 35 - "Community 35"
Cohesion: 0.14
Nodes (11): AnalyticsManager, PushNotification, PermissionManager, AnalyticsManager, Bool, PushNotification, String, OnboardingSheetPreviewHost (+3 more)

### Community 36 - "Community 36"
Cohesion: 0.17
Nodes (10): OnboardingScreenTests, News, NewsCategory, NewsLibrary, OnboardingLibrary, PodcastLibrary, SearchLibrary, SettingsLibrary (+2 more)

### Community 37 - "Community 37"
Cohesion: 0.24
Nodes (5): RemoteFeedSearchServiceTests, FeedDB, PodcastDB, SearchResult, String

### Community 38 - "Community 38"
Cohesion: 0.20
Nodes (10): Text, SettingsView, NewsView, SocialView, MainView, CaseIterable, String, View (+2 more)

### Community 39 - "Community 39"
Cohesion: 0.18
Nodes (12): Context, Sendable, WidgetData, WidgetEntry, WatchWidgetProvider, MacMagazineTimelineProvider, Context, Void (+4 more)

### Community 40 - "Community 40"
Cohesion: 0.20
Nodes (8): SearchResultMerger, SearchResultMergerProtocol, SearchResult, String, SearchResultMergerTests, Bool, SearchResult, String

### Community 41 - "Community 41"
Cohesion: 0.11
Nodes (16): AppDelegate, Any, AnyHashable, Bool, Data, Error, LoggerProtocol, PushNotification (+8 more)

### Community 42 - "Community 42"
Cohesion: 0.12
Nodes (12): LinearGradient, CardDensity, CGFloat, Font, Int, GlassCardView, AnalyticsManager, CGFloat (+4 more)

### Community 43 - "Community 43"
Cohesion: 0.19
Nodes (4): Data, String, WidgetData, WidgetDataTests

### Community 44 - "Community 44"
Cohesion: 0.14
Nodes (13): Social, instagram, podcast, videos, SocialTests, CustomizationDB, Bool, ModelContext (+5 more)

### Community 45 - "Community 45"
Cohesion: 0.12
Nodes (13): EnvironmentValues, String, Color, ThemeColor, OnboardingContainerView, Bool, Bool, Namespace (+5 more)

### Community 46 - "Community 46"
Cohesion: 0.16
Nodes (13): Array, CardAccessibilityModifier, CardButton, favorite, share, CardLabel, author, date (+5 more)

### Community 47 - "Community 47"
Cohesion: 0.16
Nodes (13): Array, CardAccessibilityModifier, CardButton, favorite, share, CardLabel, date, duration (+5 more)

### Community 48 - "Community 48"
Cohesion: 0.12
Nodes (15): AboutViewModel, ButtonAction, none, privacy, terms, MailDelegate, Error, String (+7 more)

### Community 49 - "Community 49"
Cohesion: 0.22
Nodes (9): LeftIcon, SpeedWheelPicker, Binding, CGFloat, Double, Int, String, Wrapper (+1 more)

### Community 50 - "Community 50"
Cohesion: 0.19
Nodes (6): CardContentType, news, podcast, video, NewsCategory, CardContentTypeTests

### Community 51 - "Community 51"
Cohesion: 0.14
Nodes (15): ActivityAttributes, ActivityKit, Codable, News, all, appletv, highlights, news (+7 more)

### Community 52 - "Community 52"
Cohesion: 0.13
Nodes (11): PushNotification, PushPermissionStatus, authorized, denied, notDetermined, LoggerProtocol, String, OSNotificationClickEvent (+3 more)

### Community 53 - "Community 53"
Cohesion: 0.14
Nodes (7): WidgetAccessibility, Widget, WatchWidgetBundle, MacMagazineWidgetBundle, Widget, WidgetBundle, WidgetKit

### Community 55 - "Community 55"
Cohesion: 0.17
Nodes (11): CustomizationViewModel, Database, News, CustomSocialView, AnalyticsManager, IndexSet, Int, CustomTabView (+3 more)

### Community 56 - "Community 56"
Cohesion: 0.20
Nodes (10): SceneView, PushNotification, MainViewModel, Bool, Database, LoggerProtocol, News, PersistentModel (+2 more)

### Community 57 - "Community 57"
Cohesion: 0.14
Nodes (10): Any, AnyHashable, Data, FeedMainViewModel, String, UNNotificationResponse, UNUserNotificationCenter, WatchNotificationsDelegate (+2 more)

### Community 58 - "Community 58"
Cohesion: 0.16
Nodes (11): NetworkService, Data, Network, ContentType, news, podcast, video, SortPreference (+3 more)

### Community 59 - "Community 59"
Cohesion: 0.21
Nodes (8): RelevanceScorer, SearchResult, Double, SearchResult, String, RelevanceScorerTests, SearchResult, String

### Community 60 - "Community 60"
Cohesion: 0.24
Nodes (7): FeedMainViewModel, Bool, CGPoint, FeedDB, Int, ModelContext, String

### Community 61 - "Community 61"
Cohesion: 0.19
Nodes (10): CGSize, BackgroundView, Bool, Color, PodcastImageView, Content, Data, FeedRowView (+2 more)

### Community 62 - "Community 62"
Cohesion: 0.27
Nodes (10): Edge, ManagedWebView, ManagedWebViewStyle, async, Binding, Bool, MainActor, UUID (+2 more)

### Community 63 - "Community 63"
Cohesion: 0.19
Nodes (8): DisqusDataStore, DisqusLoginWebView, DisqusSheet, MainActor, String, Void, WebPage, WKWebsiteDataStore

### Community 64 - "Community 64"
Cohesion: 0.21
Nodes (8): Cache, cleanAll, keepFavoritesAndStatus, PostsVisibilityViewModel, Database, PersistentModel, PostsVisibilityView, AnalyticsManager

### Community 65 - "Community 65"
Cohesion: 0.21
Nodes (8): FeedDB, String, AccessibilityChildBehavior, String, View, String, URL, WidgetData

### Community 66 - "Community 66"
Cohesion: 0.26
Nodes (10): CardButton, CardLabel, AdaptiveBody, AdaptiveVideoCard, MMVideoDBPreview, AnalyticsManager, ModelContext, VideoDB (+2 more)

### Community 67 - "Community 67"
Cohesion: 0.21
Nodes (9): Identifiable, OnBoardingFeature, String, FeaturesView, Bool, CGFloat, GridItem, Int (+1 more)

### Community 68 - "Community 68"
Cohesion: 0.18
Nodes (10): CardStyle, glass, highlight, leadingImage, NewsCategory, FeedDB, AnalyticsManager, CGFloat (+2 more)

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
Cohesion: 0.29
Nodes (5): FeedMainView, FeedDB, FeedMainViewModel, String, Void

### Community 73 - "Community 73"
Cohesion: 0.44
Nodes (9): Encodable, Int, String, UserIdentity, UserModel, UserProperties, UserSubscriptions, UserSubscriptionsType (+1 more)

### Community 74 - "Community 74"
Cohesion: 0.33
Nodes (10): Header, CollectionViewWithHeader, APIStatus, Binding, Bool, Content, Int, ScrollPosition (+2 more)

### Community 77 - "Community 77"
Cohesion: 0.18
Nodes (8): AppTabs, live, news, search, settings, social, AppTabsTests, Bool

### Community 78 - "Community 78"
Cohesion: 0.18
Nodes (4): String, MMWebViewUserScripts, WebKit, WKUserScript

### Community 80 - "Community 80"
Cohesion: 0.40
Nodes (7): QueryIntent, NewsCategory, Set, String, LocalSearchService, ModelContext, SearchResult

### Community 81 - "Community 81"
Cohesion: 0.31
Nodes (8): Content, Options, ToolbarModifier, ToolbarType, compact, normal, View, Menu

### Community 82 - "Community 82"
Cohesion: 0.22
Nodes (8): ShortcutManager, ModelContext, String, UIApplicationShortcutItem, Bool, UIApplicationShortcutItem, Void, UIWindowScene

### Community 83 - "Community 83"
Cohesion: 0.18
Nodes (11): String, WidgetConfiguration, WatchWidget, MacMagazineWidget, String, WidgetConfiguration, MacMagazineWidgetLiveActivity, WidgetConfiguration (+3 more)

### Community 84 - "Community 84"
Cohesion: 0.33
Nodes (6): HeaderWidgetModifier, OverlayHeaderWidgetModifier, CGFloat, Content, String, View

### Community 85 - "Community 85"
Cohesion: 0.20
Nodes (9): String, URLClassification, appStore, comments, external, instagram, macmagazinePost, youTube (+1 more)

### Community 88 - "Community 88"
Cohesion: 0.27
Nodes (9): FeedHighlightsCarouselView, Layout, Binding, Bool, CGFloat, FeedDB, Int, ScrollPosition (+1 more)

### Community 89 - "Community 89"
Cohesion: 0.33
Nodes (5): PortugueseLexicon, Bool, NewsCategory, Set, String

### Community 90 - "Community 90"
Cohesion: 0.20
Nodes (9): CGFloat, Image, WidgetData, WidgetElementView, AnalyticsManager, Int, WidgetData, WidgetEntry (+1 more)

### Community 91 - "Community 91"
Cohesion: 0.28
Nodes (6): AVKit, Context, SystemVolumeView, MediaPlayer, MPVolumeView, UIViewRepresentable

### Community 92 - "Community 92"
Cohesion: 0.25
Nodes (6): Gesture, MiniPlayerView, AnalyticsManager, Color, PodcastDB, String

### Community 93 - "Community 93"
Cohesion: 0.31
Nodes (6): NetworkService, Data, Int, Network, NewsCategory, String

### Community 94 - "Community 94"
Cohesion: 0.33
Nodes (7): PermissionCard, PermissionCardStatus, denied, granted, notDetermined, String, Void

### Community 95 - "Community 95"
Cohesion: 0.39
Nodes (3): CGFloat, UIColor, UIImage

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
Cohesion: 0.32
Nodes (4): PodcastMiniPlayerModifier, Content, View, ViewModifier

### Community 104 - "Community 104"
Cohesion: 0.32
Nodes (5): RemoteFeedSearchService, Database, Int, SearchResult, String

### Community 105 - "Community 105"
Cohesion: 0.36
Nodes (5): PlainButtonTextStyle, Color, Content, Font, View

### Community 106 - "Community 106"
Cohesion: 0.32
Nodes (7): AnalyticsManager, Binding, Bool, Database, ScrollPosition, String, VideosView

### Community 107 - "Community 107"
Cohesion: 0.32
Nodes (6): SceneDelegate, UIScene, UISceneSession, UIResponder, UIWindow, UIWindowSceneDelegate

### Community 108 - "Community 108"
Cohesion: 0.33
Nodes (5): Glass, MenuView, Binding, Bool, T

### Community 109 - "Community 109"
Cohesion: 0.29
Nodes (5): APIDefinitions, Endpoint, Int, Self, String

### Community 110 - "Community 110"
Cohesion: 0.29
Nodes (6): AnalyticsConstants, GenericEvent, newsOrder, socialOrder, tabOrder, String

### Community 111 - "Community 111"
Cohesion: 0.33
Nodes (5): MMNavigationDecider, String, Void, WebPage, WKNavigationActionPolicy

### Community 112 - "Community 112"
Cohesion: 0.29
Nodes (5): OnboardingFadeModifier, Bool, Content, Double, View

### Community 113 - "Community 113"
Cohesion: 0.38
Nodes (5): PodcastDB, AnalyticsManager, Double, ModelContext, String

### Community 114 - "Community 114"
Cohesion: 0.43
Nodes (6): ContentSheet, PatronLoginSheet, AnalyticsManager, String, Void, WebPage

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
Cohesion: 0.53
Nodes (4): PushNotificationDefinition, Any, Bool, UIApplication

### Community 123 - "Community 123"
Cohesion: 0.33
Nodes (5): UNNotificationResponse, UNUserNotificationCenter, Void, UNNotification, UNNotificationPresentationOptions

### Community 124 - "Community 124"
Cohesion: 0.47
Nodes (3): ButtonWithGlassEffect, Content, View

### Community 125 - "Community 125"
Cohesion: 0.40
Nodes (3): OnboardingLogoView, CGFloat, CGFloat

### Community 126 - "Community 126"
Cohesion: 0.33
Nodes (5): ShortcutActions, none, openLastSeenPost, openMostRecentPost, openSearchPost

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
Cohesion: 0.70
Nodes (4): FavoriteButton, Bool, String, Void

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
Cohesion: 0.70
Nodes (4): OnboardingCTAButton, Bool, String, Void

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
Cohesion: 0.50
Nodes (3): FeedDB, ModelContext, PodcastDB

### Community 141 - "Community 141"
Cohesion: 0.67
Nodes (3): FeedHighlightCardView, AnalyticsManager, FeedDB

### Community 142 - "Community 142"
Cohesion: 0.83
Nodes (3): OnboardingSkipButton, String, Void

### Community 143 - "Community 143"
Cohesion: 0.83
Nodes (3): FeedDetailView, FeedDB, FeedMainViewModel

## Knowledge Gaps
- **265 isolated node(s):** `post-tool-use.sh script`, `stop.sh script`, `$schema`, `Read`, `Grep` (+260 more)
  These have ≤1 connection - possible missing edges or undocumented components.
- **26 thin communities (<3 nodes) omitted from report** — run `graphify query` to explore isolated nodes.

## Suggested Questions
_Questions this graph is uniquely positioned to answer:_

- **Why does `Foundation` connect `FeedLibrary Imports` to `Settings & Subscriptions`, `Live Content & Notifications`, `Analytics Library`, `XML Feed Parsing`, `WebView HTML & Disqus`, `Community 139`, `API Endpoints`, `Community 145`, `Card Content & Menus`, `Search ViewModel Tests`, `Community 148`, `Search System`, `Community 23`, `Community 24`, `Community 152`, `Community 28`, `Community 29`, `Community 36`, `Community 40`, `Community 43`, `Community 45`, `Community 53`, `Community 58`, `Community 59`, `Community 63`, `Community 64`, `Community 65`, `Community 68`, `Community 70`, `Community 73`, `Community 78`, `Community 85`, `Community 100`, `Community 109`, `Community 110`, `Community 120`, `Community 126`?**
  _High betweenness centrality (0.278) - this node is a cross-community bridge._
- **Why does `SwiftUI` connect `Analytics Library` to `Community 128`, `Live Content & Notifications`, `Settings & Subscriptions`, `Community 132`, `WebView HTML & Disqus`, `FeedLibrary Imports`, `Community 140`, `API Endpoints`, `Card Content & Menus`, `Community 146`, `Search System`, `Community 149`, `Community 24`, `Community 36`, `Community 45`, `Community 46`, `Community 47`, `Community 49`, `Community 51`, `Community 53`, `Community 67`, `Community 71`, `Community 78`, `Community 81`, `Community 84`, `Community 91`, `Community 94`, `Community 99`, `Community 101`, `Community 102`, `Community 105`, `Community 112`, `Community 117`, `Community 118`, `Community 119`, `Community 124`, `Community 125`?**
  _High betweenness centrality (0.157) - this node is a cross-community bridge._
- **Why does `MacMagazineLibrary` connect `Analytics Library` to `Community 68`, `Community 36`, `FeedLibrary Imports`, `API Endpoints`, `Community 78`, `Community 145`, `Community 148`, `Community 53`, `Community 24`, `Community 89`, `Community 58`, `Community 152`?**
  _High betweenness centrality (0.120) - this node is a cross-community bridge._
- **Are the 68 inferred relationships involving `Database` (e.g. with `.deduplicateHandlesMultipleGroups()` and `.deduplicateKeepsMostRecentlyModified()`) actually correct?**
  _`Database` has 68 INFERRED edges - model-reasoned connections that need verification._
- **What connects `post-tool-use.sh script`, `stop.sh script`, `$schema` to the rest of the system?**
  _265 weakly-connected nodes found - possible documentation gaps or missing edges._
- **Should `Settings & Subscriptions` be split into smaller, more focused modules?**
  _Cohesion score 0.050617283950617285 - nodes in this community are weakly interconnected._
- **Should `Live Content & Notifications` be split into smaller, more focused modules?**
  _Cohesion score 0.05411392405063291 - nodes in this community are weakly interconnected._