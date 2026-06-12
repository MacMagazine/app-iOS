# Swift Style — naming, optionals, lint, comments

Base: Ray Wenderlich Swift Style Guide + SwiftLint strict mode (the PostToolUse hook lints
every edited Swift file with `./.swiftlint.yml --strict`).

## Naming

- Types `UpperCamelCase`; members/vars `lowerCamelCase`.
- Booleans read as assertions: `isLoading`, `hasMore`, `canSubmit`.
- Suffix by role: `…ViewModel`, `…View`, `…Manager`, `…Service`, `…DB` (SwiftData models).
- Match the EXACT naming conventions, parameter ordering, and data types of the surrounding code.

## Files & layout

- One primary type per file; file name == type name.
- `// MARK: -` between sections.
- Keep functions short; extract intent-named helpers.
- `private` by default; widen access only when crossing a module boundary (then `public` with intent).

## Optionals & errors

- **No force-unwrap (`!`), no force-cast (`as!`), no force-try (`try!`)** in production code. Use `guard let`, `if let`, `??`, `throws`.
- `guard` for early exit; keep the happy path un-indented.
- Don't swallow errors — handle, rethrow, or surface to the ViewModel's state.

## SwiftLint configuration highlights

```bash
swiftlint lint --config ./.swiftlint.yml --strict
```

| Rule | Severity | Note |
|------|----------|------|
| `force_cast`, `force_try`, `force_unwrapping` | Warning (error under --strict) | Use safe alternatives |
| `sorted_imports` | Error | Imports must be alphabetical |
| `line_length` | Warning at 200 | Keep lines readable |
| `prefer_let_before_case` | Error | `case let .foo(x)` not `case .foo(let x)` |
| `todo` | Warning | Use sparingly |

## Comments — zero tolerance for obvious comments

Before every commit, review ALL changed code. Remove any comment that:
- Explains what the code does (the name already says it)
- Restates the type, structure, or parameter
- Adds docstrings to simple/obvious methods

Keep only: `// MARK: -`, `///` DocC on public API, complex algorithms, non-obvious business rules with a "why", `// TODO:`.

## API design

- Make illegal states unrepresentable: prefer an `enum` state over scattered booleans.
- Prefer composition over inheritance.
- No debug code in production — never commit `print` statements or placeholder closures.
- Don't over-engineer: three similar lines beat a premature abstraction.
