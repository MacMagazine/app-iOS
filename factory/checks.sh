#!/usr/bin/env bash
# The repo's checks. Exit 0 only when the branch is fit to review.
#
# The gate runs this script from the main checkout with the job's worktree as
# the working directory. Keep it fast, deterministic and non-interactive: no
# watch modes, no prompts, nothing that rewrites files.
set -euo pipefail

FIREBASE_PLIST="MacMagazine/MacMagazine/Resources/GoogleService-Info.plist"
if [ ! -f "$FIREBASE_PLIST" ]; then
  cp Support/Scripts/GoogleService-Info-template.plist "$FIREBASE_PLIST"
fi

# CLAUDE.md mandates the iPhone 17 Pro simulator; fall back to the nearest
# installed iPhone when this machine's Xcode doesn't ship it.
available="$(xcrun simctl list devices available)"
SIM_DEVICE=""
for candidate in "iPhone 17 Pro" "iPhone 17" "iPhone 18 Pro"; do
  if grep -q "^ *${candidate} (" <<<"$available"; then
    SIM_DEVICE="$candidate"
    break
  fi
done
if [ -z "$SIM_DEVICE" ]; then
  echo "No supported iPhone simulator installed (wanted iPhone 17 Pro)." >&2
  exit 1
fi
echo "Using simulator: $SIM_DEVICE"

swiftlint lint --config ./.swiftlint.yml --strict

xcodebuild test \
  -project MacMagazine/MacMagazine.xcodeproj \
  -scheme MacMagazine \
  -testPlan MacMagazine \
  -destination "platform=iOS Simulator,name=${SIM_DEVICE}" \
  -skipPackagePluginValidation \
  -skipMacroValidation \
  -quiet
