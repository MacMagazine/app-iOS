# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

MacMagazine is a Brazilian Apple news aggregator — iOS, watchOS, widgets — delivering news, podcasts, and YouTube videos. Built with **Swift 6.2**, **SwiftUI**, **SwiftData**, and a **feature-based modular architecture** via local Swift packages.

- **Minimum targets:** iOS 26+, watchOS 26+
- **No availability guards** — all 2026+ APIs are available unconditionally

## Agents & Skills Reference

### Agent

| Agent | When to Use |
|-------|-------------|
| `ios-principal-engineer` | ANY code task: features, bug fixes, reviews, refactoring, architecture |

### Project Skills (`.claude/skills/`)

| Skill | When to Use |
|-------|-------------|
| `ios-start` | Pre-flight checklist before writing code |
| `ios-implement` | Complete feature implementation with pattern matching |
| `ios-fix` | Bug fixes, refactoring, root cause analysis |
| `ios-dod` | Definition of Done before marking task complete |
| `ios-design-guidelines` | Theme system, card system, typography, accessibility |
| `ios-sanity-check` | Codebase health audit (read-only) |

### Built-in Skills

| Skill | When to Use |
|-------|-------------|
| `ios-software-engineer` | Hands-on Swift/SwiftUI implementation, features, tests, PRs |
| `architecture-recipes` | Architectural decisions and module design |
| `swift-testing` | Swift Testing patterns and test structure |
| `code-review-checklist` | Pre-commit code review |
| `swiftui-patterns` | Advanced SwiftUI patterns |
| `simplify` | Review changed code for reuse, quality, efficiency |

Use skills for quick reference. CLAUDE.md defines authoritative architecture and project-wide rules.

---

## Build Commands

**CRITICAL**: Always use `-skipPackagePluginValidation -skipMacroValidation` and target **iPhone 17 Pro simulator**.

```bash
# Build
xcodebuild build \
  -project MacMagazine/MacMagazine.xcodeproj \
  -scheme MacMagazine \
  -destination "platform=iOS Simulator,name=iPhone 17 Pro" \
  -skipPackagePluginValidation \
  -skipMacroValidation

# Tests
xcodebuild test \
  -project MacMagazine/MacMagazine.xcodeproj \
  -scheme MacMagazine \
  -testPlan MacMagazine \
  -destination "platform=iOS Simulator,name=iPhone 17 Pro" \
  -skipPackagePluginValidation \
  -skipMacroValidation

# Lint (must pass before every commit)
swiftlint lint --config ./.swiftlint.yml --strict

# Setup
./Support/Scripts/setup-firebase.sh
```

### Utility scripts (`Support/Scripts/`)
- `generate-firebase-config.sh` — generate Firebase config
- `clean-build-folders.sh` — clean build artifacts
- `updateBuildVersion.sh` — update version numbers

---

## Default Behaviors (Always Active)

These apply to **all work** without exception. Violations are bugs.

### 1. Read the Codebase Before Writing Any Code

Every implementation starts with reading existing code in the affected area. Before touching a file:
- Read at least 5 related files (similar feature, parent ViewModel, relevant service)
- Match naming conventions, parameter patterns, and data types exactly
- Reuse existing helpers — never invent alternatives that already exist

### 2. Quality Gates — Run Before Every Commit

Run **build + test + lint** (see Build Commands). All three must pass. Fix failures before committing.

### 3. Comments — Zero Tolerance for Obvious Comments

Before every commit, review ALL changed code. Remove any comment that:
- Explains what the code does (the name already says it)
- Restates the type, structure, or parameter
- Adds docstrings to simple/obvious methods

Keep only: `// MARK: -`, `///` DocC on public API, complex algorithms, non-obvious business rules with a "why", `// TODO:`.

### 4. Swift Testing — All New Tests

