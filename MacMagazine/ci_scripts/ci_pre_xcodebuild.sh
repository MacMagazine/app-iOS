#!/bin/bash

# ci_pre_xcodebuild.sh
# This script runs before xcodebuild in Xcode Cloud

set -e

echo "=== Running pre-xcodebuild script ==="

# Set environment variable to skip package plugin validation
# This allows SwiftLint plugin to run without manual trust
export DISABLE_PACKAGE_PLUGIN_VALIDATION=YES

echo "DISABLE_PACKAGE_PLUGIN_VALIDATION=$DISABLE_PACKAGE_PLUGIN_VALIDATION"

echo "=== Pre-xcodebuild script completed ==="
