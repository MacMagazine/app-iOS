#!/bin/bash

# ci_post_clone.sh
# This script runs after Xcode Cloud clones the repository
# It configures the environment for the build

set -e

echo "=== Running post-clone script ==="

# Trust SwiftLint plugin from SwiftLintPlugins package
# This is required because Xcode Cloud doesn't automatically trust SPM plugins
echo "Configuring package plugin trust..."

defaults write com.apple.dt.Xcode IDESkipPackagePluginFingerprintValidatation -bool YES

echo "=== Post-clone script completed ==="
