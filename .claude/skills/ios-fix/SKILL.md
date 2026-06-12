---
name: ios-fix
description: Bug-fix and refactoring workflow for MacMagazine — root cause analysis, pattern-matching fix, regression verification. Use when fixing a crash or bug, resolving a GitHub issue, debugging unexpected behavior, refactoring, or when the user says "fix", "bug", "broken", "issue #", or "doesn't work". For new features use ios-implement instead.
---

# iOS Bug Fix & Refactoring

Use this skill when:
- Fixing bugs or defects
- Refactoring existing code
- Optimizing performance
- Addressing tech debt

**For new features use `/ios-implement`.**

---

## Workflow: 3 Steps

### Step 1: Investigation (MANDATORY)

No guessing. Must identify root cause before fixing.

```markdown
## Bug Investigation

### 1. What's Broken?
- Expected behavior: [What should happen]
- Actual behavior: [What's happening]
- Impact: [Who's affected]

### 2. Root Cause Analysis
- [ ] Read the affected files completely
- [ ] Trace the code path causing the issue
- [ ] Search for similar patterns elsewhere

**Root cause**: [WHY the bug exists, not just WHAT is broken]
**Reference**: [file:line]

### 3. Correct Pattern
Does similar code exist that handles this correctly?
- [ ] Found correct implementation at: [file:line]
- [ ] Identified differences from broken code

### 4. Fix Strategy
- [ ] Fix root cause (not symptom)
- [ ] Follow existing patterns
- [ ] No new tech debt introduced

### 5. Regression Risk
- [ ] Identified dependent code
- [ ] Plan to test: [what to verify]
```

### Step 2: Fix Implementation

| Rule | Why |
|------|-----|
| Fix root cause | Prevents recurring bugs |
| Match existing patterns | Maintains consistency |
| No new tech debt | Keeps quality high |
| Follow DRY | Reduces future bugs |
| Use existing helpers | Prevents proliferation |

**MacMagazine-specific checks:**
- Card rendering bug? Check `CardContent`, `CardContentType`, `CardStyle`, `NewsCard` dispatcher
- WebView bug? Check `MMWebView` → `ManagedWebView` → `WebPage` chain
- Search bug? Check both phases (local SwiftData + remote WordPress API classification)
- Podcast bug? Check `PodcastPlayerManager` state and `PodcastMiniPlayerModifier`
- Theme bug? Check `ThemeColor` tokens and dark/light mode resolution

### Step 3: Verification

Run `/ios-dod` then verify:

```markdown
## Bug Fix Verification

### Investigation
- [x] Root cause identified (not guessed)
- [x] Correct pattern found in existing code

### Fix Quality
- [x] Fixes root cause (not symptom)
- [x] Follows existing patterns
- [x] No new tech debt

### Testing
- [x] Tests added for bug scenario
- [x] All existing tests pass
- [x] Build succeeds, lint passes
```

---

## Common MacMagazine Bug Patterns

### Search results showing wrong card type
**Root cause**: `SearchResultsList` not using the right card view per content type.
**Fix**: News → `NewsCard`, Podcast → `AdaptivePodcastCardView`, Video → `GlassCardView`

### Remote search missing podcasts/videos
**Root cause**: WordPress results not classified by `podcastURL` and category.
**Fix**: Check `RemoteFeedSearchService` classification logic and `FeedViewModel.searchAll()`

### WebView horizontal scroll on small content
**Root cause**: Missing scroll behavior modifier.
**Fix**: `.scrollBounceBehavior(.basedOnSize, axes: .horizontal)` on the WebView

### Theme colors wrong in dark mode
**Root cause**: Using hardcoded colors instead of theme tokens.
**Fix**: Use `@Environment(\.theme)` and `theme.main.background.color`

---

## Enforcement

### FAIL Conditions
- Skip investigation and guess at fix
- Patch symptom instead of root cause
- Create new patterns instead of following existing
- Skip tests for bug scenario

### SUCCESS Conditions
- Root cause identified with evidence
- Fix follows existing patterns
- Tests cover the bug scenario
- No regressions introduced
