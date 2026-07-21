---
name: ios-start
description: Pre-flight checklist before writing any code in MacMagazine — requirements, reusable-component search, pattern study, branch setup. Use at the start of any feature or enhancement, before the first line of code, or when the user says "start", "new feature", "begin implementing", or "set up a branch".
---

# iOS Feature Start Checklist

Run this at the beginning of any feature implementation to set yourself up for success.

## Before Writing Code

### 1. Understand Requirements
- [ ] Read the request thoroughly
- [ ] Identify all acceptance criteria
- [ ] Note edge cases
- [ ] Ask clarifying questions if anything is unclear

### 2. Search for Existing Code (Avoid Duplication)
- [ ] Search for similar features in codebase
- [ ] Check if reusable components already exist
- [ ] Look for existing services/ViewModels to reference
- [ ] Check MacMagazineUILibrary for shared components (cards, WebViews, PaginatedForEach)
- [ ] Check MacMagazineLibrary for shared utilities

### 3. Study Existing Implementations (CRITICAL)

Before implementing new functionality, ALWAYS read and understand how similar features are already implemented:
- [ ] Read the existing implementation for similar features
- [ ] Match the EXACT pattern (data types, parameter names, flow)
- [ ] Verify data model field types
- [ ] Check how environment injection works

**Key Things to Verify:**
1. **Data Model Types** — Is the field on `FeedDB`, `PodcastDB`, or `VideoDB`? Check the model.
2. **Card System** — Which card view does the similar feature use? Match it.
3. **Environment Chain** — What's injected from `MacMagazineApp`? Don't duplicate.
4. **Navigation Pattern** — Push with `navigationDestination`? Sheet? Full screen cover?

### 4. Design Architecture
- [ ] Identify which feature module this belongs to
- [ ] Plan ViewModel structure
- [ ] Identify dependencies
- [ ] Plan reusable components (avoid duplication)
- [ ] Consider testability

### 5. Set Up Feature Branch
```bash
git checkout release/v5
git pull origin release/v5
git checkout -b feature/short-description
git branch --show-current
```

### 6. Build System Reference

```bash
# Build
xcodebuild build \
  -project MacMagazine/MacMagazine.xcodeproj \
  -scheme MacMagazine \
  -destination "platform=iOS Simulator,name=iPhone 17 Pro" \
  -skipPackagePluginValidation -skipMacroValidation

# Test
xcodebuild test \
  -project MacMagazine/MacMagazine.xcodeproj \
  -scheme MacMagazine \
  -testPlan MacMagazine \
  -destination "platform=iOS Simulator,name=iPhone 17 Pro" \
  -skipPackagePluginValidation -skipMacroValidation

# Lint
swiftlint lint --config ./.swiftlint.yml --strict
```

## Module Location Reference

```
MacMagazine/Features/
├── MacMagazineLibrary/     # Core domain models, enums, protocols, theme
├── MacMagazineUILibrary/   # Shared UI: cards, WebViews, PaginatedForEach
├── FeedLibrary/            # WordPress feed parsing, SwiftData models
├── NewsLibrary/            # News feature UI + ViewModel
├── PodcastLibrary/         # Podcast playback, player manager, cards
├── VideosLibrary/          # YouTube videos
├── SearchLibrary/          # NLP-powered search
├── MMLiveLibrary/          # Live content
├── OnboardingLibrary/      # Onboarding flow
└── SettingsLibrary/        # Settings, preferences
```

## Architecture Patterns

### ViewModel Pattern
```swift
@Observable
class FeatureViewModel {
    var state: ViewState = .idle
    let storage: Database

    init(storage: Database) {
        self.storage = storage
    }

    func loadData() async { ... }
}
```

### View Pattern
```swift
struct FeatureView: View {
    @Environment(\.theme) private var theme: ThemeColor
    @Environment(\.modelContext) private var modelContext

    var body: some View {
        ZStack(alignment: .top) {
            (theme.main.background.color ?? Color.secondary).ignoresSafeArea()
            content
        }
    }
}
```

### Single-Expression Returns (Idiomatic Swift)
```swift
// Correct — no return keyword
var isEmpty: Bool { items.count == 0 }

var color: Color {
    switch self {
    case .news: .blue
    case .podcast: .purple
    case .video: .red
    }
}
```

## Red Flags During Planning

Stop and rethink if:
1. **ViewModel does more than coordinate** → Extract services
2. **View file will be >300 lines** → Extract components
3. **Code will be duplicated** → Extract reusable component
4. **Hard to test** → Use protocol injection
5. **Multiple responsibilities** → Split into focused types
6. **New card layout** → Check if existing CardStyle handles it

## Ready to Start?

- [ ] Feature branch created off `release/v5`
- [ ] Existing code reviewed (no duplication)
- [ ] Architecture designed
- [ ] Card system understood for this content type
- [ ] Dependencies identified
- [ ] Edge cases considered

**Now start coding!**
