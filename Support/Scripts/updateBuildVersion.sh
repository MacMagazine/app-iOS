#!/bin/bash

# exit if a command fails
set -e

# ---- READ PARAMS ----
while getopts ":p:i:b:" opt; do
    case $opt in
        p) project_name="$OPTARG";;
        i) info_plist_file="$OPTARG";;
        b) build_version="$OPTARG";;
        \?) echo "Invalid option -$OPTARG" >&2;;
    esac
done

echo ""

# ---- PROJECT FILE ----
if [ -z "${project_name}" ] ; then
    for file in *.xcodeproj
    do
      project_name="${file%.*}"
    done
fi
if [ -z "${project_name}" ] ; then
    echo -e "\x1B[31m✗ PROJECT FILE (.xcodeproj) DOESN'T EXIST AT PATH: $PWD\x1B[0m"
    echo -e "\x1B[31m[✗] Exiting...\x1B[0m"
    echo ""
    exit 1
fi

# ---- PLIST FILE ----
if [ ! -f "${info_plist_file}" ] ; then
	echo -e "\x1B[31m[✗] File Info.plist doesn't exist at specified path: ${info_plist_file}\x1B[0m"
	echo -e "\x1B[31m[✗] Exiting...\x1B[0m"
	echo ""
	exit 1
fi

echo ""
echo "(i) Replacing version for ${info_plist_file} ..."

# ---- ORIGINAL BUILD VERSION - 1 ----
ORIGINAL_BUNDLE_VERSION=`sed -n '/CURRENT_PROJECT_VERSION/{s/CURRENT_PROJECT_VERSION = //;s/;//;s/^[[:space:]]*//;p;q;}' ./${project_name}.xcodeproj/project.pbxproj`
if [ -z "${ORIGINAL_BUNDLE_VERSION}" ] ; then
	ORIGINAL_BUNDLE_VERSION=$(/usr/libexec/PlistBuddy -c "Print CFBundleVersion" "${info_plist_file}")
fi
if [ -z "${ORIGINAL_BUNDLE_VERSION}" ] ; then
	echo -e "\x1B[31m[✗] No Bundle Version String (bundle_version) specified!\x1B[0m"
	echo -e "\x1B[31m[✗] Exiting...\x1B[0m"
	exit 1
fi
echo "  Original Bundle Version String: $ORIGINAL_BUNDLE_VERSION"

bundle_version=`echo $ORIGINAL_BUNDLE_VERSION | awk -F "." '{print $1 "." $2 "." $3 ".'$build_version'" }'`

echo -e "  (\x1B[32m✓\x1B[0m) Provided Bundle Version: ${bundle_version}"

# ---- UPDATE PLIST ----

echo ""
/usr/libexec/PlistBuddy -c "Set :CFBundleVersion ${bundle_version}" "${info_plist_file}"

# ---- REPLACED BUILD VERSION - 1 ----
REPLACED_BUNDLE_VERSION=`sed -n '/CURRENT_PROJECT_VERSION/{s/CURRENT_PROJECT_VERSION = //;s/;//;s/^[[:space:]]*//;p;q;}' ./${project_name}.xcodeproj/project.pbxproj`
if [ "${REPLACED_BUNDLE_VERSION}" != "${bundle_version}" ] ; then
	REPLACED_BUNDLE_VERSION=$(/usr/libexec/PlistBuddy -c "Print CFBundleVersion" "${info_plist_file}")
fi
if [ "${REPLACED_BUNDLE_VERSION}" != "${bundle_version}" ] ; then
	echo -e "\x1B[31m[✗] Error on update Bundle Version Short String: ${REPLACED_BUNDLE_VERSION} should be ${bundle_version}\x1B[0m"
	echo -e "\x1B[31m[✗] Exiting...\x1B[0m"
	exit 1
fi
echo -e "(\x1B[32m✓\x1B[0m) Replaced Bundle Short Version String: ${REPLACED_BUNDLE_VERSION}"
