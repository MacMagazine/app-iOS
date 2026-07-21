# Git workflow

## Branches

- `feature/<description>`, `fix/<description>`, `hotfix/<description>`, `docs/<description>`, `refactor/<description>`
- Branch off `release/v5`; releases land on `release/v5`.
- One logical change per branch; keep diffs reviewable.

## Commits / PR titles

Conventional Commits format, enforced by CI:

```
feat(scope): description
fix(#123): description    <- bug fixes MUST include the issue number
```

Types: `feat`, `fix`, `docs`, `style`, `refactor`, `perf`, `test`, `chore`, `build`, `ci`, `revert`

Commit trailer:

```
Co-Authored-By: Claude <noreply@anthropic.com>
```

## The gate (before every commit)

1. Build succeeds (iPhone 17 Pro simulator, skip-validation flags).
2. All tests pass (`-testPlan MacMagazine`).
3. `swiftlint lint --config ./.swiftlint.yml --strict` — zero violations.
4. Diff reviewed: scoped to the task, no obvious comments, no debug code.

## Auto-commit and push (project policy)

After implementation is complete and all quality gates pass, **commit and push automatically**
without waiting to be asked:

```bash
git add <specific changed files>     # never `git add -A` blindly
git commit -m "feat(scope): brief description

Co-Authored-By: Claude <noreply@anthropic.com>"
git push -u origin <branch>
```

## Blocked regardless (PreToolUse hook + settings.json deny)

- `git push --force` / `-f` — use `--force-with-lease` consciously, on your own branch only.
- `git reset --hard` — loses work; checkpoint first.

## Never commit

Secrets, `GoogleService-Info.plist`, `.env`, `xcuserdata`, build artifacts (see `.gitignore`).
