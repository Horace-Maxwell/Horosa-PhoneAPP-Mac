# Horosa iPhone 安装（不通过 App Store）

## 1. 一次性准备
- 在 iPhone 上开启开发者模式（iOS 16+）。
- 用数据线连接 iPhone 到 Mac，并在 iPhone 上“信任此电脑”。
- 打开 `open-horosa-ios-xcode.command`，在 Xcode 里确认 `Runner` 签名团队可用。
- Xcode > Settings > Components 中安装 iOS 平台/运行时。
- 如遇 `cannot load such file -- plist`，执行一次：`sudo gem install plist`

## 2. 打包 IPA（非 App Store）
在项目根目录执行：

```bash
TEAM_ID=你的AppleTeamID BUNDLE_ID=com.你的域名.horosa METHOD=development ./build-horosa-ios-sideload.command
```

说明：
- `METHOD=development`：个人开发者/免费账号常用（证书有效期较短）。
- `METHOD=ad-hoc`：付费开发者账号，需设备 UDID 在描述文件中。
- 脚本已内置“路径含空格”兼容：会自动在 `/tmp` 无空格目录构建，再回拷 IPA。
- 脚本默认使用 `PUB_CACHE=/tmp/horosa_pub_cache`，避免 iOS pod 在空格路径下异常。

产物路径：
- `星阙/前端/App/build/ios/ipa/*.ipa`

## 3. 安装到 iPhone（不走 App Store）
可选方式：
- Xcode（推荐）：`Window > Devices and Simulators`，选中设备后拖入 `ipa` 安装。
- Apple Configurator 2：将 `ipa` 拖到连接的 iPhone。

首次打开 App 前：
- iPhone 设置 > 通用 > VPN与设备管理 > 信任对应开发者证书。
