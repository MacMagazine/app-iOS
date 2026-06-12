---
name: ios-implement
description: Complete feature-implementation workflow for MacMagazine with pattern matching, review gates, and quality verification. Use when implementing a new feature or module, adding a view/ViewModel/navigation flow, or when the user says "implement", "build", "add feature", or "create a screen". For bug fixes use ios-fix instead.
---

# iOS Feature Implementation

Use this skill when:
- Implementing a new feature module from scratch
- Adding a major feature to an existing module
- Creating navigation flows, views, and ViewModels

**For simple bug fixes use `/ios-fix`. For small UI tweaks use direct implementation.**

---

## Workflow: 4 Phases

### Phase 1: Pre-Flight (NO CODE YET)

1. **Run `/ios-start`** to complete the pre-flight checklist
2. **Identify the most similar existing feature** to use as reference:
   - NewsLibrary — Feed-based content with category cards
   - PodcastLibrary — Playback state, player manager, audio cards
   - VideosLibrary — YouTube integration, glass cards
   - SearchLibrary — Two-phase search, NLP pipeline, mixed results
   - SettingsLibrary — Forms, preferences, SwiftData

3. **Read existing code** from the similar feature:
   - Main view file
   - ViewModel
   - Card/list rendering
   - Package.swift dependencies

4. **Document patterns found** — navigation, ViewModel state, card system usage, theme access

### Phase 2: Planning

Create implementation plan showing:
1. **Files to create/modify** — with which existing pattern each follows
2. **Components to reuse** — existing cards, views, utilities
3. **Module structure** — where files go in the package
4. **Dependencies** — what Package.swift needs
5. **Testing strategy** — what to test and how

### Phase 3: Implementation (Step by Step)

For each component:

#### ViewModel
- Uses `@Observable` (not `ObservableObject`)
- Clear separation of concerns
- Proper error handling
- Uses existing services (Database, Network)

#### Views
- Theme via `@Environment(\.theme)`
- Card system for content rendering (NewsCard, AdaptivePodcastCardView, GlassCardView)
- `ZStack` with theme background pattern
- Proper navigation (`navigationDestination`, sheets)

#### Tests
- Swift Testing framework (`@Suite`, `@Test`, `#expect`)
- In-memory database for SwiftData tests
- Cover ViewModels, services, and data transformations

### Phase 4: Definition of Done

Run `/ios-dod` to verify all quality criteria.

---

## Enforcement Rules

### FAIL Conditions — Start Over If You:
- Write code before reading existing patterns
- Create new utilities that already exist
- Bypass the card system (use GlassCardView directly for news instead of NewsCard)
- Use hardcoded colors instead of theme tokens
- Skip quality gates (build, test, lint)

### SUCCESS Conditions
- Read existing code before implementing
- Pattern Analysis completed
- All existing patterns reused
- Quality gates passing
- Committed with Conventional Commits format
