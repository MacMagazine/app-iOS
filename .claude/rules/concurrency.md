# Concurrency — Swift 6.2, structured only

The project builds with Swift 6.2. Swift Concurrency is the only approved model for new code.

## Required patterns

- **ViewModels are `@MainActor @Observable`.** UI-facing state mutates on the main actor only.
- **Shared mutable state lives in an `actor`.** Don't guard it with locks or queues.
- **Everything crossing a concurrency boundary is `Sendable`.** Models are `struct` + `Sendable` where possible.
- **Async all the way.** New async APIs use `async`/`async throws`. Use `async let` and `TaskGroup` for structured concurrency.
- **Tie tasks to lifecycle.** Prefer `.task { }` / `.task(id:)` view modifiers over free-floating `Task { }`. Never `Task.detached` without justification.
- Handle cancellation: catch `CancellationError` where work can be cancelled mid-flight.

## Legacy (migrate when touching, never write new)

- `DispatchQueue` / any GCD — legacy. When you touch code that uses it, migrate to `async/await` or `@MainActor`. (The PostToolUse hook warns but does not block, because legacy files still contain it.)
- Completion handlers — wrap legacy callbacks with `withCheckedThrowingContinuation` at the boundary, expose `async`.

## Banned (the PostToolUse hook blocks these)

- `@unchecked Sendable` — if you reach for it, the type is modeled wrong.
- `try!`, `as!` — see swift-style.md.

## Example shape

```swift
@MainActor
@Observable
final class FeatureViewModel {
    private(set) var items: [Item] = []
    private let service: FeatureService   // protocol, injected

    init(service: FeatureService) { self.service = service }

    func load() async {
        do { items = try await service.fetch() }
        catch is CancellationError { }
        catch { /* surface to state */ }
    }
}
```
