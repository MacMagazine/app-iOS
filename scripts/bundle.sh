#!/bin/sh
if [[ "$TRAVIS_PULL_REQUEST" != "false" ]]; then
  echo "This is a pull request. No deployment will be done."
  exit 0
fi
if [[ "$TRAVIS_BRANCH" != "$BRANCH" ]]; then
  echo "Testing on a branch other than master. No deployment will be done."
  exit 0
fi

security list-keychains -s ios-build.keychain

echo "*********************"
echo "*     Archiving     *"
echo "*********************"
xcodebuild archive -project "$APP_NAME".xcodeproj -scheme "$APP_NAME" -allowProvisioningUpdates -destination 'generic/platform=iOS' -archivePath $APP_NAME DEVELOPMENT_TEAM="$COMPANY_ID"

echo "**********************"
echo "*     Exporting      *"
echo "**********************"
xcodebuild -exportArchive -allowProvisioningUpdates -archivePath $APP_NAME.xcarchive -exportPath . -exportOptionsPlist scripts/ExportOptions.plist
