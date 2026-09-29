----------
# Flutter对接文档
----------


## 一、集成插件

*   配置 `pubspec.yaml` 快速集成插件

```
dependencies:
  flutter_openset_ads: ^1.1.39
```


* 导包
```
在您的 Dart 代码中，您可以导入如下包：

/// 插件初始化（含隐私合规配置 OSETPrivacyConfig）
import 'package:flutter_openset_ads/OSETAdSDK.dart';

/// 开屏广告加载器
import 'package:flutter_openset_ads/loader/OSETSplashAdLoader.dart';

/// 插屏广告加载器
import 'package:flutter_openset_ads/loader/OSETInterstitialAdLoader.dart';

/// 激励广告加载器
import 'package:flutter_openset_ads/loader/OSETRewardVideoAdLoader.dart';

/// 全屏广告加载器
import 'package:flutter_openset_ads/loader/OSETFullVideoAdLoader.dart';

/// banner广告加载器
import 'package:flutter_openset_ads/loader/OSETBannerAdLoader.dart';

/// 原生信息流广告加载器
import 'package:flutter_openset_ads/loader/OSETNativeAdLoader.dart';

```

## 二、初始化 SDK（必须）

> **必须在用户同意 App 隐私政策之后调用初始化**，且只能在主线程调用一次。

### 1、基础初始化

```
import 'dart:io';
import 'package:flutter_openset_ads/OSETAdSDK.dart';

bool ok = await OSETAdSDK.initAd(
  // 不同端的 appKey 是分开的，需替换成自己相应端的 appKey
  appKey: Platform.isAndroid ? Common.androidAppId : Common.iosAppId,
  debug: false,
);
```

`initAd` 参数说明：

| 参数              | 类型                  | 必填 | 说明                                              |
|-----------------|---------------------|----|-------------------------------------------------|
| `appKey`        | `String`            | 是  | 广告配置 appKey，Android / iOS 分开               |
| `debug`         | `bool`              | 是  | 是否为测试模式（默认 false）                      |
| `userId`        | `String?`           | 否  | 接入方的用户唯一 id，用于根据用户反馈排查问题，没有可不传 |
| `privacyConfig` | `OSETPrivacyConfig?` | 否  | Android 原生隐私合规配置，不传则与 SDK 默认行为一致（全部允许） |

### 2、Android 隐私合规配置（重点）

`privacyConfig` 对应 Android 原生 SDK 的 `OSETCustomController`，用于声明**允许 / 禁止
SDK 主动采集哪些设备信息**，是应用商店隐私合规检查的必填项。

*   该配置**仅在 Android 生效**，iOS 端会忽略；
*   所有开关默认与 Android SDK 保持一致（默认允许），按需关闭即可；
*   被置为 `false` 的信息 SDK 不再主动采集，如需继续使用可自行传入
    （`imei` / `oaid` / `androidId` / `latitude`+`longitude` / `installedPackages`）；
*   隐私合规配置只在初始化时生效，因此必须随 `initAd` 一次性传入。

```
final privacyConfig = OSETPrivacyConfig(
  // 关闭个性化广告
  canUsePersonalizedAd: false,
  // 禁止 SDK 主动采集硬件参数（imei/meid/imsi/iccid）
  canUsePhoneState: false,
  // 禁止 SDK 主动读取 androidId
  canUseAndroidId: false,
  // 禁止 SDK 主动获取 oaid
  canUseOaid: false,
  // 禁止 SDK 主动获取地理位置，如需继续使用可传 latitude / longitude
  canReadLocation: false,
  // 禁止 SDK 主动读取 App 安装列表
  canReadInstalledPackages: false,
  // 禁止 SDK 主动使用传感器
  canUseSensor: false,
);

bool ok = await OSETAdSDK.initAd(
  appKey: Platform.isAndroid ? Common.androidAppId : Common.iosAppId,
  debug: false,
  // 接入方的用户唯一 id，没有可不传
  userId: 'your_user_id',
  privacyConfig: privacyConfig,
);
```

`OSETPrivacyConfig` 全部字段（默认值均为 `true` / `null`，与原生 SDK 一致）：

