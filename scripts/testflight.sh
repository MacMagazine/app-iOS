#!/bin/sh
if [[ "$TRAVIS_PULL_REQUEST" != "false" ]]; then
  echo "This is a pull request. No deployment will be done."
  exit 0
fi

if [[ "$TRAVIS_BRANCH" != "release/4.0" ]]; then
  echo "Testing on a branch other than master. No deployment will be done."
  exit 0
fi

fastlane match appstore
fastlane beta