Use Swift Testing, not XCTest, for all new unit tests:
```swift
import Testing

@Suite("Feature Tests")
@MainActor
struct FeatureTests {
    @Test("Describes expected behavior")
    func testBehavior() throws {
        #expect(result == expected)
    }
}
```

### 5. Commit and Push When Done — Automatically

After implementation is complete and all quality gates pass, **automatically** commit and push without waiting to be asked:
```bash
git add <specific changed files>
git commit -m "feat(scope): brief description

Co-Authored-By: Claude Opus 4.6 <noreply@anthropic.com>"
git push -u origin <branch>
```

---

## Architecture

### Modular SPM Structure

Local Swift packages under `MacMagazine/Features/`. Each feature is isolated with explicit dependencies.

```
MacMagazine (main app)
├── MacMagazineLibrary          # Core domain: models, enums, protocols, theme
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

### Dependency Graph

```
                 ┌──────────────────────────────────────────┐
                 │           External Libraries              │
                 │ Analytics  Logger  Network  Storage       │
                 │ UIComponents  InApp  YouTube  Utilities   │
                 └────────────────────┬─────────────────────┘
                                      │
          ┌───────────────────────────┼──────────────────────┐
          │                           │                      │
          ▼                           ▼                      ▼
   ┌──────────────┐        ┌──────────────────┐    ┌──────────────┐
   │ MacMagazine  │        │ MacMagazineUI    │    │  OneSignal   │
   │   Library    │◄───────│    Library       │    │  (Push)      │
   │  (0 deps)    │        │ Cards, WebViews  │    └──────────────┘
   └──────┬───────┘        └────────┬─────────┘
          │                         │
          ▼                         ▼
   ┌──────────────┐        ┌──────────────────────────────────────┐
   │ FeedLibrary  │        │         Feature Libraries             │
   │ (iOS+watch)  │◄───────│                                       │
   │ FeedDB       │        │  NewsLibrary ── PodcastLibrary        │
   │ PodcastDB    │        │  VideosLibrary ── SearchLibrary       │
   │ XMLParser    │        │  MMLiveLibrary ── OnboardingLibrary   │
   └──────────────┘        │  SettingsLibrary                      │
                           └──────────────────────────────────────┘
