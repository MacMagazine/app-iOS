#!/bin/bash

# ci_post_clone.sh
# Runs after Xcode Cloud clones the repository

set -e

echo "=== Post-clone: Resolving packages with plugin validation disabled ==="

cd "$CI_PRIMARY_REPOSITORY_PATH/MacMagazine"

# Resolve package dependencies while skipping plugin validation
xcodebuild -resolvePackageDependencies \
    -project MacMagazine.xcodeproj \
    -scheme MacMagazine \
    -skipPackagePluginValidation \
    -skipMacroValidation

echo "=== Package resolution completed ==="
