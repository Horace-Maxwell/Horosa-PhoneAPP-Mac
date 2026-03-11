#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")" && pwd)"
APP_BUNDLE="${ROOT_DIR}/native-macos-release/Horosa.app"

if [[ ! -d "${APP_BUNDLE}" ]]; then
  echo "Native Horosa.app not found. Building it first..."
  "${ROOT_DIR}/build-horosa-native-mac.command"
fi

open "${APP_BUNDLE}"