```

### Build Targets

| Target | Type | Notes |
|--------|------|-------|
| **MacMagazine** | iOS App | All feature libraries |
| **WatchApp** | watchOS App | FeedLibrary subset |
| **Widget** | iOS Widget Extension | FeedLibrary, timeline provider |
| **WatchWidget** | watchOS Widget Extension | FeedLibrary |

### Adding a New Module

1. Create `Package.swift` under `MacMagazine/Features/` with `.iOS(.v26)` platform
2. Depend only on what you need — prefer `MacMagazineLibrary` + `MacMagazineUILibrary` as the minimal set
3. Never create circular dependencies between feature modules
4. Register in Xcode project target dependencies
5. Add to the dependency graph above

---

## Data Layer

### SwiftData Models

All models use `DB` suffix. Registered in `MainViewModel.init()`:

| Model | Package | Purpose |
|-------|---------|---------|
| `FeedDB` | FeedLibrary | News articles (postId, title, pubDate, categories, favorite) |
| `PodcastDB` | FeedLibrary | Podcast episodes (podcastURL, duration, current playback position) |
| `VideoDB` | Libraries/YouTube | YouTube videos (videoId, views, likes, duration) |
| `SettingsDB` | SettingsLibrary | User preferences, subscription state |
| `CustomizationDB` | SettingsLibrary | Tab/feature customization |
| `RecentSearchDB` | SearchLibrary | Recent search queries (max 20) |

**Model Protocols:**
- `ModelFavoritable` — delete non-favorites cleanup
- `ModelDuplicable` — iCloud deduplication on sync

### Data Sources

- **WordPress RSS/XML** — News articles, podcasts (via `FeedLibrary/XMLParser`)
- **YouTube API** — Videos (via `Libraries/YouTube`)
- **SwiftData** — Local persistence with iCloud sync
- **Storage** — Key-value persistent storage

---

## Navigation & State

### Root Architecture

- `MacMagazineApp` — `@main` entry, injects all environment dependencies
- `MainViewModel` — Root orchestrator: tabs, deep linking, storage, analytics
- `MainView` — Adaptive layout: `TabView` (iPhone) / `NavigationSplitView` (iPad sidebar)

### Environment Injection (MacMagazineApp)

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

### Custom Environment Values

| Key | Type | Purpose |
|-----|------|---------|
| `\.theme` | `ThemeColor` | App-wide color tokens |
| `\.removeAds` | `Bool` | Ad removal flag |
| `\.shouldUseSidebar` | `Bool` | iPad sidebar vs tabbar |
| `\.iPad` | `Bool` | iPad detection |

### Tab System

```swift
enum AppTabs { case live, news, social, settings, search }
enum News { case all, news, highlights, appletv, reviews, rumors, tutoriais }
enum Social { case videos, podcast, instagram }
```

### Deep Linking

`MacMagazineApp.onOpenURL` sets `viewModel.deepLinkPostURL` which presents a `fullScreenCover` with article detail.

---

## Card System (MacMagazineUILibrary)

The card system provides unified content rendering across the app.

### CardContent — Universal Data Model

```swift
struct CardContent {
    let type: CardContentType    // .news, .podcast, .video
    let title, artworkUrl, urlToShare: String
    let pubDate: Date
    let author: String?
    let favorite: Bool
    let aspectRatio: CGFloat?    // default 16/9
    let favoriteAction: () -> Void
}
```

### CardContentType — Content Variants

| Type | Extra Data | Default Style |
|------|------------|---------------|
| `.news(categories, style)` | `[NewsCategory]`, `CardStyle?` | Category-driven |
| `.podcast(duration)` | Duration string | `.glass` |
| `.video(views, likes, duration)` | Stats strings | `.glass` |

### CardStyle — Layout Variants

| Style | View | Used By |
|-------|------|---------|
| `.leadingImage` | `LeadingImageCard` | Default news |
| `.topImage` | `TopImageCard` | Accessibility fallback |
| `.bottomImage` | `BottomImageCard` | Alternate layout |
| `.highlight` / `.glass` | `GlassCardView` | Highlights, podcasts, videos |
| `.simple` | `SimpleCard` | Text-only fallback |

### NewsCard — Smart Dispatcher

`NewsCard` selects the layout automatically:
1. Checks `dynamicTypeSize.usesPrimaryCardLayout` (accessibility)
2. Resolves `categories.mostRelevant.style` (category priority: highlights > appletv > reviews > rumors > tutorials > news)
3. Falls back to `data.type.style`, then `SimpleCard`

### Category-to-Style Mapping (NewsCategory.style)

| Category | Style |
|----------|-------|
| `.highlights` | `.highlight` |
| `.podcast`, `.youtube` | `.glass` |
| All others | `.leadingImage` |

---

## WebView System (MacMagazineUILibrary/Webview/)

### Architecture

```
MMWebView (public entry point)
  └── ManagedWebView (lifecycle manager)
        └── WebView (SwiftUI, iOS 26)
              └── WebPage (WKWebView wrapper)
