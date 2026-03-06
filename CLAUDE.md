# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Commands

### Build
```bash
xcodebuild build \
  -project MacMagazine/MacMagazine.xcodeproj \
  -scheme MacMagazine \
  -destination "platform=iOS Simulator,name=iPhone 17 Pro" \
  -skipPackagePluginValidation \
  -skipMacroValidation
```

### Tests
```bash
xcodebuild test \
  -project MacMagazine/MacMagazine.xcodeproj \
  -scheme MacMagazine \
  -testPlan MacMagazine \
  -destination "platform=iOS Simulator,name=iPhone 17 Pro" \
  -skipPackagePluginValidation \
  -skipMacroValidation
```

### Lint (must pass before every PR)
```bash
swiftlint lint --config ./.swiftlint.yml --strict
```

### Setup
```bash
./Support/Scripts/setup-firebase.sh
```

### Utility scripts (in `Support/Scripts/`)
- `generate-firebase-config.sh` — generate Firebase config
- `clean-build-folders.sh` — clean build artifacts
- `updateBuildVersion.sh` — update version numbers

## Architecture

The app uses **MVVM + SwiftUI** with a **feature-based modular architecture** via Swift Package Manager. Each feature lives in its own local Swift Package under `MacMagazine/Features/`.

### Module Dependency Graph

```
MacMagazine (main app)
├── MacMagazineLibrary      ← core domain models, shared state
├── MacMagazineUILibrary    ← shared UI components, WebViews
├── FeedLibrary             ← feed parsing/fetching (depends on MacMagazineLibrary)
├── NewsLibrary             ← news feature (depends on Feed + UI libraries)
├── PodcastLibrary          ← podcast playback (depends on Feed + UI libraries)
├── VideosLibrary           ← YouTube videos (depends on UI library)
├── MMLiveLibrary           ← live content (depends on UI library)
├── OnboardingLibrary       ← onboarding flow
└── SettingsLibrary         ← settings/preferences (depends on MMLiveLibrary)
```

External dependencies come from a private `Libraries` package (Analytics, Logger, Network, Storage, UIComponents, InApp, YouTube) and **OneSignal** for push notifications.

### Navigation & State
- `MainViewModel` is the root orchestrator — manages navigation, deep linking, onboarding state
- Dependency injection via SwiftUI `@Environment` and `@EnvironmentObject`
- `OnboardingCoordinator` handles the onboarding flow
- `PodcastPlayerManager` manages global audio playback state

### Data Layer
- **SwiftData** for local persistence
- **Network** library for API calls (async/await)
- **Storage** library for persistent key-value storage

### WebViews (`MacMagazineUILibrary/Webview/`)
- `SimpleWebView` — general-purpose `WKWebView` wrapper
- `DisqusWebView` — comments via Disqus, handles login handshake with the app

### Multi-platform
- iOS 26+ (primary)
- watchOS 26+ (separate target in `WatchApp/`)
- Home Screen widgets (`Widget/`, `WatchWidget/`)
- macOS/visionOS via conditional compilation

## Conventions

### Branch naming
- `feature/<description>`, `fix/<description>`, `hotfix/<description>`, `docs/<description>`, `refactor/<description>`
- Branch off `develop`; releases land on `release/v5`

### Commit / PR titles
Conventional Commits format is enforced by CI:
```
feat(scope): description
fix(#123): description    ← bug fixes MUST include issue number
```
Types: `feat`, `fix`, `docs`, `style`, `refactor`, `perf`, `test`, `chore`, `build`, `ci`, `revert`

### Code style & quality
- **Swift 6.2 + SwiftUI** (2026 idioms): use `@Observable`, `@Environment`, structured concurrency (`async/await`, `TaskGroup`, `Actor`), `SwiftData`, and the latest SwiftUI APIs
- **Minimum deployment targets: iOS 26+, watchOS 26+** — do not add availability guards for older OS versions; assume all 2026+ APIs are available unconditionally
- SwiftLint strict mode — the config is `.swiftlint.yml`; run `swiftlint lint --config ./.swiftlint.yml --strict` and fix all violations before committing
- [Ray Wenderlich Swift Style Guide](https://github.com/raywenderlich/swift-style-guide)

### Design principles
- **SOLID**: single-responsibility ViewModels, open/closed protocols, dependency inversion via `@Environment`/`@EnvironmentObject` — never hardcode concrete dependencies inside a view or manager
- **DRY**: extract repeated logic into shared utilities inside `MacMagazineLibrary` or `MacMagazineUILibrary`; do not duplicate model/networking code across feature packages
- **Design patterns in use**: MVVM (Views + ViewModels), Coordinator (onboarding flow), Repository (Network/Storage abstraction), Observer (`@Observable`, Combine publishers for legacy bridges)
- Prefer value types (`struct`, `enum`) over classes unless reference semantics or identity are required
- All async work must use Swift Concurrency; `DispatchQueue` and completion-handler APIs are legacy — migrate when touching that code

### Testing
- Unit tests live alongside each feature library
- Test plan: `MacMagazine/MacMagazine.xctestplan`
