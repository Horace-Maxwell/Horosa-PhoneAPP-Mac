#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")" && pwd)"
APP_DIR="${ROOT_DIR}/星阙/前端/App"
FLUTTER_BIN="${ROOT_DIR}/.toolchain/flutter/bin/flutter"
OUT_DIR="${ROOT_DIR}/native-macos-release"
APP_SRC="${APP_DIR}/build/macos/Build/Products/Release/horosa.app"
APP_DST="${OUT_DIR}/Horosa.app"
DMG_PATH="${OUT_DIR}/Horosa-macOS-arm64.dmg"
DMG_STAGE_DIR="$(mktemp -d "${TMPDIR:-/tmp}/horosa-dmg.XXXXXX")"

cleanup() {
  rm -rf "${DMG_STAGE_DIR}"
}

trap cleanup EXIT

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

cp -R "${APP_DST}" "${DMG_STAGE_DIR}/Horosa.app"
ln -s /Applications "${DMG_STAGE_DIR}/Applications"

rm -f "${DMG_PATH}"
hdiutil create -volname "Horosa" -srcfolder "${DMG_STAGE_DIR}" -ov -format UDZO "${DMG_PATH}"

echo "Build success: ${APP_DST}"
echo "DMG success: ${DMG_PATH}"
