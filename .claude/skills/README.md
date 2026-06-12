# Skills Quick Reference

## Project Skills (this folder)

### Workflow

| Command | Purpose | When to Use |
|---------|---------|-------------|
| `/ios-start` | Pre-flight checklist | Before writing any code |
| `/ios-implement` | Complete feature implementation | New features, major additions |
| `/ios-fix` | Bug fixes and refactoring | Fixing bugs, tech debt, optimization |
| `/ios-dod` | Definition of Done | Before marking any task complete |

### Reference

| Command | Purpose | When to Use |
|---------|---------|-------------|
| `/ios-design-guidelines` | Theme system, cards, typography | Creating UI, choosing cards |
| `/ios-sanity-check` | Codebase health audit | Periodically, before releases |

## Built-in Skills (Claude Code)

| Command | Purpose |
|---------|---------|
| `/code-review` | Review the current diff for bugs and cleanups |
| `/simplify` | Review changed code for reuse, quality, efficiency |
| `/verify` | Run the app and observe behavior to confirm a change |
| `/security-review` | Security review of pending branch changes |

## Project Agents (`.claude/agents/`)

| Agent | Purpose |
|-------|---------|
| `ios-principal-engineer` | Full implementation tasks enforcing all rules |
| `swift-code-reviewer` | Rigorous review of Swift/SwiftUI changes (read-only) |
| `architecture-guardian` | Module-boundary and system-compliance checks (read-only) |
| `test-runner` | Build + test with real, pasted results (read-only) |

## Decision Tree

```
Need to implement something?
├── New feature module? ──────── /ios-implement
├── Small enhancement? ──────── /ios-start + direct implementation
├── Bug fix? ─────────────────── /ios-fix
├── Code review? ─────────────── /code-review or swift-code-reviewer agent
├── Boundary check? ──────────── architecture-guardian agent
├── Do tests pass? ───────────── test-runner agent
├── Health check? ────────────── /ios-sanity-check
└── Before marking done? ─────── /ios-dod
```

## Skill Integration

```
/ios-implement
    ├── Invokes: /ios-start (pre-flight)
    ├── References: /ios-design-guidelines (for UI)
    └── Invokes: /ios-dod (completion)

/ios-fix
    ├── Investigation phase
    └── Invokes: /ios-dod (completion)
```

Detailed conventions live in `.claude/rules/` — skills point there instead of duplicating.
