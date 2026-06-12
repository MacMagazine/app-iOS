#!/usr/bin/env bash
# Stop hook — fires when Claude finishes responding.
# Non-blocking reminder of the Definition of Done. Never blocks (exit 0).
set -uo pipefail
cat >/dev/null   # drain stdin

cat >&2 <<'EOF'
────────────────────────────────────────────────────────
✅ Before calling this done, verify (do not assume):
   • xcodebuild build  (iPhone 17 Pro sim, skip-validation flags) → succeeds
   • xcodebuild test   (-testPlan MacMagazine)                    → passes
   • swiftlint lint --config ./.swiftlint.yml --strict            → zero violations
   • no obvious comments; no force-unwrap/try!/as!
   • code mirrors the nearest sibling feature's patterns
   Run /ios-dod for the full checklist.
────────────────────────────────────────────────────────
EOF
exit 0
