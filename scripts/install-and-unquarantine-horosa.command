#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
SRC_APP="${SCRIPT_DIR}/Horosa.app"
DST_APP="/Applications/Horosa.app"

show_alert() {
  local title="$1"
  local message="$2"
  /usr/bin/osascript -e "display alert \"$title\" message \"$message\""
}

if [[ ! -d "${SRC_APP}" ]]; then
  show_alert "未找到 Horosa.app" "请确保此脚本与 Horosa.app 位于同一个 DMG 窗口中。"
  exit 1
fi

/usr/bin/osascript - <<'APPLESCRIPT'
display dialog "将自动把 Horosa 安装到“应用程序”，移除 macOS 运行限制，并立即打开。" buttons {"取消", "继续"} default button "继续"
APPLESCRIPT

if [[ -w "/Applications" ]]; then
  /bin/rm -rf "${DST_APP}"
  /bin/cp -R "${SRC_APP}" "${DST_APP}"
  /usr/bin/xattr -dr com.apple.quarantine "${DST_APP}" || true
else
  /usr/bin/osascript - "${SRC_APP}" "${DST_APP}" <<'APPLESCRIPT'
on run argv
  set srcPath to item 1 of argv
  set dstPath to item 2 of argv
  do shell script "/bin/rm -rf " & quoted form of dstPath & " && /bin/cp -R " & quoted form of srcPath & " " & quoted form of dstPath & " && /usr/bin/xattr -dr com.apple.quarantine " & quoted form of dstPath with administrator privileges
end run
APPLESCRIPT
fi

/usr/bin/open "${DST_APP}"
show_alert "安装完成" "Horosa 已安装并放行，现在会自动打开。"
