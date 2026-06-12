#!/usr/bin/env bash
# PostToolUse hook (matcher: Write|Edit).
# Lints the edited Swift file deterministically with the project SwiftLint config.
# Self-skips (with a notice) if swiftlint isn't installed, so it never hard-fails the loop.
# Exit 2 surfaces violations back to Claude as feedback to fix immediately.
set -uo pipefail

INPUT="$(cat)"

if command -v python3 >/dev/null 2>&1; then
  FILE="$(printf '%s' "$INPUT" | python3 -c 'import sys,json;
try:
    d=json.load(sys.stdin); ti=d.get("tool_input",{}); print(ti.get("file_path") or ti.get("path") or "")
except Exception:
    print("")' 2>/dev/null)"
else
  FILE="$(printf '%s' "$INPUT" | grep -oE '"file_path"[[:space:]]*:[[:space:]]*"[^"]+"' | head -1 | sed -E 's/.*:"([^"]+)"/\1/')"
fi

case "$FILE" in
  *.swift) : ;;
  *) exit 0 ;;
esac
[ -f "$FILE" ] || exit 0

PROJECT_DIR="${CLAUDE_PROJECT_DIR:-$(pwd)}"

# Hard bans — block immediately (see .claude/rules/swift-style.md & concurrency.md).
if grep -nE '(^|[^/"])\btry!|(^|[^/"])[[:space:]]as![[:space:]]|@unchecked Sendable' "$FILE" >/dev/null 2>&1; then
  {
    echo "🛑 Banned pattern in $FILE (see .claude/rules/swift-style.md & .claude/rules/concurrency.md):"
    grep -nE 'try!|[[:space:]]as![[:space:]]|@unchecked Sendable' "$FILE" | sed 's/^/   /'
    echo "   Fix: remove force-try/force-cast, model Sendable correctly."
  } >&2
  exit 2
fi

# Soft warnings — legacy patterns; migrate when touching, don't block existing code.
if grep -nE 'DispatchQueue\.(main|global)' "$FILE" >/dev/null 2>&1; then
  echo "⚠️  DispatchQueue found in $FILE — GCD is legacy here. Migrate to async/await or @MainActor when touching this code (.claude/rules/concurrency.md)." >&2
fi
if grep -nE '[A-Za-z0-9_\)\]]\![^=]' "$FILE" | grep -vE '//' >/dev/null 2>&1; then
  echo "⚠️  Possible force-unwrap in $FILE — confirm it's not '!' on an optional. Review .claude/rules/swift-style.md." >&2
fi

# Lint with the project config (strict). Blocks on real violations so Claude fixes them.
if command -v swiftlint >/dev/null 2>&1; then
  if ! swiftlint lint --config "$PROJECT_DIR/.swiftlint.yml" --strict --quiet "$FILE" >/tmp/_mm_lint 2>&1; then
    { echo "🛑 swiftlint --strict failed for $FILE:"; sed 's/^/   /' /tmp/_mm_lint; } >&2
    exit 2
  fi
else
  echo "ℹ️  swiftlint not installed — skipped lint. Install: brew install swiftlint" >&2
fi

exit 0
