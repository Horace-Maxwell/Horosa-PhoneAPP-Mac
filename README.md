# Horosa PhoneAPP for Mac

`Horosa PhoneAPP for Mac` 是基于原始星阙手机端 Flutter 工程整理出的 macOS 适配版本，目标是让用户在 macOS 上直接使用完整的星阙体验。

本仓库包含：

- Flutter 源码
- macOS 原生打包脚本
- iOS 侧载打包脚本
- macOS 可分发安装包的构建入口

不包含：

- 本地 Flutter toolchain
- 本地构建缓存、Pods、build 产物
- 已打包的 `.app` / `.dmg` 发布文件
- 个人签名证书、JKS、IDE 本地配置

## 目录说明

- [星阙/前端/App](./星阙/前端/App): 主 Flutter 应用源码
- [build-horosa-native-mac.command](./build-horosa-native-mac.command): 构建 macOS 原生 `.app` 和 `.dmg`
- [start-horosa-native-mac.command](./start-horosa-native-mac.command): 启动已构建的 macOS App
- [build-horosa-ios-sideload.command](./build-horosa-ios-sideload.command): 构建 iOS 侧载包
- [open-horosa-ios-xcode.command](./open-horosa-ios-xcode.command): 打开 iOS Xcode 工程
- [verify-horosa-stability.command](./verify-horosa-stability.command): 分析、测试与基础接口 smoke 检查

## 环境要求

- macOS
- Xcode 26 或更高
- CocoaPods
- Flutter 3.24.x

说明：仓库默认不提交 Flutter SDK。你可以自行安装 Flutter，也可以在仓库根目录放置 `.toolchain/flutter/bin/flutter` 以使用脚本中的默认路径。

## 发布前配置

公开仓库中已去除本地地图 key 和 iOS 开发团队配置。你在自行构建前需要至少补齐：

- `星阙/前端/App/lib/constants/keys.dart` 中的高德 iOS key
- `星阙/前端/App/android/app/src/main/AndroidManifest.xml` 中的高德 Android key
- iOS 签名所需的 `TEAM_ID`、`BUNDLE_ID`

## macOS 构建

```bash
bash ./build-horosa-native-mac.command
```

构建成功后产物会输出到：

- `native-macos-release/Horosa.app`
- `native-macos-release/Horosa-macOS-arm64.dmg`

## macOS 启动

```bash
bash ./start-horosa-native-mac.command
```

## iOS 侧载构建

```bash
TEAM_ID=YOUR_TEAM_ID BUNDLE_ID=com.example.horosa METHOD=development bash ./build-horosa-ios-sideload.command
```

更多说明见 [IOS_SIDELOAD.md](./IOS_SIDELOAD.md)。

## 测试与检查

```bash
bash ./verify-horosa-stability.command
```

## Release 下载

普通用户不需要自行构建。请直接前往 GitHub Releases 下载最新的 `Horosa-macOS-arm64.dmg`，挂载后将 `Horosa.app` 拖入 Applications 即可使用。

说明：未做 Developer ID 签名和 notarization 的前提下，macOS 不允许下载后的脚本或 App 在 DMG 中自动完成“放行”。如果系统拦截，请在终端执行：

```bash
xattr -dr com.apple.quarantine "/Applications/Horosa.app"
```

## 致谢

本项目基于原始星阙手机端工程进行 macOS 适配整理。请尊重原作者及原开发团队的工作成果。
