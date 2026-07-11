# CLAUDE.md — MacMagazine

> This file is the **constitution**. It is loaded every session — keep it short.
> Detail lives in `.claude/rules/*.md` (read the relevant file before working in its area).
> If a rule here conflicts with a rules file, **this file wins**.

## What this is

MacMagazine is a Brazilian Apple news aggregator — iOS, watchOS, widgets — delivering news,
podcasts, and YouTube videos. **Swift 6.2**, **SwiftUI**, **SwiftData**, feature-based modular
architecture via local Swift packages under `MacMagazine/Features/`.

- **Minimum targets:** iOS 26+, watchOS 26+
- **No availability guards** — all 2026+ APIs are available unconditionally

## Build Commands

**CRITICAL**: Always use `-skipPackagePluginValidation -skipMacroValidation` and target the
**iPhone 17 Pro simulator**.

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

Utility scripts in `Support/Scripts/`: `generate-firebase-config.sh`, `clean-build-folders.sh`,
`updateBuildVersion.sh`.

## Module map (dependencies flow downward only)

```
MacMagazine (app) ─▶ Feature libraries ─▶ MacMagazineUILibrary ─▶ MacMagazineLibrary (0 deps)
                     NewsLibrary  PodcastLibrary  VideosLibrary   └▶ FeedLibrary (iOS+watch)
                     SearchLibrary  MMLiveLibrary                      └▶ Network, Storage
                     OnboardingLibrary  SettingsLibrary
External: Analytics · Logger · Network · Storage · UIComponents · InApp · YouTube · Utilities · OneSignal
```

- **Feature libraries never import each other.** Only exception: SearchLibrary → PodcastLibrary.
- Shared logic → `MacMagazineLibrary`; shared UI → `MacMagazineUILibrary`. Never copy code between features.
- Other targets: WatchApp, Widget, WatchWidget (FeedLibrary subset).

## The golden rules

1. **Read before you write.** Open the file you'll touch plus at least 5 related files (similar
   feature, parent ViewModel, relevant service). Match naming, parameters, and types exactly.
2. **Mirror existing patterns.** Reuse existing helpers — never invent alternatives that already
   exist. New patterns require approval (`AskUserQuestion`).
3. **Use the system entry points.** News → `NewsCard`. Podcasts → `AdaptivePodcastCardView`.
   Videos → `GlassCardView(.video)`. Web → `MMWebView` (never raw `WKWebView`). Colors →
   `@Environment(\.theme)` (never hardcoded).
4. **Swift Testing for all new tests** (`@Suite`, `@Test`, `#expect`) — never XCTest.
   Database tests use `Database(models:inMemory: true)`.
5. **Zero tolerance for obvious comments.** Keep only `// MARK: -`, `///` DocC on public API,
   complex algorithms, non-obvious "why", `// TODO:`.
6. **Quality gates before every commit:** build + test + lint (commands above) must all pass.
7. **Commit and push automatically when done.** After gates pass, commit (Conventional Commits)
   and push without asking. See `.claude/rules/git-workflow.md`.
8. **When unsure, read more code — or ask.** Never guess. The codebase is the source of truth.

## Anti-hallucination contract (the most important section)

- **Never invent APIs or symbols.** Not certain a type/method exists with that signature?
  Grep/open the file and confirm before using it.
- **Cite where you act** — `path:line` for every change you describe.
- **Never fabricate results.** Don't claim a build/test/lint passed unless you ran it and are
  pasting real output. Couldn't run it? Say so — mark it UNVERIFIED.
- **Stay in scope.** No drive-by refactors. Note unrelated issues; don't fix them.
- Full contract: `.claude/rules/anti-hallucination.md`.

## Rules (read on demand — do not duplicate their content here)

