# UI Systems — cards, WebViews, theme

## Card system (MacMagazineUILibrary)

Unified content rendering across the app. **Never bypass it.**

### CardContent — universal data model

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

### CardContentType — content variants

| Type | Extra Data | Default Style |
|------|------------|---------------|
| `.news(categories, style)` | `[NewsCategory]`, `CardStyle?` | Category-driven |
| `.podcast(duration)` | Duration string | `.glass` |
| `.video(views, likes, duration)` | Stats strings | `.glass` |

### CardStyle — layout variants

| Style | View | Used By |
|-------|------|---------|
| `.leadingImage` | `LeadingImageCard` | Default news |
| `.topImage` | `TopImageCard` | Accessibility fallback |
| `.bottomImage` | `BottomImageCard` | Alternate layout |
| `.highlight` / `.glass` | `GlassCardView` | Highlights, podcasts, videos |
| `.simple` | `SimpleCard` | Text-only fallback |

### NewsCard — smart dispatcher

`NewsCard` selects the layout automatically:
1. Checks `dynamicTypeSize.usesPrimaryCardLayout` (accessibility)
2. Resolves `categories.mostRelevant.style` (category priority: highlights > appletv > reviews > rumors > tutorials > news)
3. Falls back to `data.type.style`, then `SimpleCard`

### Which card for which content

| Content | Card View | Data Source |
|---------|-----------|-------------|
| News article | `NewsCard` (auto-dispatches by category) | `FeedDB` or WordPress API |
| Podcast | `AdaptivePodcastCardView` (local) / `GlassCardView(.podcast)` (remote fallback) | `PodcastDB` / WordPress API |
| Video | `GlassCardView` with `.video` | `VideoDB` |

### Category-to-style mapping (NewsCategory.style)

| Category | Style |
|----------|-------|
| `.highlights` | `.highlight` |
| `.podcast`, `.youtube` | `.glass` |
| All others | `.leadingImage` |

## WebView system (MacMagazineUILibrary/Webview/)

```
MMWebView (public entry point)
  └── ManagedWebView (lifecycle manager)
        └── WebView (SwiftUI, iOS 26)
              └── WebPage (WKWebView wrapper)
```

**Always use `MMWebView` as the entry point. Never create raw `WKWebView` instances.**

| Type | Purpose |
|------|---------|
| `MMWebView` | Public view: URL loading, caching, cookies, user scripts |
| `ManagedWebView` | Lifecycle: loading states, error handling, scene phase |
| `WebPageCache` | In-memory page cache by key |
| `MMNavigationDecider` | Routes URLs: internal links, comments, external |
| `MMWebViewUserScripts` | JS injection: padding, zoom, gallery disable |
| `DisqusWebView` | Comments sheet with separate data store + login flow |
| `Cookies` | Cookie factory: dark mode, ad removal, Disqus session |

### User scripts

| Script | Timing | Purpose |
|--------|--------|---------|
| `topPadding` | documentEnd | 50px top padding |
| `tapToZoom` | documentEnd | Image tap-to-zoom handler |
| `disableGallery` | documentEnd | Disable FancyBox gallery |
| `disableNewGallery` | documentEnd | Disable pk-image-popup gallery |
| `removeBackToBlog` | documentEnd | Remove back-to-blog link |
| `hideSiteHeader` | documentEnd | Hide site header (public) |
| `interceptNewWindows` | documentStart | Intercept `target="_blank"` links |

CSS/JS injection is a last resort — prefer native SwiftUI modifiers (e.g. `.scrollBounceBehavior`).

## Theme system

```swift
@Environment(\.theme) private var theme: ThemeColor
```

**No hardcoded colors in feature code.** Test in dark AND light mode — colors resolve differently.

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

## Accessibility

Respect Dynamic Type (the card system's accessibility fallbacks exist for this), label controls, avoid fixed heights that break with larger text. Handle iPad vs iPhone layout (`\.iPad`, `\.shouldUseSidebar`).
