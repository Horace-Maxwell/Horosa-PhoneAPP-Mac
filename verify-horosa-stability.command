#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")" && pwd)"
APP_DIR="${ROOT_DIR}/星阙/前端/App"
FLUTTER_BIN="${ROOT_DIR}/.toolchain/flutter/bin/flutter"
PUB_CACHE_DEFAULT="$(cd "${ROOT_DIR}/.." && pwd)/.pub-cache"
export PUB_CACHE="${PUB_CACHE:-${PUB_CACHE_DEFAULT}}"

N="${SMOKE_N:-5}"

if [[ ! -x "${FLUTTER_BIN}" ]]; then
  echo "Flutter not found: ${FLUTTER_BIN}"
  exit 1
fi

run_smoke() {
  local name="$1"
  local url="$2"
  local payload="$3"
  local ok=0
  local fail=0

  for ((i = 1; i <= N; i++)); do
    local resp=""
    if [[ -n "${payload}" ]]; then
      resp="$(curl -s -X POST "${url}" -H "Content-Type: application/json" -d "${payload}" || true)"
    else
      resp="$(curl -s -X POST "${url}" -H "Content-Type: application/json" || true)"
    fi
    local code
    code="$(printf '%s' "${resp}" | python3 -c 'import sys,json; print(json.load(sys.stdin).get("code","ERR"))' 2>/dev/null || echo ERR)"
    if [[ "${code}" == "0" ]]; then
      ok=$((ok + 1))
    else
      fail=$((fail + 1))
    fi
  done

  echo "[smoke] ${name}: ok=${ok}/${N} fail=${fail}"
  if [[ "${fail}" -gt 0 ]]; then
    return 1
  fi
}

if [[ "${1:-}" == "--build" ]]; then
  echo "==> Rebuilding native macOS app"
  bash "${ROOT_DIR}/build-horosa-native-mac.command"
fi

echo "==> Flutter analyze"
(
  cd "${APP_DIR}"
  "${FLUTTER_BIN}" analyze
)

echo "==> Flutter test"
(
  cd "${APP_DIR}"
  "${FLUTTER_BIN}" test
)

echo "==> API smoke tests (N=${N})"
run_smoke "quick_link" "https://api.horosa.com/trigram/quick_link" ""
run_smoke "sixline" "https://api.horosa.com/trigram/sixline" '{"address":"默认地点 北京","country":"中国","gua_time":{"year":2026,"month":2,"day":17,"hour":12,"minute":0},"gua_type":1,"hseb":{"year":"乙巳","month":"戊寅","day":"甲子","hour":"庚午"},"lines":"987698","jieqi":"立春","question":"","input_key":"verify-sixline","is_save":2}'
run_smoke "qimen" "https://api.horosa.com/trigram/qimen" '{"address":"默认地点 北京","country":"中国","gua_time":{"year":2026,"month":2,"day":17,"hour":12,"minute":0},"gua_type":2,"question":"","input_key":"verify-qimen","is_save":2}'
run_smoke "liuren" "https://api.horosa.com/trigram/liuren" '{"address":"默认地点 北京","country":"中国","gua_time":{"year":2026,"month":2,"day":17,"hour":12,"minute":0},"gua_type":1,"hseb":{"day":"甲子","hour":"庚午"},"hour_num":null,"jieqi":"立春","month":"正","question":"","input_key":"verify-liuren","is_save":2}'

echo "==> Checking packaged outputs"
test -d "${ROOT_DIR}/native-macos-release/Horosa.app"
test -f "${ROOT_DIR}/native-macos-release/Horosa-macOS-arm64.dmg"
echo "[ok] Packaged apps exist."

echo "All stability checks passed."