- `.claude/rules/architecture.md` — modules, dependency rules, environment injection, navigation, MVVM, SOLID/DRY
- `.claude/rules/ui-systems.md` — card system, WebView system, theme tokens, accessibility
- `.claude/rules/data-layer.md` — SwiftData models, search system, podcast system, multi-platform, dependencies
- `.claude/rules/swift-style.md` — naming, optionals, SwiftLint config, comment policy
- `.claude/rules/concurrency.md` — Swift 6.2 strict patterns, legacy GCD migration, bans
- `.claude/rules/testing.md` — Swift Testing patterns, isolation, what to test
- `.claude/rules/git-workflow.md` — branches, commits, the gate, auto-commit/push policy

## Agents (`.claude/agents/`)

| Agent | When to Use |
|-------|-------------|
| `ios-principal-engineer` | Full implementation tasks: features, fixes, refactoring |
| `swift-code-reviewer` | Rigorous review of Swift/SwiftUI changes (read-only) |
| `architecture-guardian` | Module-boundary & system-compliance verification (read-only) |
| `test-runner` | Build + run tests, report real results (read-only) |

## Skills (`.claude/skills/`)

| Skill | When to Use |
|-------|-------------|
| `/ios-start` | Pre-flight checklist before writing code |
| `/ios-implement` | Complete feature implementation workflow |
| `/ios-fix` | Bug fixes, refactoring, root cause analysis |
| `/ios-dod` | Definition of Done before marking task complete |
| `/ios-design-guidelines` | Theme, cards, typography, accessibility reference |
| `/ios-sanity-check` | Read-only codebase health audit |

Built-in: `/code-review` (diff review), `/simplify` (cleanup pass), `/verify` (run & observe),
`/security-review`.

## Guardrails (deterministic — see `.claude/settings.json` + `.claude/hooks/`)

- **Permissions** pre-approve the toolchain (xcodebuild, swiftlint, git, gh) and deny reading
  secrets (`GoogleService-Info.plist`, `*.xcconfig`, certs) and destructive commands.
- **PreToolUse hook** blocks `rm -rf`, `sudo`, force-push, `reset --hard`, `curl | sh`.
- **PostToolUse hook** lints every edited Swift file (`--strict`) and blocks `try!`/`as!`/
  `@unchecked Sendable`. Fix violations immediately when the hook reports them.
- **Stop hook** prints the Definition-of-Done reminder.

## Definition of Done (all must hold before you say "done")

- [ ] Code mirrors existing patterns; system entry points used (cards/WebView/theme)
- [ ] Build succeeds on iPhone 17 Pro simulator — real output
- [ ] All tests pass (`-testPlan MacMagazine`), new code has Swift Testing coverage — real output
- [ ] `swiftlint lint --config ./.swiftlint.yml --strict` — zero violations
- [ ] No force-unwrap/`try!`/`as!`; no obvious comments; no debug code
- [ ] Diff scoped to the task
- [ ] Committed (Conventional Commits) and pushed

Run `/ios-dod` for the full checklist.

## Conventions

- **Branches:** `feature/…`, `fix/…`, `hotfix/…`, `docs/…`, `refactor/…` — off `develop`;
  releases land on `release/v5`.
- **Commits/PR titles** (CI-enforced): `feat(scope): description` · `fix(#123): description`
  (bug fixes MUST include the issue number). Types: feat, fix, docs, style, refactor, perf,
  test, chore, build, ci, revert. Trailer: `Co-Authored-By: Claude <noreply@anthropic.com>`.
- **Style:** Swift 6.2 idioms (`@Observable`, structured concurrency), value types first,
  SwiftLint strict, Ray Wenderlich style guide.

## graphify

This project has a knowledge graph at graphify-out/ with god nodes, community structure, and cross-file relationships.

Rules:
- For codebase questions, first run `graphify query "<question>"` when graphify-out/graph.json exists. Use `graphify path "<A>" "<B>"` for relationships and `graphify explain "<concept>"` for focused concepts. These return a scoped subgraph, usually much smaller than GRAPH_REPORT.md or raw grep output.
- If graphify-out/wiki/index.md exists, use it for broad navigation instead of raw source browsing.
- Read graphify-out/GRAPH_REPORT.md only for broad architecture review or when query/path/explain do not surface enough context.
- After modifying code, run `graphify update .` to keep the graph current (AST-only, no API cost).
