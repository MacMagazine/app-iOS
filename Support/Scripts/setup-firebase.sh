#!/bin/bash

# Setup script for local Firebase configuration
# This copies the template file to the Resources directory for local development

set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
TEMPLATE_FILE="$SCRIPT_DIR/GoogleService-Info-template.plist"
DEST_FILE="$PROJECT_ROOT/MacMagazine/MacMagazine/Resources/GoogleService-Info.plist"

echo "🔧 Setting up Firebase configuration for local development..."

# Check if template exists
if [ ! -f "$TEMPLATE_FILE" ]; then
    echo "❌ Template file not found at: $TEMPLATE_FILE"
    exit 1
fi

# Check if destination file already exists
if [ -f "$DEST_FILE" ]; then
    echo "⚠️  GoogleService-Info.plist already exists at: $DEST_FILE"
    read -p "Do you want to overwrite it? (y/N): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo "Skipping..."
        exit 0
    fi
fi

# Copy template to destination
cp "$TEMPLATE_FILE" "$DEST_FILE"

echo "✅ Firebase template copied to: $DEST_FILE"
echo ""
echo "📝 Next steps:"
echo "   1. If you have real Firebase credentials, replace the placeholder values in:"
echo "      MacMagazine/MacMagazine/Resources/GoogleService-Info.plist"
echo "   2. The file is gitignored, so your credentials won't be committed"
echo "   3. Firebase will be disabled if template values are detected"
echo ""
