## [1.0.0]
- First public release. initial commit 


## [1.0.2]
- 更新iOS对接方式

## [1.0.3]
- 更新banner和信息流调用，增加高度入参(iOS需要传)

## [1.0.5]
- 更新iOS原生SDK版本号

## [1.0.6]
- 修改适配器代码

## [1.0.7]
- 适配banner、原生信息流广告
- 对接文档优化

## [1.0.8]
- 延迟测量安卓信息流高度，避免高度测量错误

## [1.1.0]
- 修复安卓信息流概率白屏问题

## [1.1.1]
- 更新Android原生SDK版本

## [1.1.2]
- 更新iOS原生SDK版本

## [1.1.3]
- 更新安卓原生SDK版本
## [1.1.31]
- 移除gromoresdk

## [1.1.32]
- 移除oaid

## [1.1.33]
- 移除oaid、gromore


## [1.1.35]
- 更新广告SDK正常版本

## [1.1.36]
- 支持快手短视频

## [1.1.38]
- 安卓广告SDK更新6555版本
- iOS广告类型增加adType

## [1.1.39]
- 更新安卓原生SDK及全部第三方ADN适配器版本（ad-openset-sdk 6.5.9.2，取自官方文档）
- 新增华为广告适配器（ad-huawei-adapter），移除京东适配器
- 新增 Android 原生隐私合规配置支持（OSETPrivacyConfig / OSETCustomController）
- 初始化支持传入 userId
- initAd 返回 InitAdResult（success / code / msg）
- 移除短视频内容模块（SDK 6.5.9.x 基础包已不再包含 com.kc.openset.video）
- 文档补充隐私合规、资源压缩 keep.xml、华为渠道说明
- 修复：补充华为 Maven 仓库，否则 ad-huawei-adapter 的 ads-lite 依赖无法解析
- 修复：显式声明插件 ndkVersion，避免回落到 AGP 默认 NDK 版本而强制接入方升级 NDK
- 修复：移除与 SDK manifest 重复声明的 OSETWebViewActivity，解决 manifest 合并冲突
- 修复：example 的 Dart SDK 约束放宽为 ^3.5.0，可用 Flutter 3.24.x 正常运行