```

### Key Components

| Type | Purpose |
|------|---------|
| `MMWebView` | Public view: URL loading, caching, cookies, user scripts |
| `ManagedWebView` | Lifecycle: loading states, error handling, scene phase |
| `WebPageCache` | In-memory page cache by key |
| `MMNavigationDecider` | Routes URLs: internal links, comments, external |
| `MMWebViewUserScripts` | JS injection: padding, zoom, gallery disable |
| `DisqusWebView` | Comments sheet with separate data store + login flow |
| `Cookies` | Cookie factory: dark mode, ad removal, Disqus session |

### User Scripts

| Script | Timing | Purpose |
|--------|--------|---------|
| `topPadding` | documentEnd | 50px top padding |
| `tapToZoom` | documentEnd | Image tap-to-zoom handler |
| `disableGallery` | documentEnd | Disable FancyBox gallery |
| `disableNewGallery` | documentEnd | Disable pk-image-popup gallery |
| `removeBackToBlog` | documentEnd | Remove back-to-blog link |
| `hideSiteHeader` | documentEnd | Hide site header (public) |
| `interceptNewWindows` | documentStart | Intercept `target="_blank"` links |

---

## Search System (SearchLibrary)

### Two-Phase Search

1. **Local (instant)** — SwiftData queries against `FeedDB`, `PodcastDB`, `VideoDB`
2. **Remote (async)** — WordPress API via `FeedViewModel.searchAll()` returns mixed results

### NLP Pipeline (Apple NaturalLanguage framework)

```
User query → Tokenizer (Portuguese) → Lemmatizer → Entity Extraction
           → QueryIntent (normalizedTerms, entities, categories, contentTypes)
