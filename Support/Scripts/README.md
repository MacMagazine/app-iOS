# Firebase Configuration

This directory contains configuration files and scripts for Firebase integration.

## Overview

The `GoogleService-Info.plist` file contains sensitive API keys and is excluded from the repository for security reasons. The app gracefully handles missing Firebase configuration.

## Setup for Local Development

1. **Copy the template file:**
   ```bash
   ./Support/Scripts/setup-firebase.sh
   ```

   Or manually:
   ```bash
   cp Support/Scripts/GoogleService-Info-template.plist MacMagazine/MacMagazine/Resources/GoogleService-Info.plist
   ```

2. **For Firebase Analytics (Optional):**
   - Replace placeholder values in `MacMagazine/MacMagazine/Resources/GoogleService-Info.plist` with real credentials
   - The file is gitignored and won't be committed
   - If you keep placeholder values, Firebase will be automatically disabled

3. **Add to Xcode (One-time setup):**
   - Open `MacMagazine.xcodeproj` in Xcode
   - Right-click `Resources` folder → "Add Files to MacMagazine..."
   - Select `GoogleService-Info.plist` from Resources
   - **Uncheck** "Copy items if needed"
   - **Check** "MacMagazine" target
   - Commit the updated `project.pbxproj`

## CI/CD Setup (Bitrise)

### Option 1: Using Environment Variables (Recommended)

1. **Set environment variables in Bitrise:**
   - Go to Workflow Editor → Secrets
   - Add the following secrets:
     - `FIREBASE_API_KEY`
     - `FIREBASE_GCM_SENDER_ID`
     - `FIREBASE_PROJECT_ID`
     - `FIREBASE_STORAGE_BUCKET`
     - `FIREBASE_GOOGLE_APP_ID`
     - `FIREBASE_BUNDLE_ID`

2. **Add script step BEFORE Xcode build:**
   ```yaml
   - script@1:
       title: Generate Firebase Configuration
       inputs:
       - content: |
           #!/usr/bin/env bash
           set -ex
           ./Support/Scripts/generate-firebase-config.sh
   ```

### Option 2: Using Secure File Storage

1. **Upload file to Bitrise:**
   - Navigate to Code Signing & Files → Generic File Storage
   - Upload your `GoogleService-Info.plist`
   - Note the environment variable (e.g., `$BITRISEIO_GOOGLE_SERVICE_INFO_PLIST_URL`)

2. **Add script step BEFORE Xcode build:**
   ```yaml
   - script@1:
       title: Download Firebase Configuration
       inputs:
       - content: |
           #!/usr/bin/env bash
           set -ex

           DEST="$BITRISE_SOURCE_DIR/MacMagazine/MacMagazine/Resources/GoogleService-Info.plist"

           if [ -n "$BITRISEIO_GOOGLE_SERVICE_INFO_PLIST_URL" ]; then
               echo "Downloading GoogleService-Info.plist..."
               curl -o "$DEST" "$BITRISEIO_GOOGLE_SERVICE_INFO_PLIST_URL"
               echo "✅ Downloaded successfully"
           else
               echo "⚠️ No Firebase config URL set"
               exit 1
           fi
   ```

## How It Works

1. **Template**: Stored in `Support/Scripts/GoogleService-Info-template.plist` (safe to commit)
2. **Local**: Copy template to Resources, optionally replace with real credentials
3. **CI/CD**: Generate from environment variables or download from secure storage
4. **Runtime**: App checks if file exists and has valid credentials before initializing Firebase
5. **Safety**: Missing or invalid config = app runs fine, Firebase disabled

## Security Notes

- ✅ Template file is safe to commit (contains no real credentials)
- ✅ Real `GoogleService-Info.plist` is gitignored
- ✅ API keys stored as Bitrise secrets or secure file storage
- ✅ App gracefully handles missing configuration

## Troubleshooting

### App won't build locally
- Run `./Support/Scripts/setup-firebase.sh` to create the config file
- Ensure `GoogleService-Info.plist` is added to Xcode project

### Firebase not working on Bitrise
- Verify environment variables are set (Option 1) OR file is uploaded (Option 2)
- Check script runs BEFORE Xcode build step
- Review build logs for generation/download errors

### Firebase disabled locally
- Check file contains real credentials (not "YOUR_API_KEY_HERE")
- App will log why Firebase wasn't initialized
