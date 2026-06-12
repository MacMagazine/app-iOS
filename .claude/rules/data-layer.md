# Data Layer — SwiftData, search, podcast, multi-platform

## SwiftData models

All models use the `DB` suffix. Schema registered in `MainViewModel.init()`.

| Model | Package | Purpose |
|-------|---------|---------|
| `FeedDB` | FeedLibrary | News articles (postId, title, pubDate, categories, favorite) |
| `PodcastDB` | FeedLibrary | Podcast episodes (podcastURL, duration, current playback position) |
| `VideoDB` | Libraries/YouTube | YouTube videos (videoId, views, likes, duration) |
| `SettingsDB` | SettingsLibrary | User preferences, subscription state |
| `CustomizationDB` | SettingsLibrary | Tab/feature customization |
| `RecentSearchDB` | SearchLibrary | Recent search queries (max 20) |

**Model protocols:**
- `ModelFavoritable` — delete non-favorites cleanup
- `ModelDuplicable` — iCloud deduplication on sync

## Data sources

- **WordPress RSS/XML** — News articles, podcasts (via `FeedLibrary/XMLParser`)
- **YouTube API** — Videos (via `Libraries/YouTube`)
- **SwiftData** — Local persistence with iCloud sync
- **Storage** — Key-value persistent storage (external Libraries package)

## Search system (SearchLibrary)

### Two-phase search

1. **Local (instant)** — SwiftData queries against `FeedDB`, `PodcastDB`, `VideoDB`
2. **Remote (async)** — WordPress API via `FeedViewModel.searchAll()` returns mixed results

### NLP pipeline (Apple NaturalLanguage framework)

```
User query → Tokenizer (Portuguese) → Lemmatizer → Entity Extraction
           → QueryIntent (normalizedTerms, entities, categories, contentTypes)
```

### Key types

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

### Result classification (remote)

WordPress search returns mixed posts — always classify, never assume all results are news:
- `podcastURL` non-empty → `.podcast` (with full `PodcastDB` data)
- Category contains `NewsCategoryMMTV` → `.video`
- Otherwise → `.news`

Search results are **always sorted by pubDate descending** — no relevance sorting, newest first.

## Podcast system (PodcastLibrary)

### PodcastPlayerManager (`@MainActor @Observable`)

Global audio playback state injected via `@Environment`. Available everywhere. Manages:
- AVPlayer lifecycle, audio session, remote transport controls
- Chapter parsing from audio metadata
- Play position tracking (`currentTime`, `duration`)
- Mini player ↔ full player transitions

### Card views

| View | Layout | When |
|------|--------|------|
| `AdaptivePodcastCardView` | Smart dispatcher | Always used |
| `GlassPodcastCardView` | Glass overlay + play button | Primary (normal text) |
| `PodcastCardView` | Image top + metadata below | Accessibility (large text) |

### Mini player

`PodcastMiniPlayerModifier` applies at the tab level:
- iPhone: `tabViewBottomAccessory` mini player
- iPad: `safeAreaInset` floating player
- Full player sheet available from all contexts (search, news, podcasts)

## Multi-platform

- **watchOS (`WatchApp/`)** — Minimal feed reader: `FeedMainViewModel` fetches news via `FeedLibrary`, simple list with detail views.
- **iOS Widget (`Widget/`)** — Timeline provider fetches latest posts, renders with `WidgetView`. Live Activities via `MacMagazineWidgetLiveActivity`.
- **watchOS Widget (`WatchWidget/`)** — Separate widget extension.
- **Widget data model** — `WidgetData` (postId, title, thumbnail, pubDate, link).
- macOS and visionOS via `#if os()` where needed. Primary targets: iOS and watchOS.

## External dependencies

### Private Libraries package (`https://github.com/cassio-rossi/Libraries.git`)

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

### Third-party

| Package | Version | Purpose |
|---------|---------|---------|
| **OneSignal** | 5.2.1+ | Push notifications (iOS, macOS, visionOS) |
