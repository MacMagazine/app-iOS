# Architecture — modular SPM, MVVM, environment injection

## Modular SPM structure

Local Swift packages under `MacMagazine/Features/`. Each feature is isolated with explicit dependencies.

```
MacMagazine (main app)
├── MacMagazineLibrary          # Core domain: models, enums, protocols, theme (0 deps)
├── MacMagazineUILibrary        # Shared UI: cards, WebViews, PaginatedForEach
├── FeedLibrary                 # WordPress feed parsing, SwiftData models (FeedDB, PodcastDB)
├── NewsLibrary                 # News feature UI + ViewModel
├── PodcastLibrary              # Podcast playback, player manager, cards
├── VideosLibrary               # YouTube videos integration
├── SearchLibrary               # NLP-powered search with progressive loading
├── MMLiveLibrary               # Live content streaming
├── OnboardingLibrary           # First-time user flow
└── SettingsLibrary             # Settings, preferences, subscriptions
```

## Dependency rules (enforced by review + the architecture-guardian agent)

- Dependencies flow downward only: App → Feature libraries → MacMagazineUILibrary/FeedLibrary → MacMagazineLibrary → external Libraries package.
- **Feature libraries never import each other.** Documented exception: `SearchLibrary → PodcastLibrary` (for podcast card views).
- `MacMagazineLibrary` has zero dependencies. `MacMagazineUILibrary` depends on MacMagazineLibrary only. `FeedLibrary` depends on MacMagazineLibrary, Network, Storage.
- If a type is needed in two features, it belongs in `MacMagazineLibrary` (domain) or `MacMagazineUILibrary` (UI) — never copied.

## Build targets

| Target | Type | Notes |
|--------|------|-------|
| **MacMagazine** | iOS App | All feature libraries |
| **WatchApp** | watchOS App | FeedLibrary subset |
| **Widget** | iOS Widget Extension | FeedLibrary, timeline provider |
| **WatchWidget** | watchOS Widget Extension | FeedLibrary |

## Adding a new module

1. Create `Package.swift` under `MacMagazine/Features/` with `.iOS(.v26)` platform
2. Depend only on what you need — prefer `MacMagazineLibrary` + `MacMagazineUILibrary` as the minimal set
3. Never create circular dependencies between feature modules
4. Register in Xcode project target dependencies
5. Update the dependency map above

## Navigation & state

- `MacMagazineApp` — `@main` entry, injects all environment dependencies
- `MainViewModel` — Root orchestrator: tabs, deep linking, storage, analytics
- `MainView` — Adaptive layout: `TabView` (iPhone) / `NavigationSplitView` (iPad sidebar)

### Environment injection (MacMagazineApp)

```swift
.environment(viewModel)                              // MainViewModel
.environment(viewModel.settingsViewModel)            // SettingsViewModel
.environment(viewModel.searchViewModel)              // SearchViewModel
.environment(podcastPlayerManager)                   // PodcastPlayerManager
.environment(\.theme, viewModel.theme)               // ThemeColor
.environment(\.removeAds, ...)                       // Bool
.environmentObject(viewModel.sessionState)           // SessionState
.environmentObject(viewModel.analytics)              // AnalyticsManager
.modelContainer(viewModel.storage.sharedModelContainer)
```

### Custom environment values

| Key | Type | Purpose |
|-----|------|---------|
| `\.theme` | `ThemeColor` | App-wide color tokens |
| `\.removeAds` | `Bool` | Ad removal flag |
| `\.shouldUseSidebar` | `Bool` | iPad sidebar vs tabbar |
| `\.iPad` | `Bool` | iPad detection |

### Tab system

```swift
enum AppTabs { case live, news, social, settings, search }
enum News { case all, news, highlights, appletv, reviews, rumors, tutoriais }
enum Social { case videos, podcast, instagram }
```

### Deep linking

`MacMagazineApp.onOpenURL` sets `viewModel.deepLinkPostURL` which presents a `fullScreenCover` with article detail.

## MVVM roles

- **ViewModels** use `@Observable` (not `ObservableObject`, not Combine `@Published`). `@MainActor` for UI-facing state.
- **Views** are dumb: render state, forward intents. Access SwiftData via `@Environment(\.modelContext)` and `@Query`.
- Cross-cutting concerns flow through `@Environment`/`@EnvironmentObject` from `MacMagazineApp` — study the injection chain before adding a new dependency.

## SOLID & DRY in this codebase

- **S** — single-responsibility ViewModels; extract a service when one grows.
- **O** — extend via protocols and configuration, not modification.
- **D** — depend on abstractions; ViewModels take protocol dependencies, injected via `@Environment` or `init`.
- **DRY** — search before creating. Shared logic goes to `MacMagazineLibrary`; shared UI goes to `MacMagazineUILibrary`. But don't over-abstract: the third occurrence is the signal to extract, not the first.
- **Value types first** — prefer `struct`/`enum`; `class`/`actor` only for reference semantics or isolation.
- Patterns in use: MVVM (Views + ViewModels), Coordinator (onboarding), Repository (Network/Storage), Observer (`@Observable`).

## When the pattern doesn't fit

If the task genuinely needs a pattern the codebase doesn't have, stop and propose it (`AskUserQuestion`) with options and trade-offs. Do not silently invent architecture.
