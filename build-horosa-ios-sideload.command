#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")" && pwd)"
APP_DIR="${ROOT_DIR}/星阙/前端/App"
FLUTTER_BIN="${ROOT_DIR}/.toolchain/flutter/bin/flutter"
XCODEPROJ="${APP_DIR}/ios/Runner.xcodeproj/project.pbxproj"
SAFE_PUB_CACHE_DEFAULT="/tmp/horosa_pub_cache"

if [[ "${HOROSA_IOS_NOSPACE_BOOTSTRAPPED:-0}" != "1" && "${ROOT_DIR}" == *" "* ]]; then
  TMP_PARENT="/tmp/horosa_ios_nospace_build"
  TMP_ROOT="${TMP_PARENT}/Horosa-APP-main"
  ORIG_ROOT="${ROOT_DIR}"
  ORIG_IPA_DIR="${ORIG_ROOT}/星阙/前端/App/build/ios/ipa"

  echo "Detected spaces in project path. Using temporary no-space build dir."
  rm -rf "${TMP_PARENT}"
  mkdir -p "${TMP_PARENT}"
  rsync -a --delete "${ORIG_ROOT}/" "${TMP_ROOT}/"

  HOROSA_IOS_NOSPACE_BOOTSTRAPPED=1 \
  HOROSA_IOS_ORIG_ROOT="${ORIG_ROOT}" \
  bash "${TMP_ROOT}/build-horosa-ios-sideload.command"
  BUILD_RC=$?

  if [[ ${BUILD_RC} -eq 0 ]]; then
    mkdir -p "${ORIG_IPA_DIR}"
    rsync -a "${TMP_ROOT}/星阙/前端/App/build/ios/ipa/" "${ORIG_IPA_DIR}/"
    echo "Synced ipa back to: ${ORIG_IPA_DIR}"
  fi

  exit ${BUILD_RC}
fi

export PUB_CACHE="${PUB_CACHE:-${SAFE_PUB_CACHE_DEFAULT}}"
mkdir -p "${PUB_CACHE}"

if [[ "${PUB_CACHE}" == *" "* ]]; then
  echo "Warning: PUB_CACHE contains spaces and may break fluwx iOS pod scripts: ${PUB_CACHE}"
  echo "Recommended: PUB_CACHE=${SAFE_PUB_CACHE_DEFAULT}"
fi

if [[ ! -x "${FLUTTER_BIN}" ]]; then
  echo "Flutter not found: ${FLUTTER_BIN}"
  exit 1
fi

if ! xcodebuild -showsdks 2>/dev/null | rg -q "iphoneos"; then
  echo "iOS platform SDK is missing in Xcode."
  echo "Open Xcode > Settings > Components, then install iOS platform/runtime first."
  exit 1
fi

if ! ruby -e "require 'plist'" >/dev/null 2>&1; then
  echo "Ruby gem 'plist' is missing (required by fluwx iOS pod script)."
  echo "Install once: sudo gem install plist"
  exit 1
fi

TEAM_DEFAULT="$(rg -n "DEVELOPMENT_TEAM =" "${XCODEPROJ}" | head -n 1 | sed -E 's/.*DEVELOPMENT_TEAM = ([A-Z0-9]+);.*/\1/')"
TEAM_ID="${TEAM_ID:-${TEAM_DEFAULT:-}}"
BUNDLE_ID="${BUNDLE_ID:-com.horosa.xingque}"
METHOD="${METHOD:-development}" # development | ad-hoc

if [[ -z "${TEAM_ID}" ]]; then
  echo "TEAM_ID is required."
  echo "Example: TEAM_ID=ABCDE12345 BUNDLE_ID=com.yourname.horosa METHOD=development ./build-horosa-ios-sideload.command"
  exit 1
fi

if [[ "${METHOD}" != "development" && "${METHOD}" != "ad-hoc" ]]; then
  echo "METHOD must be one of: development, ad-hoc"
  exit 1
fi

ARCHIVE_PATH="${APP_DIR}/build/ios/archive/Horosa.xcarchive"
IPA_DIR="${APP_DIR}/build/ios/ipa"
EXPORT_PLIST="${APP_DIR}/build/ios/export_options_${METHOD}.plist"

mkdir -p "${APP_DIR}/build/ios/archive" "${IPA_DIR}"

cat > "${EXPORT_PLIST}" <<PLIST
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
  <key>method</key>
  <string>${METHOD}</string>
  <key>signingStyle</key>
  <string>automatic</string>
  <key>teamID</key>
  <string>${TEAM_ID}</string>
  <key>compileBitcode</key>
  <false/>
  <key>stripSwiftSymbols</key>
  <true/>
</dict>
</plist>
PLIST

cd "${APP_DIR}"
if ! "${FLUTTER_BIN}" pub get; then
  echo "Warning: flutter pub get failed, retrying with --offline."
  if ! "${FLUTTER_BIN}" pub get --offline; then
    if [[ -f "${APP_DIR}/.dart_tool/package_config.json" ]]; then
      echo "Warning: flutter pub get failed, using existing package_config.json cache."
    else
      echo "flutter pub get failed and no local package cache is available."
      exit 1
    fi
  fi
fi

pushd ios >/dev/null
pod install >/dev/null
popd >/dev/null

if ! xcodebuild -workspace ios/Runner.xcworkspace -scheme Runner -destination "generic/platform=iOS" -showBuildSettings >/tmp/horosa_ios_preflight.log 2>&1; then
  if rg -q "iOS .* is not installed" /tmp/horosa_ios_preflight.log; then
    echo "Xcode iOS platform/runtime is not installed yet."
    echo "Open Xcode > Settings > Components, install iOS, then retry."
    exit 1
  fi
  cat /tmp/horosa_ios_preflight.log
  exit 1
fi

xcodebuild \
  -workspace ios/Runner.xcworkspace \
  -scheme Runner \
  -configuration Release \
  -destination "generic/platform=iOS" \
  -archivePath "${ARCHIVE_PATH}" \
  DEVELOPMENT_TEAM="${TEAM_ID}" \
  PRODUCT_BUNDLE_IDENTIFIER="${BUNDLE_ID}" \
  CODE_SIGN_STYLE=Automatic \
  -allowProvisioningUpdates \
  archive

rm -f "${IPA_DIR}"/*.ipa
xcodebuild \
  -exportArchive \
  -archivePath "${ARCHIVE_PATH}" \
  -exportPath "${IPA_DIR}" \
  -exportOptionsPlist "${EXPORT_PLIST}" \
  -allowProvisioningUpdates

IPA_PATH="$(find "${IPA_DIR}" -maxdepth 1 -name '*.ipa' | head -n 1)"
if [[ -z "${IPA_PATH}" ]]; then
  echo "Export finished but no ipa found under ${IPA_DIR}"
  exit 1
fi

echo "iOS sideload package ready: ${IPA_PATH}"
