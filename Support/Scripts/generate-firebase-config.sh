#!/bin/bash

# CI/CD script to generate GoogleService-Info.plist from environment variables
# This script is meant to be run in your CI/CD pipeline (Bitrise, GitHub Actions, etc.)

set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
DEST_FILE="$PROJECT_ROOT/MacMagazine/MacMagazine/Resources/GoogleService-Info.plist"

echo "🔧 Generating GoogleService-Info.plist from environment variables..."

# Check if required environment variables are set
if [ -z "$FIREBASE_API_KEY" ]; then
    echo "❌ FIREBASE_API_KEY environment variable is not set"
    exit 1
fi

if [ -z "$FIREBASE_GCM_SENDER_ID" ]; then
    echo "❌ FIREBASE_GCM_SENDER_ID environment variable is not set"
    exit 1
fi

if [ -z "$FIREBASE_PROJECT_ID" ]; then
    echo "❌ FIREBASE_PROJECT_ID environment variable is not set"
    exit 1
fi

if [ -z "$FIREBASE_STORAGE_BUCKET" ]; then
    echo "❌ FIREBASE_STORAGE_BUCKET environment variable is not set"
    exit 1
fi

if [ -z "$FIREBASE_GOOGLE_APP_ID" ]; then
    echo "❌ FIREBASE_GOOGLE_APP_ID environment variable is not set"
    exit 1
fi

if [ -z "$FIREBASE_BUNDLE_ID" ]; then
    echo "❌ FIREBASE_BUNDLE_ID environment variable is not set"
    exit 1
fi

# Create the GoogleService-Info.plist file
cat > "$DEST_FILE" << EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
	<key>API_KEY</key>
	<string>$FIREBASE_API_KEY</string>
	<key>GCM_SENDER_ID</key>
	<string>$FIREBASE_GCM_SENDER_ID</string>
	<key>PLIST_VERSION</key>
	<string>1</string>
	<key>BUNDLE_ID</key>
	<string>$FIREBASE_BUNDLE_ID</string>
	<key>PROJECT_ID</key>
	<string>$FIREBASE_PROJECT_ID</string>
	<key>STORAGE_BUCKET</key>
	<string>$FIREBASE_STORAGE_BUCKET</string>
	<key>IS_ADS_ENABLED</key>
	<false></false>
	<key>IS_ANALYTICS_ENABLED</key>
	<true></true>
	<key>IS_APPINVITE_ENABLED</key>
	<false></false>
	<key>IS_GCM_ENABLED</key>
	<false></false>
	<key>IS_SIGNIN_ENABLED</key>
	<false></false>
	<key>GOOGLE_APP_ID</key>
	<string>$FIREBASE_GOOGLE_APP_ID</string>
</dict>
</plist>
EOF

echo "✅ GoogleService-Info.plist generated successfully at: $DEST_FILE"
echo ""
echo "Generated with:"
echo "  - API_KEY: ${FIREBASE_API_KEY:0:10}..."
echo "  - PROJECT_ID: $FIREBASE_PROJECT_ID"
echo "  - GOOGLE_APP_ID: ${FIREBASE_GOOGLE_APP_ID:0:15}..."
echo "  - BUNDLE_ID: ${FIREBASE_BUNDLE_ID:0:10}..."
echo ""