| 字段                        | 类型              | 说明                                                     |
|---------------------------|-----------------|--------------------------------------------------------|
| `canReadLocation`         | `bool`          | 是否允许 SDK 主动使用地理位置信息                                 |
| `latitude` / `longitude`  | `double?`       | `canReadLocation=false` 时，SDK 使用这里传入的经纬度               |
| `canUsePhoneState`        | `bool`          | 是否允许 SDK 主动使用手机硬件参数（imei、meid、imsi、iccid）           |
| `imei`                    | `String?`       | `canUsePhoneState=false` 时，SDK 使用这里传入的原始 imei（无需 md5）   |
| `canUseAndroidId`         | `bool`          | 是否允许 SDK 主动读取 androidId                                |
| `androidId`               | `String?`       | `canUseAndroidId=false` 时，SDK 使用这里传入的 androidId         |
| `canUseOaid`              | `bool`          | 是否允许 SDK 主动使用 oaid                                      |
| `oaid`                    | `String?`       | `canUseOaid=false` 时，SDK 使用这里传入的原始 oaid（无需 md5）        |
| `canUseNetworkState`      | `bool`          | 是否允许 SDK 主动使用 `ACCESS_NETWORK_STATE` 权限                |
| `canUseStoragePermission` | `bool`          | 是否允许 SDK 主动使用存储权限                                      |
| `canReadInstalledPackages`| `bool`          | 是否允许 SDK 主动读取 App 安装列表                                 |
| `installedPackages`       | `List<String>?` | `canReadInstalledPackages=false` 时，SDK 使用这里传入的安装列表      |
| `canUsePersonalizedAd`    | `bool`          | 是否启用个性化广告                                              |
| `canUseSensor`            | `bool`          | 是否允许 SDK 主动使用传感器                                       |

