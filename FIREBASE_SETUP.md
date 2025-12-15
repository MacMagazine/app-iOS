# Firebase Configuration Setup

## Overview
The `GoogleService-Info.plist` file contains sensitive API keys and is excluded from the repository for security reasons.

## Local Development Setup

1. Ensure you have the real `GoogleService-Info.plist` file in:
   ```
   MacMagazine/MacMagazine/Resources/GoogleService-Info.plist
   ```

2. This file is gitignored and will not be committed to the repository.

3. A template file (`GoogleService-Info-template.plist`) is available in the same directory for reference.

## Bitrise CI/CD Setup

To enable Firebase Analytics in Bitrise builds:

### Step 1: Upload the Secure File

1. Go to your Bitrise app dashboard
2. Navigate to **Workflow Editor** → **Code Signing & Files**
3. Under **Generic File Storage**, click **Upload file**
4. Upload your `GoogleService-Info.plist` file
5. Set the environment variable key as: `GOOGLE_SERVICE_INFO_PLIST`
6. Note the download URL that Bitrise generates

### Step 2: Add a Script Step to Your Workflow

Add a **Script** step before your Xcode build step:

```yaml
- script@1:
    title: Download GoogleService-Info.plist
    inputs:
    - content: |
        #!/usr/bin/env bash
        set -ex

        # Create the Resources directory if it doesn't exist
        mkdir -p "$BITRISE_SOURCE_DIR/MacMagazine/MacMagazine/Resources"

        # Download the file from Generic File Storage
        envman add --key GOOGLE_SERVICE_INFO_PATH --value "$BITRISE_SOURCE_DIR/MacMagazine/MacMagazine/Resources/GoogleService-Info.plist"

        # Copy from the downloaded location
        cp "$BITRISEIO_GOOGLE_SERVICE_INFO_PLIST_URL" "$GOOGLE_SERVICE_INFO_PATH"

        echo "GoogleService-Info.plist downloaded successfully"
```

### Alternative: Using Bitrise CLI

If you prefer, you can also use the `file-downloader` step:

```yaml
- file-downloader@1:
    inputs:
    - source: $BITRISEIO_GOOGLE_SERVICE_INFO_PLIST_URL
    - destination: "$BITRISE_SOURCE_DIR/MacMagazine/MacMagazine/Resources/GoogleService-Info.plist"
```

### Step 3: Verify

After setting up:
1. Trigger a build on Bitrise
2. Check the build logs to ensure the file is downloaded successfully
3. Verify that Firebase Analytics is working in the archived build

## Security Notes

- Never commit the actual `GoogleService-Info.plist` to the repository
- Keep the real file only in secure locations (your local machine and Bitrise's secure storage)
- The template file is safe to commit as it contains no real credentials
- Team members who don't need Analytics locally can work without the real file

## Troubleshooting

If Analytics is not working:
- Verify the file exists at the correct path
- Check that all keys in the plist match the Firebase console
- Ensure `IS_ANALYTICS_ENABLED` is set to `true` if needed
- Review Bitrise logs for download errors