```

### Key Types

| Type | Purpose |
|------|---------|
| `SearchViewModel` | Orchestrator: debounce, phases, recent searches |
| `QueryProcessor` | NLP: tokenize, lemmatize, entity extraction |
| `QueryIntent` | Parsed intent: terms, categories, content types |
| `LocalSearchService` | SwiftData queries across all content types |
| `RemoteFeedSearchService` | WordPress API, classifies results by category |
| `SearchResultMerger` | Deduplication + merge, always sorts by pubDate |
| `RelevanceScorer` | Title/excerpt/category/recency scoring |
| `PortugueseLexicon` | Portuguese keyword mappings, stop words |

### Result Classification (Remote)

WordPress search returns mixed posts. Classification:
- `podcastURL` non-empty → `.podcast` (with full `PodcastDB` data)
- Category contains `NewsCategoryMMTV` → `.video`
- Otherwise → `.news`

---

## Podcast System (PodcastLibrary)

### PodcastPlayerManager (`@MainActor @Observable`)

Global audio playback state injected via `@Environment`. Manages:
- AVPlayer lifecycle, audio session, remote transport controls
- Chapter parsing from audio metadata
- Play position tracking (`currentTime`, `duration`)
- Mini player ↔ full player transitions

### Card Views

| View | Layout | When |
|------|--------|------|
| `AdaptivePodcastCardView` | Smart dispatcher | Always used |
| `GlassPodcastCardView` | Glass overlay + play button | Primary (normal text) |
| `PodcastCardView` | Image top + metadata below | Accessibility (large text) |

### Mini Player

`PodcastMiniPlayerModifier` applies at the tab level:
- iPhone: `tabViewBottomAccessory` mini player
- iPad: `safeAreaInset` floating player
- Full player sheet available from all contexts (search, news, podcasts)

---

## Theme System

### ThemeColor

```swift
@Environment(\.theme) private var theme: ThemeColor
```

| Token | Access | Example Colors |
|-------|--------|----------------|
| `theme.main.background` | Primary background | MMGrey6 |
| `theme.main.navigation` | Nav bar | MMBlack90 |
| `theme.main.tint` | Tint color | MMBlueWhite |
| `theme.secondary.background` | Secondary bg | MMWhiteBlack |
| `theme.tertiary.background` | Tertiary bg | MMDarkGreyWhite |
| `theme.text.primary` | Primary text | MMBlueWhite |
| `theme.text.secondary` | Secondary text | MMWhiteGrey6 |
| `theme.button.primary` | Primary button | MMBlue |
| `theme.button.destructive` | Destructive | TabascoDracula |

Colors resolve via `String.color` → `Color(name, bundle: .module)`, supporting dark/light mode automatically.

---

## Conventions

### Branch Naming

- `feature/<description>`, `fix/<description>`, `hotfix/<description>`, `docs/<description>`, `refactor/<description>`
- Branch off `develop`; releases land on `release/v5`

### Commit / PR Titles

Conventional Commits format enforced by CI:
```
feat(scope): description
fix(#123): description    <- bug fixes MUST include issue number
```
Types: `feat`, `fix`, `docs`, `style`, `refactor`, `perf`, `test`, `chore`, `build`, `ci`, `revert`

### Code Style & Quality

- **Swift 6.2 + SwiftUI** (2026 idioms): `@Observable`, `@Environment`, structured concurrency (`async/await`, `TaskGroup`, `Actor`), `SwiftData`, latest SwiftUI APIs
- **No availability guards** — iOS 26+ minimum, all APIs available unconditionally
- **SwiftLint strict mode** — `.swiftlint.yml`; zero violations required
- **Ray Wenderlich Swift Style Guide**

### SwiftLint Configuration

| Rule | Severity | Note |
|------|----------|------|
| `force_cast`, `force_try`, `force_unwrapping` | Warning | Avoid; prefer safe alternatives |
| `sorted_imports` | Error | Imports must be alphabetical |
| `line_length` | Warning at 200 | Keep lines readable |
| `prefer_let_before_case` | Error | `case let .foo(x)` not `case .foo(let x)` |
| `todo` | Warning | Use sparingly |

### Design Principles

- **SOLID**: Single-responsibility ViewModels, open/closed protocols, dependency inversion via `@Environment`/`@EnvironmentObject`
- **DRY**: Extract repeated logic into `MacMagazineLibrary` or `MacMagazineUILibrary`; never duplicate model/networking code across packages
- **Patterns in use**: MVVM (Views + ViewModels), Coordinator (onboarding), Repository (Network/Storage), Observer (`@Observable`)
- **Value types first**: Prefer `struct` and `enum` over `class` unless reference semantics are required
- **Swift Concurrency only**: All async work uses `async/await`; `DispatchQueue` and completion handlers are legacy — migrate when touching that code

### Testing

- **Framework**: Swift Testing (`@Suite`, `@Test`, `#expect`)
- **Location**: Test targets alongside each feature library
- **Test plan**: `MacMagazine/MacMagazine.xctestplan` (10 test suites)
- **Database tests**: Use `Database(models:inMemory: true)` for isolation
- **Coverage**: ViewModels, models, services, parsers, scoring algorithms

---

## Multi-Platform

### watchOS (`WatchApp/`)

Minimal feed reader: `FeedMainViewModel` fetches news via `FeedLibrary`, displays in a simple list with detail views.

### Widgets (`Widget/`, `WatchWidget/`)

- **iOS Widget**: Timeline provider fetches latest posts, renders with `WidgetView`
- **watchOS Widget**: Separate widget extension
- **Live Activities**: Supported via `MacMagazineWidgetLiveActivity`
- **Data model**: `WidgetData` (postId, title, thumbnail, pubDate, link)

### Conditional Compilation

macOS and visionOS support via `#if os()` where needed. Primary development targets are iOS and watchOS.

---

## External Dependencies

### Private Libraries Package (`https://github.com/cassio-rossi/Libraries.git`)

| Product | Purpose |
|---------|---------|
| `Analytics` | Event tracking (screen views, button taps) |
| `Logger` | Structured logging |
| `Network` | HTTP networking (async/await) |
| `Storage` | SwiftData wrapper (`Database`, `ModelContainer`) |
| `UIComponents` | Shared UI, `Themeable` protocol |
| `InApp` | StoreKit 2 / In-App Purchases |
| `YouTube` | YouTube API, `VideoDB` model |
| `Utilities` | Date formatting, obfuscation, helpers |

### Third-Party

| Package | Version | Purpose |
|---------|---------|---------|
| **OneSignal** | 5.2.1+ | Push notifications (iOS, macOS, visionOS) |
