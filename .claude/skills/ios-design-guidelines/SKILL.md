---
name: ios-design-guidelines
description: MacMagazine design reference — theme tokens, card selection, typography, touch targets, accessibility, dark mode. Use when creating or restyling UI, choosing which card view renders content, picking colors or fonts, or when the user mentions "design", "theme", "card", "dark mode", or "accessibility".
---

# iOS Design Guidelines for MacMagazine

## Theme System

MacMagazine uses a custom `ThemeColor` system injected via environment:

```swift
@Environment(\.theme) private var theme: ThemeColor
```

### Theme Tokens

| Token | Access | Purpose |
|-------|--------|---------|
| `theme.main.background` | Primary background | ZStack background |
| `theme.main.navigation` | Nav bar | Navigation chrome |
| `theme.main.tint` | Tint color | Accent color |
| `theme.secondary.background` | Secondary bg | Cards, sections |
| `theme.text.primary` | Primary text | Titles, body |
| `theme.text.secondary` | Secondary text | Subtitles, metadata |
| `theme.button.primary` | Primary button | Action buttons |
| `theme.button.destructive` | Destructive | Delete actions |

### Standard Background Pattern

```swift
var body: some View {
    ZStack(alignment: .top) {
        (theme.main.background.color ?? Color.secondary).ignoresSafeArea()
        content
    }
}
```

## Card System

### When to Use Which Card

| Content | Card | Style Resolution |
|---------|------|-----------------|
| News article | `NewsCard` | `categories.mostRelevant.style` auto-dispatches |
| Podcast (local) | `AdaptivePodcastCardView` | Smart: glass (normal text) or card (large text) |
| Podcast (remote) | `GlassCardView` | `.podcast(duration:)` type |
| Video | `GlassCardView` | `.video(views:likes:duration:)` type |
| Highlight | `GlassCardView` | `.highlight` style |

### CardStyle Reference

| Style | View | Used When |
|-------|------|-----------|
| `.leadingImage` | `LeadingImageCard` | Default news |
| `.topImage` | `TopImageCard` | Accessibility fallback |
| `.bottomImage` | `BottomImageCard` | Alternate layout |
| `.highlight` / `.glass` | `GlassCardView` | Highlights, podcasts, videos |
| `.simple` | `SimpleCard` | Text-only |

## Typography

Use system text styles (auto-scales with Dynamic Type):

```swift
// Correct
Text("Title").font(.headline)
Text("Body").font(.body)

// Wrong — doesn't scale
Text("Title").font(.system(size: 17))
```

## Touch Targets

| Element | Minimum | Recommended |
|---------|---------|-------------|
| Buttons | 44x44pt | 48x48pt |
| List rows | 44pt height | 48-60pt |

## Accessibility

- All interactive elements need accessibility labels
- Group related elements with `.accessibilityElement(children: .combine)`
- Don't rely on color alone — use icons + color
- Test with Dynamic Type at largest sizes

## Dark Mode

- Use theme tokens, never hardcoded colors
- Colors resolve automatically via `String.color` → `Color(name, bundle: .module)`
- Materials (`.ultraThinMaterial`, `.thinMaterial`) adapt automatically
- Test both modes before committing

---

**Last Updated**: 2026-03-06
