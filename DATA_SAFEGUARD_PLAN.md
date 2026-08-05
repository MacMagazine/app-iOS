# Plan — Version-Change Data Safeguard (issue #304)

> **Working doc — DO NOT MERGE.** Lives at repo root only while the feature is being built.
> Executor: `ios-principal-engineer` agent, with a human reviewing between phases.
> Branch: `fix/304-version-change-data-safeguard` off `release/v5`. Commits: `fix(#304): …`.
>
> **Note:** this file is untracked (deliberately — see header). It was lost from disk once
> during Phase 1 and had to be reconstructed from conversation history. If you're picking this
> plan back up cold, re-save it somewhere durable (or just commit it temporarily) rather than
> trusting it survives branch switches unattended.

## 0. Status (updated 2026-07-30)

- **Phase 1 — DONE and committed** (`f5ae8c17`). Protocol + conformances + tests, build/test/lint
  all green, independently re-verified (not just trusting the agent's pasted output).
- **Phase 2 — DONE.** `SafeguardCoordinator` + version gate + iCloud quiesce/timeout wait, built
  as a new `SafeguardLibrary` package. Build `BUILD SUCCEEDED`, tests `567/567` (18 new),
  lint `0 violations in 252 files` — all independently re-run, not just the agent's report.
  Not committed yet — three decisions below needed resolving first; now resolved. See §7 Phase 2
  and §8 for what was confirmed.
- **Phase 3 — first attempt REJECTED, being redone.** UI + wiring landed as a
  `.fullScreenCover(item:)`/`.sheet(item:)` presented *over* `MainView()`. **This does not gate
  anything** — a modal presentation only covers its presenter visually; `MainView`'s child
  feature views (`NewsView`, `PodcastView`, etc.) each fire their own independent `.task`-based
  fetch-on-appear, uncoordinated with the safeguard coordinator's phase. Since `content`
  evaluates `MainView()` on first render — before the async `.task` that calls
  `initializeSafeguard()` even runs — those feature views start fetching and saving into the
  shared store before the coordinator's snapshot step executes. **This breaks the entire
  ordering guarantee the feature exists to provide** (snapshot before fetch), independent of any
  timing edge case — not a corner case, a structural bug in the presentation choice. See the
  memory `modal-presentation-does-not-pause-presenter` for the general lesson.
  **Correct approach: `content` must switch between `SafeguardView` and `MainView()` — an
  if/else or enum-driven switch — never overlay one on the other.** `MainView` (and therefore
  every feature view's independent fetch) must not be composed/mounted at all while the
  safeguard flow is active, silent or visible. The gate decision (does the flow need to run,
  and does it need visible UI) must be resolved as early as possible — ideally synchronously in
  `MainViewModel.init()`, since the version-gate check (UserDefaults) and the fresh-install
  check (row counts) are both synchronous — so the very first render already branches correctly
  and `MainView` is never briefly composed before the decision lands. The async parts (snapshot,
  iCloud wait, fetch, restore) still run inside `SafeguardView`'s own `.task`, same as before —
  only the *presentation mechanism* and *when the gate decision is made* need to change.
- **Decided 2026-07-30 (Phase 1 checkpoint), supersedes earlier wording below:**
  - **VideoDB match key is `videoId`, not `postId`** (confirmed correct — `VideoDB` has no
    `postId`; its existing `deduplicate()` already groups by `videoId`). Wherever this doc says
    "match/restore by postId," `VideoDB` is the one exception.
  - **No `async`, and don't force artificial `throws`.** `ModelContext.save()` is already a
    synchronous **throwing** call — that's the only failure surface SwiftData gives us, and
    it's enough; there's no need to wrap these in `async throws` or invent a Result type.
    `ModelSafeguardable.snapshot`/`restore` should propagate that `throws` (plain, non-async).
    See the rewritten **Failure semantics** in §5 for the behavior this drives.
  - **Simulator: iOS 26 only.** The project only targets iOS 26+ (per root `CLAUDE.md`). An
    iOS 27 "iPhone 17 Pro" simulator got created by accident during Phase 1 (none existed
    locally) and has been deleted; only the iOS 26.5 "iPhone 17 Pro" remains. But a name-only
    destination still resolves `OS:latest` against the newest *installed* runtime (27.0, present
    for other device models like iPad Pro/Vision Pro), which has no iPhone 17 Pro simulator —
    so the plain destination string fails outright rather than falling back to 26.5. Fixed by
    pinning `OS=26.5` explicitly everywhere the destination string appears: `CLAUDE.md`, the
    `ios-principal-engineer`/`test-runner` agent definitions, and the `ios-start`/`ios-dod`
    skills. Use `-destination "platform=iOS Simulator,name=iPhone 17 Pro,OS=26.5"` going forward.
- **Decided 2026-07-30 (Phase 2 checkpoint):**
  - **Module placement resolved: `SafeguardLibrary` package, not app target** (supersedes §8
    Open point A). The app-target option turned out to be untestable — the test plan has only
    SPM test targets, no app-target test bundle — and the package needs no feature-library
    dependency anyway, since it dispatches via `any ModelSafeguardable.Type` the same way
    `MainViewModel.deduplicate()` dispatches via `any ModelDuplicable.Type`.
  - **`snapshot`/`restore`'s internal SwiftData fetches use `try`, not `try?`.** Beyond the
    plan's literal "propagate what `save()` throws": a `try?`-swallowed failed fetch would look
    like a successful *empty* snapshot — the exact silent-data-drop this feature exists to
    prevent. Confirmed intentional, keep it.
  - **New known gap, to close in Phase 3:** `retry()` only re-runs the restore step, not the
    snapshot step. If `takeSnapshot()` itself throws partway through (one model snapshots fine,
    the next throws), there's no path to re-snapshot — only to restore from whatever partial
    snapshot exists. Phase 3's failure UI needs a second action beyond "Retry" — a "start over"
    that discards the partial snapshot and re-runs the whole flow from `takeSnapshot()`. This
    doubles as the answer to §8 Open point E (failure-state second action): the answer is yes,
    a second action is needed, and this is why.
- **Phase 3 redo — accepted, with one more gap found and resolved (2026-07-30).** `content` now
  switches `SafeguardView`/`MainView()` correctly (verified independently: read the source,
  confirmed `SceneDelegate.swift:19` constructs `MainViewModel` — and therefore resolves the
  gate synchronously — before `UIHostingController`/`SceneView` exists at all). Build/test/lint
  independently re-verified green (576/576 tests, 0 lint violations).
  **But the same defect class still existed one level up**: `SceneView.body`'s deep-link
  `.fullScreenCover(isPresented:)`, the onboarding `.sheet(item:)`, and their supporting
  `.onOpenURL`/`.onChange` handlers are attached to `body` — which wraps `content` regardless of
  which branch it's showing. A push/widget/shortcut deep link arriving while `SafeguardView` is
  the active content still presents `DeepLinkNewsDetailView` **over** it, and that view can write
  to the shared store (e.g. mark-as-read) before the snapshot step runs. Same hazard, narrower
  window (has to land within the few seconds the flow takes).
  **Resolved: pure composition, no suppression flags.** All of `body`'s presentation modifiers
  that belong to "MainView is showing" — `.onOpenURL`, the deep-link `.fullScreenCover`, the
  onboarding `.sheet(item:)`, and the push/shortcut `.onChange` handlers — move onto the
  `MainView()` branch itself inside `content`, not onto the shared `body`/`content` wrapper.
  While `SafeguardView` is the active branch, none of those modifiers exist in the tree at all —
  not suppressed, structurally absent. **The one thing to get right when implementing this: do
  not drop a deep link that arrives while `SafeguardView` is showing.** `SceneDelegate.swift`'s
  UIKit-level `openDeepLink(from:)`/`openUniversalLink(from:)` set `viewModel.deepLinkPostURL`
  directly (independent of whether the SwiftUI `.onOpenURL` modifier is mounted), so the state is
  captured regardless. The `.fullScreenCover(isPresented:)` binding just needs to read that state
  fresh once it (re)mounts under `MainView()` — SwiftUI evaluates `isPresented` on first
  appearance, so a URL that arrived during the safeguard flow presents correctly the moment
  `MainView` mounts, deferred rather than lost. The push/shortcut `.onChange` handlers are
  trickier: `.onChange` only observes changes from the moment a modifier mounts, so a change that
  happened while unmounted needs an equivalent one-time check at mount (the existing `.task`
  block already does this for `pushNotification.newContentAvailable` — verify that check still
  runs at the right time after the restructure, and trace whether `shortcutManager.url`/`.tab`
  need the same "check current value on mount, not just react to changes" treatment). Verify this
  by tracing the mount/unmount timeline explicitly, don't just assert it.
  **Resolved and independently re-verified 2026-07-30.** `mainView` (new, `MacMagazineApp.swift:92`)
  now holds `.onOpenURL`, the deep-link `.fullScreenCover`, the onboarding `.sheet(item:)`, and
  the three push/shortcut `.onChange` handlers — `body` carries only the shared `.task` (context
  wiring, analytics, `initializeOnboarding()`) and `.environment(\.theme,…)`. The push-notification
  one-time check found a **real gap** the brief only hypothesized: `.onChange` alone only observes
  from mount forward, so an event delivered while `SafeguardView` owned the screen would have been
  missed entirely once the original `body`-level one-time `.task` check was removed. Closed by
  adding `initial: true` to all three `.onChange` handlers, so each re-reads its current value the
  moment `mainView` mounts — deferred, not lost. Traced by reading the source directly (not just
  trusting the report): `SceneDelegate.swift`'s `openDeepLink`/`openUniversalLink`/shortcut
  handlers all set state via direct UIKit calls, independent of whether `mainView` is mounted, so
  `initial: true` is sufficient — no additional plumbing needed. Build/test/lint independently
  re-verified green (576/576, 0 lint violations) after this fix, on top of the already-verified
  `content` switch.
## 1. Problem

Issue #304: a reader lost favorites updating 5.0 → 5.0.1. PR #323 already hardened
`deduplicate()` with per-field authority timestamps (`favoriteModifiedAt`, `readModifiedAt` —
`FeedDB.swift:124-149`, `ModelProtocols.swift:16-60`), which fixes the dedup-discards-favorites
vector. This feature adds a **belt-and-suspenders safety net around app updates**: snapshot user
state before anything (iCloud import, fetch, dedup) can touch it, then restore it afterwards.

## 2. Decisions already made (by Cassio — do not re-litigate)

| Decision | Choice |
|---|---|
| Snapshot store | **In-memory SwiftData store, new `Database` container** (`inMemory: true`, no CloudKit). Main store remains source of truth; snapshot is a working copy destroyed after a *successful* restore (see §5 Failure semantics for the failure case). |
| Trigger | **Any version *or* build change, and first run** (stored key is nil). Store the checked version only after a successful run. |
| iCloud wait | **Quiesce window + hard timeout**: wait for `.done(.imported)`, then require ~5 s of quiet; hard cap ~30 s; proceed immediately on `.error`, iCloud-off, or timeout. |
| Snapshot scope | **Full**: `FeedDB` favorite+read, `PodcastDB` favorite + playback progress, `VideoDB` favorite. |
| After restore | **Delete the snapshot on success.** On failure: keep it — see §5 Failure semantics. |
| UI | Full-screen view presented during the flow; **Cassio will add the Lottie animation himself** — build the view with a placeholder slot. |
| Error handling shape | Synchronous `throws` (SwiftData's own `ModelContext.save()` surface) — no `async throws`, no custom Result type. On failure: message the user, let them decide, don't silently drop data. See §5. |

**Crash-safety invariant (this is what makes in-memory safe):** the `lastSafeguardedVersion`
key is written **only after restore completes successfully**. If the app dies mid-flow, the main
store still holds the data and the whole flow simply re-runs on next launch. Never write the key
early.

## 3. Existing mechanisms to reuse (read these files first)

| Mechanism | Where | Reuse as |
|---|---|---|
| iCloud sync status | `Database.status` in StorageLibrary (external): `idle / checking / syncing / done(.imported\|.exported) / error`, driven by `NSPersistentCloudKitContainer.eventChangedNotification` | The signal for the quiesce/timeout wait |
| Status observation pattern | `MainViewModel.observeStorageStatus()` — `MainViewModel.swift:122-141` (`withObservationTracking` re-arming loop) | Same pattern for the wait phase |
| Dedup + authority timestamps | `ModelProtocols.swift` (`ModelPrioritizable.latest/resolveDuplicates`), `FeedDB.deduplicate` `FeedDB.swift:124-149`, `PodcastDB` equivalent | Run unchanged after restore |
| Upsert-by-postId save (never touches favorite/read) | `StorageService.swift:43-64` | Unchanged — fetch phase uses it as today |
| "Run once" version gate pattern | `OnboardingCoordinator.createIfNeeded` + UserDefaults keys — `OnboardingCoordinator.swift:70-110` | Mirror for `SafeguardCoordinator.createIfNeeded` |
| Model-protocol dispatch across DB types | `MainViewModel.deduplicate()` loops `models` casting to `any ModelDuplicable.Type` — `MainViewModel.swift:143-147` | Same shape for snapshot/restore |
| Full-screen presentation | `MainView` / onboarding `fullScreenCover` wiring; `MainViewModel.showOnboarding` — `MainViewModel.swift:102-119` | Same shape for the safeguard view |
| Test isolation | `Database(models:, inMemory: true)` per `.claude/rules/testing.md` | All new tests |

`VideoDB` lives in the external YouTube library; its `ModelFavoritable` conformance is app-side
in `VideosLibrary/Sources/Videos/Model/VideoDBExtensions.swift:45`. Follow the same pattern for
its snapshot conformance. Note `VideoDB` has no `favoriteModifiedAt` and no `postId` (keys on
`videoId` instead) — see §5 Restore rules.

## 4. Architecture

**No mirror snapshot model.** The snapshot must be able to fully re-insert rows that are never
re-fetched (very old favorited posts), so the snapshot container registers the **real models**
— a `@Model` class can be registered in multiple containers; only instances bind to a context:

```swift
let snapshot = Database(
    models: [FeedDB.self, PodcastDB.self, VideoDB.self],
    appGroupID: nil,
    inMemory: true      // no CloudKit, no persistence
)
```

This gives full-record fidelity with zero schema drift (any future field lands in the snapshot
automatically) and makes re-insertion trivial via the models' existing memberwise inits
(`FeedDB.swift:24-56`, `PodcastDB.swift:24-58`, external `YouTubeLibrary/Models/VideoDB.swift:44+`).

New protocol in **MacMagazineLibrary** (mirrors `ModelFavoritable`/`ModelDuplicable`), signature
updated per §0 to a plain synchronous `throws` (propagating `ModelContext.save()`'s own error,
nothing invented on top):

```swift
public protocol ModelSafeguardable: AnyObject, PersistentModel {
    /// Detached deep copy, safe to insert into another container.
    func copied() -> Self
    /// Copies every row from `source` into `destination` (the in-memory snapshot).
    static func snapshot(from source: ModelContext?, into destination: ModelContext?) throws
    /// Re-applies snapshot rows onto `main`: re-inserts missing rows wholesale (matched by
    /// postId, or by videoId for VideoDB), merges favorite/read/progress by authority
    /// timestamp onto existing rows.
    static func restore(from snapshot: ModelContext?, into main: ModelContext?) throws
}
```

Conformances: `FeedDB`/`PodcastDB` in FeedLibrary; `VideoDB` app-side in
`VideosLibrary/Sources/Videos/Model/VideoDBExtensions.swift` (same file as its
`ModelFavoritable` conformance). Snapshot **all rows**, not just favorited/read ones —
symmetric, covers read-state on old posts, and the container lives only minutes.
`fullContent` is the only heavy field and the store holds at most a few hundred posts —
copying whole rows is fine.

> Phase 1 implemented `copied()`/`snapshot`/`restore` as a private per-model `merge(from:)`
> helper plus the three protocol members — the three merge rules (FeedDB timestamp-authority,
> PodcastDB timestamp-authority, VideoDB OR/max) genuinely differ, so `merge` is not itself a
> protocol requirement. As landed in Phase 1 these were **non-throwing** (the plan hadn't yet
> settled the throws question); **Phase 2 must add `throws` to the protocol and both
> conformances** per §0, propagating whatever `context.save()` raises, before building the
> coordinator on top of them.

## 5. The flow, step by step

```
launch → createIfNeeded (version gate) ─ nil/changed ──▶ present SafeguardView
   │                                                        │
   └─ unchanged ─▶ normal launch                            ▼
        1. SNAPSHOT   copy all FeedDB/PodcastDB/VideoDB rows from main store
                      into fresh Database(models: [...], inMemory: true)
        2. WAIT       storage.status quiesce (5 s quiet after .done(.imported)),
                      hard timeout 30 s, proceed on .error / timeout
        3. FETCH      existing pipeline untouched: FeedViewModel.getFeed()/getPodcast(),
                      videos refresh — exactly as MainView does today
        4. RESTORE    per model: match snapshot rows by postId (videoId for VideoDB),
                      re-insert missing rows wholesale, merge state via authority
                      timestamps on existing rows; then MainViewModel.deduplicate()
        5. FINALIZE   write lastSafeguardedVersion = "X.Y.Z (build)" to UserDefaults,
                      release the snapshot container, reload widget timelines, dismiss
```

**Version gate.** Current version = `CFBundleShortVersionString` + `CFBundleVersion` from
`Bundle.main` (check `MacMagazineLibrary`/Utilities for an existing version helper before
writing one — golden rule 2). Key name suggestion: `lastSafeguardedVersion`, stored like
onboarding's keys (`OnboardingCoordinator.swift:70-75`).

**Restore rules (the correctness core — get these exactly right):**
- Match rows by `postId` for `FeedDB`/`PodcastDB`, by `videoId` for `VideoDB` (confirmed
  2026-07-30 — `VideoDB` has no `postId`; mirror its existing `deduplicate()` key). Multiple
  rows with the same key may exist mid-sync — apply to **all** of them; the subsequent
  `deduplicate()` collapses them and the timestamps pick winners.
- Apply favorite/read **only if** `snapshot.favoriteModifiedAt > row.favoriteModifiedAt`
  (same for read). Equal-or-older snapshot loses: state that arrived from another device via
  iCloud during the wait is newer and must win. This is the same authority rule as
  `ModelPrioritizable.latest` — reuse its semantics, and **preserve the snapshot's original
  timestamps when writing; never stamp `Date()` during restore** (a restore is not a user action;
  stamping now would let a restored stale value beat a genuine newer remote value forever).
- `VideoDB` has no authority timestamps: restore is `favorite = snapshot.favorite || row.favorite`
  (never un-favorite) and keep the larger `current` playback position. Do **not** add timestamp
  columns to `VideoDB` — external model.
- `PodcastDB` merges `favorite` via `favoriteModifiedAt` and `current` via `progressModifiedAt`
  (`PodcastDB.swift:17-21`), same rule as favorite/read on `FeedDB`.
- A snapshot row whose key is no longer present in the main store after fetch (very old post
  outside the feed window): **re-insert the full copied row** via `copied()`. This is the
  reported loss case and the reason the snapshot holds entire records.
- Restore, then run the existing `MainViewModel.deduplicate()` — do not fork a second dedup path.

**Interplay with the existing imported→dedup observer** (`MainViewModel.swift:128-137`): it can
fire during the flow. That's safe — dedup is timestamp-driven and the snapshot is independent.
Do not suspend it.

**Failure semantics (revised 2026-07-30).** Fetch failure (offline) is **not** a flow failure:
restore still runs against whatever the store holds, flow completes, version key is written
(favorites were never at risk locally; next content fetch happens normally later).

`snapshot`/`restore` throwing (i.e. `ModelContext.save()` failing — disk full, corrupt store,
etc.) **is** a flow failure, and per §0/§2 there is no async/Result machinery here — just plain
`do/catch` around the synchronous throwing calls. On catch:
- **Do not drop the in-memory snapshot container.** Keep it alive in the coordinator's state —
  it's the only copy of pre-flow user state and dropping it defeats the entire feature.
- Transition to `.failed(message)` and show it in the UI with the underlying error's
  `localizedDescription`.
- **Ask the user what to do** rather than picking a default automatically — at minimum a
  "Retry" action that re-attempts restore against the still-live snapshot. (Exact copy/second
  action, e.g. "Continue without restoring," is a Phase 3 UI decision — flag it to Cassio then,
  don't invent it now.)
- The version key is **not** written on failure, so the flow re-runs next launch — but since the
  snapshot survived this session, a same-session retry doesn't need to re-derive it from main.

## 6. Out of scope (note in PR, don't build)

- WatchApp / widgets get no safeguard UI. Widgets: just `WidgetCenter.reloadAllTimelines()` at
  finalize (check how the app currently triggers widget reloads and mirror it).
- No re-*download* of vanished posts from the network — recovery is re-insertion from the
  snapshot copy only (§5).
- No persistent rolling backup (explicitly decided: in-memory, deleted after a *successful*
  restore only — see revised §5 Failure semantics for the failure case).
- Lottie integration itself — placeholder slot only.

## 7. Implementation phases (each = one reviewable commit, human checkpoint between)

**Phase 1 — Protocol + conformances (no UI). DONE 2026-07-30, not committed.**
`ModelSafeguardable` in `ModelProtocols.swift:16` (`copied()` :18, `snapshot` :21, `restore`
:25); conformances in `FeedDB.swift:122`, `PodcastDB.swift:89`,
`VideoDB` extension in `VideoDBExtensions.swift:54` (`@retroactive`, matching the file's
existing pattern). Tests: `FeedDBSafeguardTests.swift` (16 tests), `PodcastDBSafeguardTests.swift`
(12 tests), `VideoDBSafeguardTests.swift` (12 tests) — full restore-merge matrix (newer / older /
equal timestamp, missing-row re-insertion, duplicate rows, VideoDB OR-rule, podcast progress),
all on two `Database(models:, inMemory: true)` instances (main + snapshot). Build/test/lint all
green with real output (`BUILD SUCCEEDED`, `TEST SUCCEEDED`, 0 lint violations repo-wide).

**Before Phase 2 starts:** add `throws` to `ModelSafeguardable.snapshot`/`restore` and the three
conformances (landed as non-throwing in Phase 1 — see the note at the end of §4), and re-run the
Phase 1 test suites to confirm nothing regresses under the throwing signature.

**Phase 2 — Version gate + coordinator. DONE 2026-07-30, not yet committed.**
New `MacMagazine/Features/SafeguardLibrary/` package (deps: `MacMagazineLibrary`, `Storage`,
`Utilities` — no feature-library dependency, per the resolved §8 Open point A).
`SafeguardCoordinator.swift`: `createIfNeeded` (nil → fires; same → nil; changed/build-only →
fires) reuses `Bundle.version`/`Bundle.build` from `UtilityLibrary/Extensions/BundleExtensions.swift`
(no new version helper written); `SafeguardPhase` (`.snapshotting/.waitingForICloud/.fetching/
.restoring/.done/.failed(String)`); `run()`/`retry()`/`finalize()` — `finalize()` writes the
version key and releases the snapshot only on a successful restore, matching the crash-safety
invariant. iCloud wait uses an injected `SafeguardClock` + `SafeguardStatusSource` (a
`Sendable`-safe wrapper around `Database.status`, needed because `Database.DatabaseStatus`
itself isn't `Sendable` and broke `CheckedContinuation` compilation) — zero real sleeping in
tests. 18 new tests in `SafeguardCoordinatorTests.swift` cover the gate, the wait's quiesce/
timeout/error/off paths, and the snapshot/restore-throws → `.failed` path with the snapshot
verifiably retained. Build/test/lint independently re-verified green (not just the agent's
report). The `.throws` retrofit noted below ("Before Phase 2 starts") was completed as part of
this phase, including propagating fetch failures too — see §0 Phase 2 checkpoint.

**Phase 3 — UI + wiring. DONE 2026-07-30, not yet committed.**
`SafeguardView` (`SafeguardLibrary/Sources/SafeguardLibrary/Views/SafeguardView.swift` — theme
tokens, Dynamic Type, Lottie placeholder slot, narrated/silent branches sharing one `.task` so a
silent→failed transition doesn't remount and re-run `run()`) with the failure-state UI (Retry +
Start Over, per the resolved §0/§8 gap). `MainViewModel.makeSafeguardCoordinator()` resolves the
gate **synchronously in `init`** (not from an async `.task`), so `SceneView`'s `content` — a
switch, not an overlay — never briefly composes `MainView()` before the decision lands; verified
by reading `SceneDelegate.swift` directly, which constructs `MainViewModel` before `SceneView`
exists at all. Went through two rejected attempts before landing correctly (see §0): first, a
`.fullScreenCover`/`.sheet` overlay over `MainView` (doesn't gate anything, modals don't unmount
their presenter); second, fixing that but missing that the deep-link/onboarding presentation
modifiers on `SceneView.body` had the identical defect one level up. Both fixed via pure
composition — `mainView` (not `body`) now owns every modifier that can write to the shared store,
with `initial: true` on the `.onChange` handlers closing a real event-loss gap the second fix
surfaced. Build/test/lint independently re-verified green after every iteration, not just the
agent's pasted output: final state is 576/576 tests, 0 lint violations.

**Phase 4 — Gates + PR.**
Build (iPhone 17 Pro sim, iOS 26, skip-validation flags — see §0 on the simulator fix) + full
test plan + `swiftlint --strict`; `/ios-dod`; PR to `release/v5` titled
`fix(#304): safeguard user data across app updates`.

Every phase: read the mirrored file first, cite `path:line` in the commit/PR description,
zero new comments beyond DocC on public API.

## 8. Open points — ask Cassio before the relevant phase

- ~~**A. Module placement.**~~ **Resolved (Cassio, 2026-07-30):** `SafeguardLibrary` package —
  see §0 Phase 2 checkpoint for why the app-target recommendation didn't hold up.
- ~~**B. Orphaned favorites.**~~ **Resolved (Cassio):** snapshot holds full records precisely so
  rows missing after fetch are re-inserted wholesale — see §4/§5.
- ~~**C. Ordering vs onboarding.**~~ **Resolved (Cassio, 2026-07-30):** yes — on a true fresh
  install (no rows in `FeedDB`/`PodcastDB`/`VideoDB`), run the safeguard flow silently (snapshot
  of an empty store, wait, key write, no view) and only present `SafeguardView` when the store
  already has state to protect or a previous version key exists. Phase 3 must detect the "true
  fresh install" case (empty store, not merely "no key") to decide silent-vs-visible.
- ~~**D. Timeout values.**~~ **Accepted as implemented:** Phase 2 shipped 5 s quiesce / 30 s hard
  cap (`SafeguardCoordinator.quiesceWindow`/`hardTimeout`) with no objection raised at review —
  treat as confirmed unless real-device testing (plan §9) says otherwise.
- ~~**E. Failure-state second action.**~~ **Resolved (Cassio, 2026-07-30):** yes, a second action
  is needed — not "continue without restoring" but a "start over" that discards a partial
  snapshot and re-runs from `takeSnapshot()`. See §0 Phase 2 checkpoint for the gap this closes.
- ~~**VideoDB match key.**~~ **Resolved (Cassio, 2026-07-30):** `videoId`, not `postId` — see §0.
- ~~**Error-handling shape.**~~ **Resolved (Cassio, 2026-07-30):** synchronous `throws`, no
  async, no custom Result type; keep the snapshot on failure — see §0/§5.

## 9. Definition of Done (beyond `/ios-dod`)

- [ ] Update 5.0.1→next with favorites+read on device A, iCloud on, device B syncing: nothing lost, no duplicates.
- [ ] Same with iCloud **off**, and with airplane mode (fetch fails): flow completes, favorites intact.
- [ ] Kill the app mid-flow at every phase: next launch re-runs the flow, no key written, no loss.
- [ ] Simulate `context.save()` failing during restore: snapshot is retained, user sees a message with a retry option, no data silently dropped.
- [ ] Second launch after success: no safeguard view.
- [ ] Build-number-only bump fires the flow once.
- [ ] All restore-matrix tests green in the real `xcodebuild test` output, on the iOS 26 "iPhone 17 Pro" simulator.
