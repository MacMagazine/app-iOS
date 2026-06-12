---
name: ios-sanity-check
description: Read-only audit of the entire MacMagazine codebase for quality, consistency, and compliance with CLAUDE.md and .claude/rules standards. Use periodically, before releases, or when the user says "sanity check", "audit", "health check", or "how is the codebase".
allowed-tools: Read, Grep, Glob, Bash, Agent
---

# iOS Codebase Sanity Check

Run periodically to audit the codebase. This is **read-only analysis** — reports findings but does not modify code.

## How to Run

```
/ios-sanity-check
```

## Audit Dimensions

Run all dimensions in parallel using the Agent tool with `subagent_type: Explore`.

### 1. Obvious Comments
**Rule**: No comments that restate what the code does.
**Search for**: Comments before simple assignments, type declarations, loop iterations.
**Acceptable**: `// MARK:`, `///` DocC, complex algorithms, business rule "why", `// TODO:`.

### 2. Force Unwraps in Production Code
**Rule**: Zero force unwraps in production code.
**Search for**: `variable!.`, `as!`, `try!`
**Exclude**: Test files, negation operators (`!isEmpty`).

### 3. @Observable Usage
**Rule**: All ViewModels use `@Observable`, not `ObservableObject`.
**Search for**: `ObservableObject`, `@Published` in ViewModels.

### 4. Card System Compliance
**Rule**: Content rendered with correct card views.
**Search for**:
- News content using `GlassCardView` directly instead of `NewsCard`
- Missing `categories.mostRelevant.style` for news cards
- Podcast content not using `AdaptivePodcastCardView`

### 5. Hardcoded Colors
**Rule**: All colors via `@Environment(\.theme)` theme tokens.
**Search for**: `Color.blue`, `Color.red`, hardcoded hex values outside MacMagazineLibrary.
**Exclude**: MacMagazineLibrary (where colors are defined), test/preview code.

### 6. SwiftLint Compliance
**Run**: `swiftlint lint --config ./.swiftlint.yml --strict`
**Report**: Total warnings and errors.

### 7. DRY Violations
**Search for**:
- View files over 300 lines
- ViewModel files over 400 lines
- Duplicated code blocks across features

### 8. SOLID Violations
**Search for**:
- ViewModels with >10 public methods (too many responsibilities)
- Concrete service instantiation in ViewModels (dependency inversion violation)
- Bloated protocols (>8 required methods)

### 9. Search System Integrity
**Verify**:
- Two-phase search working (local + remote)
- Remote results classified by `podcastURL` and category
- Results always sorted by `pubDate` descending
- `SearchResultMerger` deduplicates correctly

### 10. WebView System Integrity
**Verify**:
- All public WebViews go through `MMWebView`
- User scripts applied correctly
- Navigation decisions routed through `MMNavigationDecider`
- Horizontal scroll prevented via `.scrollBounceBehavior`

## Report Format

| # | Dimension | Status | Count | Grade |
|---|-----------|--------|-------|-------|
| 1 | Obvious comments | Clean / X violations | N | A+ to F |
| ... | ... | ... | ... | ... |

### Grading: A+ (0), A (1-2), B (3-6), C (7-15), F (16+)

---

**Last Updated**: 2026-03-06
