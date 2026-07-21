---
name: ios-dod
description: Definition of Done verification for MacMagazine — build, test, lint, code-quality and git checks with real evidence. Use before marking any task complete, before committing, or when the user says "done", "verify", "is this finished", or "check the work".
allowed-tools: Read, Grep, Glob, Bash
---

# iOS Definition of Done Checklist

Run before marking any task as "done".

**Honesty rules:** Report **real** results only. Never claim an item passed without the actual
command output as evidence. If a tool or simulator isn't available, mark that item **UNVERIFIED**
— never imply success. If anything is ❌ or UNVERIFIED, the task is **not done**: list exactly
what remains. (Full contract: `.claude/rules/anti-hallucination.md`.)

**Delegation:** For the build/test steps you may delegate to the `test-runner` agent; for a final
review pass use the `swift-code-reviewer` and `architecture-guardian` agents.

## Critical Requirements (Zero Tolerance)

### Code Quality (SOLID + DRY)
- [ ] No code duplication (extracted reusable components)
- [ ] ViewModels use `@Observable` (not `ObservableObject`)
- [ ] Dependencies injected via `@Environment` / protocols
- [ ] No force unwrapping (`!`), force cast (`as!`), or force try (`try!`)
- [ ] Code is self-documenting — no obvious comments
- [ ] Only meaningful comments remain: `// MARK:`, `///` DocC, complex logic "why", `// TODO:`

### Card System Compliance
- [ ] News content uses `NewsCard` (auto-dispatches by category)
- [ ] Podcast content uses `AdaptivePodcastCardView` (local) or `GlassCardView` (remote fallback)
- [ ] Video content uses `GlassCardView` with `.video` type
- [ ] Theme colors via `@Environment(\.theme)` — no hardcoded colors

### Build & Tests
- [ ] Build succeeds:
```bash
xcodebuild build \
  -project MacMagazine/MacMagazine.xcodeproj \
  -scheme MacMagazine \
  -destination "platform=iOS Simulator,name=iPhone 17 Pro" \
  -skipPackagePluginValidation -skipMacroValidation
```
- [ ] All tests pass:
```bash
xcodebuild test \
  -project MacMagazine/MacMagazine.xcodeproj \
  -scheme MacMagazine \
  -testPlan MacMagazine \
  -destination "platform=iOS Simulator,name=iPhone 17 Pro" \
  -skipPackagePluginValidation -skipMacroValidation
```
- [ ] SwiftLint clean (zero violations):
```bash
swiftlint lint --config ./.swiftlint.yml --strict
```
- [ ] New tests use Swift Testing (`@Suite`, `@Test`, `#expect`)

### Git Workflow
- [ ] On feature/fix branch off `release/v5`
- [ ] Committed with Conventional Commits format:
```
feat(scope): description
fix(scope): description
```
- [ ] Co-authored-by line included
- [ ] Pushed to remote

## Self-Review Questions

Before saying "done":
1. Would I approve this PR if someone else wrote it?
2. Is any code duplicated? Could another feature use this?
3. Did I test dark mode?
4. Did I use the card system correctly?
5. Would a new developer understand this code without comments?
6. Did I check that search results, WebViews, and podcast player still work?

---

**"SOLID over shortcuts. DRY over duplication. Quality gates over speed."**
