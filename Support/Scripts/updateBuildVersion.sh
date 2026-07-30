#!/bin/bash

# updateBuildVersion.sh
# Increments the app version (MARKETING_VERSION) before archiving for App Store submission.
# Usage:
#   ./updateBuildVersion.sh [patch|minor|major] [--build]
#
# Arguments:
#   patch (default) - Increments 5.1.1 -> 5.1.2
#   minor          - Increments 5.1.1 -> 5.2.0
#   major          - Increments 5.1.1 -> 6.0.0
#   --build        - Also increment the build number (4th component of CURRENT_PROJECT_VERSION)
#
# Example:
#   ./updateBuildVersion.sh              # 5.1.1 -> 5.1.2
#   ./updateBuildVersion.sh minor        # 5.1.1 -> 5.2.0
#   ./updateBuildVersion.sh patch --build # 5.1.1 -> 5.1.2 and build 5.1.1.0 -> 5.1.2.1

set -e  # Exit on error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Configuration
for file in ./MacMagazine/*.xcodeproj; do
    project_name="$(basename "${file}" .xcodeproj)"
done
PROJECT_FILE="MacMagazine/${project_name}.xcodeproj/project.pbxproj"
INCREMENT_TYPE="${1:-patch}"
INCREMENT_BUILD=false

# Check for --build flag
for arg in "$@"; do
    if [ "$arg" = "--build" ]; then
        INCREMENT_BUILD=true
    fi
done

# Validate increment type
if [[ ! "$INCREMENT_TYPE" =~ ^(patch|minor|major)$ ]]; then
    echo -e "${RED}Error: Invalid increment type '$INCREMENT_TYPE'${NC}"
    echo "Usage: $0 [patch|minor|major] [--build]"
    exit 1
fi

# Check if project file exists
if [ ! -f "$PROJECT_FILE" ]; then
    echo -e "${RED}Error: Project file not found at $PROJECT_FILE${NC}"
    exit 1
fi

echo -e "${GREEN}========================================${NC}"
echo -e "${GREEN}  MacMagazine Version Increment${NC}"
echo -e "${GREEN}========================================${NC}"
echo ""

# Extract current version from project file
CURRENT_VERSION=$(grep -m 1 "MARKETING_VERSION = " "$PROJECT_FILE" | sed 's/.*MARKETING_VERSION = \(.*\);/\1/' | tr -d ' ')

if [ -z "$CURRENT_VERSION" ]; then
    echo -e "${RED}Error: Could not find MARKETING_VERSION in project file${NC}"
    exit 1
fi

echo -e "Current version: ${YELLOW}${CURRENT_VERSION}${NC}"

# Parse version components
IFS='.' read -r -a VERSION_PARTS <<< "$CURRENT_VERSION"
MAJOR="${VERSION_PARTS[0]}"
MINOR="${VERSION_PARTS[1]:-0}"
PATCH="${VERSION_PARTS[2]:-0}"

# Increment based on type
case "$INCREMENT_TYPE" in
    major)
        MAJOR=$((MAJOR + 1))
        MINOR=0
        PATCH=0
        ;;
    minor)
        MINOR=$((MINOR + 1))
        PATCH=0
        ;;
    patch)
        PATCH=$((PATCH + 1))
        ;;
esac

NEW_VERSION="${MAJOR}.${MINOR}.${PATCH}"
echo -e "New version:     ${GREEN}${NEW_VERSION}${NC}"
echo ""

# Create backup
BACKUP_FILE="${PROJECT_FILE}.backup"
cp "$PROJECT_FILE" "$BACKUP_FILE"
echo -e "${YELLOW}Created backup: ${BACKUP_FILE}${NC}"

# Update all MARKETING_VERSION occurrences
# Use sed with a temporary file for compatibility
if [[ "$OSTYPE" == "darwin"* ]]; then
    # macOS
    sed -i '' "s/MARKETING_VERSION = ${CURRENT_VERSION};/MARKETING_VERSION = ${NEW_VERSION};/g" "$PROJECT_FILE"
else
    # Linux
    sed -i "s/MARKETING_VERSION = ${CURRENT_VERSION};/MARKETING_VERSION = ${NEW_VERSION};/g" "$PROJECT_FILE"
fi

# Count how many replacements were made
REPLACEMENT_COUNT=$(grep -c "MARKETING_VERSION = ${NEW_VERSION};" "$PROJECT_FILE" || true)
echo -e "${GREEN}✓ Updated MARKETING_VERSION in ${REPLACEMENT_COUNT} locations${NC}"

# CURRENT_PROJECT_VERSION mirrors MARKETING_VERSION as major.minor.patch.build
CURRENT_BUNDLE_VERSION=$(grep -m 1 "CURRENT_PROJECT_VERSION = " "$PROJECT_FILE" | sed 's/.*CURRENT_PROJECT_VERSION = \(.*\);/\1/' | tr -d ' ')

if [ -n "$CURRENT_BUNDLE_VERSION" ]; then
    IFS='.' read -r -a BUNDLE_PARTS <<< "$CURRENT_BUNDLE_VERSION"
    BUILD="${BUNDLE_PARTS[3]:-0}"

    if [ "$INCREMENT_BUILD" = true ]; then
        echo ""
        echo -e "${YELLOW}Incrementing build number...${NC}"
        BUILD=$((BUILD + 1))
    fi

    NEW_BUNDLE_VERSION="${MAJOR}.${MINOR}.${PATCH}.${BUILD}"
    echo -e "Current build: ${YELLOW}${CURRENT_BUNDLE_VERSION}${NC}"
    echo -e "New build:     ${GREEN}${NEW_BUNDLE_VERSION}${NC}"

    if [[ "$OSTYPE" == "darwin"* ]]; then
        sed -i '' "s/CURRENT_PROJECT_VERSION = ${CURRENT_BUNDLE_VERSION};/CURRENT_PROJECT_VERSION = ${NEW_BUNDLE_VERSION};/g" "$PROJECT_FILE"
    else
        sed -i "s/CURRENT_PROJECT_VERSION = ${CURRENT_BUNDLE_VERSION};/CURRENT_PROJECT_VERSION = ${NEW_BUNDLE_VERSION};/g" "$PROJECT_FILE"
    fi

    BUNDLE_REPLACEMENT_COUNT=$(grep -c "CURRENT_PROJECT_VERSION = ${NEW_BUNDLE_VERSION};" "$PROJECT_FILE" || true)
    echo -e "${GREEN}✓ Updated CURRENT_PROJECT_VERSION in ${BUNDLE_REPLACEMENT_COUNT} locations${NC}"
else
    echo -e "${RED}Warning: Could not find CURRENT_PROJECT_VERSION${NC}"
fi

echo ""
echo -e "${GREEN}========================================${NC}"
echo -e "${GREEN}Version increment complete!${NC}"
echo -e "${GREEN}========================================${NC}"
echo ""
echo -e "Summary:"
echo -e "  Version: ${YELLOW}${CURRENT_VERSION}${NC} → ${GREEN}${NEW_VERSION}${NC}"
if [ -n "$CURRENT_BUNDLE_VERSION" ]; then
    echo -e "  Build:   ${YELLOW}${CURRENT_BUNDLE_VERSION}${NC} → ${GREEN}${NEW_BUNDLE_VERSION}${NC}"
fi
echo ""
echo -e "${YELLOW}Next steps:${NC}"
echo -e "  1. Review changes: git diff $PROJECT_FILE"
echo -e "  2. Commit: git commit -am \"chore: bump version to ${NEW_VERSION}\""
echo -e "  3. Tag: git tag ${NEW_VERSION}"
echo -e "  4. Archive in Xcode"
echo ""
echo -e "${YELLOW}To restore backup if needed:${NC}"
echo -e "  mv ${BACKUP_FILE} ${PROJECT_FILE}"
echo ""
