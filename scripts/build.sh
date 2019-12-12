#!/bin/sh
if [[ "$TRAVIS_PULL_REQUEST" != "false" ]]; then
  echo "This is a pull request. No deployment will be done."
  exit 0
fi
security list-keychains -s ios-build.keychain
rm ~/Library/MobileDevice/Provisioning\ Profiles/$PROFILE_NAME.mobileprovision 
mkdir -p ~/Library/MobileDevice/Provisioning\ Profiles/
cp ./scripts/profile/$PROFILE_NAME.mobileprovision ~/Library/MobileDevice/Provisioning\ Profiles/
echo "*********************"
echo "*     Archiving     *"
echo "*********************"
xcrun agvtool next-version -all
xcrun xcodebuild -workspace MacMagazine.xcworkspace -scheme MacMagazine\ Stg -archivePath $ARCHIVE_NAME.xcarchive archive
echo "**********************"
echo "*     Exporting      *"
echo "**********************"
xcrun xcodebuild -exportArchive -archivePath $ARCHIVE_NAME.xcarchive -exportPath . -exportOptionsPlist ExportOptions.plist
echo "************************************"
echo "*     Upload to iTunesConnect      *"
echo "************************************"
ln -s "/Applications/Xcode.app/Contents/Applications/Application Loader.app/Contents/Frameworks/ITunesSoftwareService.framework/Support/altool" /usr/local/bin/altool
ln -s "/Applications/Xcode.app/Contents/Applications/Application Loader.app/Contents/itms" /usr/local/bin/itms #itms is needed, otherwise altool will not work correctly
altool --upload-app -f "$IPA_NAME.ipa" -u $USERNAME -p $PASSWORD