> 也可以使用 `copyWith` 在已有配置基础上派生新配置，例如
> `config.copyWith(canUsePersonalizedAd: true)`。
>
> 参考：[OpenSet Android SDK 接入文档 - 隐私合规配置](https://doc.shenshiads.com/Android.html)

## 三、加载各类型广告
目前我们支持开屏、插屏、激励、全屏、banner、信息流模版等广告类型，请按需获取。

* 1、开屏广告
具体代码请参考demo 中的 lib/page/SplashAdLauncherPage.dart
```
    // 构建开屏广告加载器
    _splashAdLoader = OSETSplashAdLoader();

    // 设置广告加载成功监听
    _splashAdLoader?.onAdLoad = (osetAd) {
      print('开屏广告加载成功...');
    };

    // 设置广告加载失败监听
    _splashAdLoader?.onAdFailed = (msg) {
      print('开屏广告加载失败, $msg');
      _closePageSafely();
    };

    // 设置广告展示监听
    _splashAdLoader?.onAdExpose = (osetAd) {
      print('开屏广告展示成功...' + osetAd.adId);
    };

    // 设置广告被点击监听
    _splashAdLoader?.onAdClick = (osetAd) {
      print('开屏广告被点击...');
    };

    // 设置广告关闭监听
    _splashAdLoader?.onAdClose = (osetAd) {
      print('开屏广告被关闭...');
      _closePageSafely();
    };

    // 加载并展示开屏广告
    _splashAdLoader?.loadAd(
      // 广告位ID，不同端的广告位ID可能不一致，需替换成自己相应端的广告位ID
      posId: Platform.isAndroid ? Common.androidPosIdSplash : Common.iosPosIdSplash,
    );

    // 释放广告对象
    _splashAdLoader?.release();
```

* 2、插屏广告
具体代码请参考demo 中的 lib/page/InterstitialAdPage.dart
```
    // 创建插屏广告加载器
    _interstitialAdLoader = OSETInterstitialAdLoader();

    // 设置广告加载成功监听
    _interstitialAdLoader.onAdLoad = (osetAd) {
      print('插屏广告加载成功...');
    };

    // 设置广告加载失败监听
    _interstitialAdLoader.onAdFailed = (msg) {
      print('插屏广告加载失败, $msg');
    };

    // 设置广告展示监听
    _interstitialAdLoader.onAdExpose = (osetAd) {
      print('插屏广告展示成功...');
    };

    // 设置广告被点击监听
    _interstitialAdLoader.onAdClick = (osetAd) {
      print('插屏广告被点击...');
    };

    // 设置广告关闭监听
    _interstitialAdLoader.onAdClose = (osetAd) {
      print('插屏广告被关闭...');
    };

    // 加载插屏广告
    _interstitialAdLoader.loadAd(
      // 广告位ID，不同端的广告位ID可能不一致，需替换成自己相应端的广告位ID
      posId:
          Platform.isAndroid
              ? Common.androidPosIdInterstitial
              : Common.iosPosIdInterstitial,
    );

    // 释放广告对象
    _splashAdLoader?.release();
```

* 3、激励广告
具体代码请参考demo 中的 lib/page/RewardVideoAdPage.dart
```
    // 创建激励广告加载器
    _rewardVideoAdLoader = OSETRewardVideoAdLoader();

    // 设置广告加载成功监听
    _rewardVideoAdLoader.onAdLoad = (osetAd) {
      print('$TAG 激励广告加载成功...');
    };

    // 设置广告加载失败监听
    _rewardVideoAdLoader.onAdFailed = (msg) {
      print('$TAG 激励广告加载失败, $msg');
    };

    // 设置广告展示监听
    _rewardVideoAdLoader.onAdExpose = (osetAd) {
      print('$TAG 激励广告展示成功...');
    };

    // 设置广告奖励监听
    _rewardVideoAdLoader.onAdReward = (osetAd) {
      print('$TAG 激励广告奖励发放成功...');
    };

    // 设置广告被点击监听
    _rewardVideoAdLoader.onAdClick = (osetAd) {
      print('$TAG 激励广告被点击...');
    };

    // 设置广告关闭监听
    _rewardVideoAdLoader.onAdClose = (osetAd) {
      print('$TAG 激励广告被关闭...');
    };

    // 加载激励广告
    _rewardVideoAdLoader.loadAd(
      // 广告位ID，不同端的广告位ID可能不一致，需替换成自己相应端的广告位ID
      posId:
          Platform.isAndroid
              ? Common.androidPosIdRewardVideo
              : Common.iosPosIdRewardVideo,
    );

    /// 释放广告
    _rewardVideoAdLoader.release();
```

* 4、全屏视频
具体代码请参考demo 中的 lib/page/FullVideoAdPage.dart
```
    /// 创建全屏视频广告加载器
    _fullVideoAdLoader = OSETFullVideoAdLoader();

    // 设置广告加载成功监听
    _fullVideoAdLoader.onAdLoad = (osetAd) {
      print('全屏广告加载成功...');
    };

    // 设置广告加载失败监听
    _fullVideoAdLoader.onAdFailed = (msg) {
      print('全屏广告加载失败, $msg');
    };

    // 设置广告展示监听
    _fullVideoAdLoader.onAdExpose = (osetAd) {
      print('全屏广告展示成功...');
    };

    // 设置广告被点击监听
    _fullVideoAdLoader.onAdClick = (osetAd) {
      print('全屏广告被点击...');
    };

    // 设置广告关闭监听
    _fullVideoAdLoader.onAdClose = (osetAd) {
      print('全屏广告被关闭...');
    };

    /// 加载全屏广告
    _fullVideoAdLoader.loadAd(
      // 广告位ID，不同端的广告位ID可能不一致，需替换成自己相应端的广告位ID
      posId:
          Platform.isAndroid
              ? Common.androidPosIdFullscreenVideo : ""
              // : Common.iosPosId,
    );

    /// 释放广告
    _fullVideoAdLoader.release();
    super.dispose();
```

* 5、banner广告
具体代码请参考demo 中的 lib/page/BannerAdPage.dart
```
    // 创建banner广告加载器
    final OSETBannerAdLoader _bannerAdLoader = OSETBannerAdLoader();

    // 设置广告加载成功监听
    _bannerAdLoader.onAdLoad = (osetAd) {
      // 将获取到广告模板广告（osetAd.bannerWidget）直接展示
      setState(() {
        _bannerAd = osetAd.bannerWidget;
      });
      _loading = false;
      print('Banner广告加载成功...');
    };

    // 设置广告加载失败监听
    _bannerAdLoader.onAdFailed = (msg) {
      _loading = false;
      print('Banner广告加载失败, $msg');
    };

    // 设置广告展示监听
    _bannerAdLoader.onAdExpose = (osetAd) {
      print('Banner广告展示成功...');
    };

    // 设置广告被点击监听
    _bannerAdLoader.onAdClick = (osetAd) {
      print('Banner广告被点击...');
    };

    // 设置广告关闭监听
    _bannerAdLoader.onAdClose = (osetAd) {
      print('Banner广告被关闭...');
    };

    /// 加载Banner广告
    _bannerAdLoader.loadAd(
      // 广告位ID，不同端的广告位ID可能不一致，需替换成自己相应端的广告位ID
      posId:
          Platform.isAndroid
              ? Common.androidPosIdBanner
              : Common.iosPosIdBanner,
      // 广告宽度
      adWidth: MediaQuery.of(context).size.width,
      adHeight: 50
    );

    /// 释放广告
    _bannerAdLoader.release();
    super.dispose();
```

* 6、信息流模版
具体代码请参考demo 中的 lib/page/NativeAdPage.dart
```
    /// 创建信息流模版广告加载器
    _nativeAdLoader = OSETNativeAdLoader();
    
    // 设置广告加载成功监听
    _nativeAdLoader.onAdLoad = (osetAd) {
      _loading = false;
      print('$TAG 信息流广告加载成功...');
      // 将获取到广告模板广告（osetAd.nativeWidget）直接展示
      setState(() {
        _nativeAd = osetAd.nativeWidget;
      });
    };

    // 设置广告加载失败监听
    _nativeAdLoader.onAdFailed = (msg) {
      _loading = false;
      print('$TAG 信息流广告加载失败, $msg');
    };

    // 设置广告展示监听
    _nativeAdLoader.onAdRenderSuccess = (osetAd) {
      print('$TAG 信息流广告渲染成功...');
    };

    // 设置广告展示监听
    _nativeAdLoader.onAdExpose = (osetAd) {
      print('$TAG 信息流广告展示成功...');
    };

    // 设置广告被点击监听
    _nativeAdLoader.onAdClick = (osetAd) {
      print('$TAG 信息流广告被点击...');
    };

    // 设置广告关闭监听
    _nativeAdLoader.onAdClose = (osetAd) {
      print('$TAG 信息流广告被关闭...');
    };

    // 加载信息流广告
    _nativeAdLoader.loadAd(
      // 广告位ID，不同端的广告位ID可能不一致，需替换成自己相应端的广告位ID
      posId:
      Platform.isAndroid
          ? Common.androidPosIdNative
          : Common.iosPosIdNative,
      // 广告宽度
      adWidth: MediaQuery.of(context).size.width,
    );

    /// 释放广告
    _nativeAdLoader.release();
```

### 安卓原生 SDK 版本

插件 `android/build.gradle` 中已按官方文档引入以下版本（如需替换版本请自行 exclude）：

| 模块           | 依赖坐标                                                |
|--------------|-----------------------------------------------------|
| 基础包          | `com.shenshi:ad-openset-sdk:6.5.9.2`                 |
| 百度           | `com.shenshi:ad-baidu-adapter:9.450.5`               |
| 穿山甲&GroMore  | `com.shenshi:ad-gromore-adapter:7.7.1.6.1`           |
| sigmob       | `com.shenshi:ad-sigmob-adapter:4.25.81.1`            |
| 快手           | `com.shenshi:ad-kuaishou-adapter:5.6.10.1.1`         |
| 广点通          | `com.shenshi:ad-guangdiantong-adapter:4.690.1560.7`  |
| 倍孜           | `com.shenshi:ad-beizi-adapter:5.5.0.2.6`             |
| tanx         | `com.shenshi:ad-tanx-adapter:3.7.37.4`               |
| 海量           | `com.shenshi:ad-hailiang-adapter:3.482.14.448.1`     |
| 章鱼           | `com.shenshi:ad-zhangyu-adapter:2.6.8.11.1`          |
| 华为           | `com.shenshi:ad-huawei-adapter:13.4.90.300.1`        |

> 说明：自 `ad-openset-sdk:6.5.9.x` 起基础包不再包含短视频内容模块
> （`com.kc.openset.video.*`），插件已同步移除短视频相关接口。

### 安卓测试id

| appkey     | E6097975B89E83D6 |
|------------|-----------|
| 开屏广告位id    | 7D5239D8D88EBF9B6D317912EDAC6439 |
| 插屏广告位id    | 1D273967F51868AF2C4E080D496D06D0 |
| banner广告位id | 107EB50EDFE65EA3306C8318FD57D0B3 |
| 激励视频广告位id  | 09A177D681D6FB81241C3DCE963DCB46 |
| 全屏视频广告位id  | D879C3DED01D5CE319CD2751474BA8E4 |
| 模版信息流广告位id | 89FEEA66F9228ED3F6420294B89A902B |


### 安卓混淆配置

> OpenSet SDK 与部分适配器 AAR 已内置 consumer ProGuard 规则，AGP 会自动应用；
> 但仍有部分第三方 ADN 需要在 app 侧手动补充规则，请以官方文档为准：
> [OpenSet Android SDK 接入文档 - 混淆配置](https://doc.shenshiads.com/Android.html)

在您项目中的 android/app 模块下的 build.gradle 文件中添加混淆配置如下
```
    buildTypes {
        release {
            minifyEnabled true
            signingConfig signingConfigs.release
            proguardFiles getDefaultProguardFile('proguard-android-optimize.txt'), 'proguard-rules.pro'
        }
        debug {
            signingConfig signingConfigs.debug
            proguardFiles getDefaultProguardFile('proguard-android-optimize.txt'), 'proguard-rules.pro'
        }
    }

```
然后按官方文档的「混淆配置」章节，把规则拷贝到 `android/app/proguard-rules.pro` 中。

### 安卓资源压缩配置（shrinkResources=true 必看）

如果 release 构建开启了 `shrinkResources = true`（资源压缩），**必须**在 app 模块下创建
`app/src/main/res/raw/keep.xml`，否则展示广告时会出现 `Resources$NotFoundException` 导致闪退。

本仓库的 example 已经内置该文件（`example/android/app/src/main/res/raw/keep.xml`），
内容与官方文档一致，直接拷贝到你的工程即可：

```
<?xml version="1.0" encoding="utf-8"?>
<resources xmlns:tools="http://schemas.android.com/tools"
    tools:shrinkMode="safe"
    tools:keep="
        @anim/oset_*,
        @drawable/oset_*,
        @layout/oset_*,
        @mipmap/oset_*,
        @xml/oset_*,
        @color/oset_*,
        @string/oset_*,
        @style/OSET_*,
        @attr/adSetMaxWidth,
        @attr/adSetMaxHeight" />
```

参考：[OpenSet Android SDK 接入文档 - 资源压缩配置](https://doc.shenshiads.com/Android.html)

### 华为广告渠道

插件已引入 `com.shenshi:ad-huawei-adapter:13.4.90.300.1`，它依赖华为的
`com.huawei.hms:ads-lite`，因此插件的 `android/build.gradle` 已自动补充华为 Maven 仓库：

```
maven { url 'https://developer.huawei.com/repo' }
```

需要注意的两点：

1. 如果对接华为渠道，还需要在 app 模块中补充 ads-lite（版本与适配器保持一致）：
```
implementation("com.huawei.hms:ads-lite:13.4.90.300")
```
2. 如果你的工程自己重写了 `allprojects.repositories`，请一并保留上面的华为仓库，否则会报
   `Could not find com.huawei.hms:ads-lite`。

### 安卓 NDK 版本

插件在 `android/build.gradle` 中显式声明了 `ndkVersion '23.1.7779620'`
（与 Flutter 3.24.x 的 `flutter.ndkVersion` 一致）。

之所以要显式声明：如果插件不声明，Flutter 的构建校验会把它当作 AGP 的默认 NDK 版本
（AGP 8.7 为 `27.0.12077973`），从而要求接入方把 app 的 `android.ndkVersion` 也提到 27.x，
否则会报：

```
Your project is configured with Android NDK 23.1.7779620, but the following plugin(s) depend on
a different Android NDK version: - flutter_openset_ads requires Android NDK 27.0.12077973
```

接入方只需保证 app 的 `android.ndkVersion` **大于等于** 23.1.7779620 即可，
例如直接使用当前 Flutter SDK 的默认值：

```kotlin
android {
    ndkVersion = flutter.ndkVersion
}
```

## iOS配置

*   1、添加 NSUserTrackingUsageDescription （IDFA描述）字段和自定义文案描述。

代码示例：

```xml
 <key>NSUserTrackingUsageDescription</key>
<string>该标识符将用于向您投放个性化广告</string>

```
*   2、 设置允许Http连接,在工程的 Info.plist 文件中，设置 App Transport Security Settings
    选项下 Allow Arbitrary Loads 值为 YES，对应 plist 内容为:


```xml
<key>NSAppTransportSecurity</key>
<dict>
    <key>NSAllowsArbitraryLoads</key>
    <true/>
</dict>

```
在您的应用的Info.plist文件中，添加一个字符串SKAdNetworkItems键，如


```xml
 <key>SKAdNetworkItems</key>
<array>
    <dict>
        <key>SKAdNetworkIdentifier</key>
        <string>58922NB4GD.skadnetwork</string>
    </dict>
    <dict>
        <key>SKAdNetworkIdentifier</key>
        <string>238da6jt44.skadnetwork</string>
    </dict>
    <dict>
        <key>SKAdNetworkIdentifier</key>
        <string>r3y5dwb26t.skadnetwork</string>
    </dict>
    <dict>
        <key>SKAdNetworkIdentifier</key>
        <string>f7s53z58qe.skadnetwork</string>
    </dict>
    <dict>
        <key>SKAdNetworkIdentifier</key>
        <string>x2jnk7ly8j.skadnetwork</string>
    </dict>
    <dict>
        <key>SKAdNetworkIdentifier</key>
        <string>cstr6suwn9.skadnetwork</string>
    </dict>
    <dict>
        <key>SKAdNetworkIdentifier</key>
        <string>22mmun2rn5.skadnetwork</string>
    </dict>
    <dict>
        <key>SKAdNetworkIdentifier</key>
        <string>27a282f54n.skadnetwork</string>
    </dict>
</array> 
```
（可选配置，添加可增加收益）在您的应用的Info.plist文件中，添加一个数组LSApplicationQueriesSchemes键，如


```xml
 <key>LSApplicationQueriesSchemes</key> <array>
    <string>tbopen</string> <string>openapp.jdmobile</string> <string>alipays</string> <string>imeituan</string> <string>pddopen</string> <string>sinaweibo</string> <string>snssdk1128</string> <string>kwai</string> <string>ksnebula</string> <string>ctrip</string> <string>vipshop</string> <string>OneTravel</string> <string>taobaoliveshare</string> <string>taobaolite</string> <string>iqiyi</string> <string>eleme</string> <string>openjdlite</string> <string>xhsdiscover</string> <string>tmall</string> <string>dianping</string> <string>youku</string> <string>fleamarket</string> <string>bilibili</string> <string>freereader</string> <string>tantanapp</string> <string>suning</string> <string>qunariphone</string> <string>lianjia</string> <string>zhihu</string> <string>weixin</string> <string>travelguide</string> <string>wbmain</string> <string>taobaotravel</string> <string>cainiao</string> <string>kaola</string> <string>bitauto.yicheapp</string> <string>lianjiabeike</string> <string>taoumaimai</string> <string>amapuri</string> <string>openanjuke</string>
    <string>bosszp</string> <string>txvideo</string> <string>mttbrowser</string> <string>momochat</string> <string>baiduboxlite</string> <string>com.360buy.jdpingou</string> <string>vmall</string> <string>tuhu</string> <string>comjia</string> <string>yymobile</string> <string>shuqireader</string>
</array>
```

*   3、 执行pod install
*   4、广告调用于安卓完全一致 但 广告位id和初始化appkey都是分开的

| ios测试_appkey                |  31DC084BB6B04838 |
|-----------------------|------------------------|
| ios测试_广告类型         | ios测试_广告位ID          |
| ios测试_信息流          | 3DC16BFC019545395507ED826899B16E |
| ios测试_原生           | 921DE1BF1B3F06838AE04233A42B01F1 |
| ios测试_全屏           | 8FCB39267CE40245B87EF8835A853708 |
| ios测试_激励           | E80DABEF5FD288492D4A9D05BF84E417 |
| ios测试_插屏           | 351C1A89F8AE79DF62C1B1165A5EAFCC |
| ios测试_banner       | 7B2BD37383E008B422C93486EACEA11D |
| ios测试_开屏           | 18666EAA65EC1969E90E982DCA2CB2DD |
