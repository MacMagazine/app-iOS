# Testing — Swift Testing

Use **Swift Testing** (`import Testing`) for all new tests. Never XCTest for new code.

## Where tests live

- Test targets alongside each feature library under `MacMagazine/Features/`.
- Test plan: `MacMagazine/MacMagazine.xctestplan` (10 test suites).
- Run via xcodebuild (see Build Commands in CLAUDE.md) — always `-testPlan MacMagazine`,
  iPhone 17 Pro simulator, `-skipPackagePluginValidation -skipMacroValidation`.

## Pattern

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

## Rules

- One `@Suite` per type under test; descriptive `@Test("…")` names; `#expect` for assertions.
- `@MainActor` on suites that touch `@MainActor` types (ViewModels, player manager).
- **Database isolation:** use `Database(models:inMemory: true)` from the Storage package — never the shared container.
- Tests are deterministic: no network, no real time/sleeps, fixture data.
- Use `arguments:` for parameterised cases.
- **Every bug fix starts with a failing reproduction test**, then the fix. Never adjust an assertion just to make it green.

## What to test

- ViewModels (state transitions, error handling), models, services, parsers (XMLParser), scoring algorithms (RelevanceScorer), search pipeline (QueryProcessor, SearchResultMerger).
- Don't test SwiftUI view bodies, the compiler, or trivial getters. Test behavior, not implementation — a behavior-preserving refactor must not break tests.

## Definition of tested

A change isn't done until its logic has tests covering success, failure, and the empty/edge
case — and the real `xcodebuild test` output confirms they pass.
