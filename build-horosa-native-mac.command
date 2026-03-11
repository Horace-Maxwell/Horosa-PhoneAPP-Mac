#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")" && pwd)"
APP_DIR="${ROOT_DIR}/星阙/前端/App"
FLUTTER_BIN="${ROOT_DIR}/.toolchain/flutter/bin/flutter"
OUT_DIR="${ROOT_DIR}/native-macos-release"
APP_SRC="${APP_DIR}/build/macos/Build/Products/Release/horosa.app"
APP_DST="${OUT_DIR}/Horosa.app"
DMG_PATH="${OUT_DIR}/Horosa-macOS-arm64.dmg"

if [[ ! -x "${FLUTTER_BIN}" ]]; then
  echo "Flutter not found at: ${FLUTTER_BIN}"
  exit 1
fi

cd "${APP_DIR}"
"${FLUTTER_BIN}" pub get
"${FLUTTER_BIN}" build macos --release

mkdir -p "${OUT_DIR}"
rm -rf "${APP_DST}"
cp -R "${APP_SRC}" "${APP_DST}"

rm -f "${DMG_PATH}"
hdiutil create -volname "Horosa" -srcfolder "${APP_DST}" -ov -format UDZO "${DMG_PATH}"

echo "Build success: ${APP_DST}"
echo "DMG success: ${DMG_PATH}"
