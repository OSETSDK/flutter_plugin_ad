----------
# Flutter对接文档
----------


## 一、集成插件

*   配置 `pubspec.yaml` 快速集成插件

```
dependencies:
  flutter_openset_ads: ^1.0.8
```


* 导包
```
在您的 Dart 代码中，您可以导入如下包：

/// 插件初始化
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

## 二、加载各类型广告
目前我们支持开屏、插屏、激励、全屏、banner、信息流模版等广告类型，以及短视频模块，请按需获取。

* 1、开屏广告
具体代码请参考demo 中的 lib/SplashAdLauncherPage.dart
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
具体代码请参考demo 中的 lib/InterstitialAdPage.dart
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
具体代码请参考demo 中的 lib/RewardVideoAdPage.dart
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
具体代码请参考demo 中的 lib/FullVideoAdPage.dart
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
具体代码请参考demo lib/BannerAdPage.dart
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
具体代码请参考demo lib/NativeAdPage.dart
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

* 7、短视频模块
具体代码请参考demo lib/VideoContentPage.dart
```
    /// 创建短视频加载器
    _videoContentLoader = OSETVideoContentLoader();

    _videoContentLoader.onAdLoad = (osetAd) {
      print('$TAG 短视频加载成功...');
    };
    _videoContentLoader.onAdFailed = (msg) {
      print('$TAG 短视频加载失败, $msg');
    };
    _videoContentLoader.onAdTimeOver = (osetAd) {
      print('$TAG 短视频回调奖励...');
    };

    _videoContentLoader.loadAd(
      // 广告位ID，不同端的广告位ID可能不一致，需替换成自己相应端的广告位ID
      posId:
          Platform.isAndroid
              ? Common.androidPosIdVideoPage
              : Common.iosPosIdVideoPage,
      standPage: standPage,
      // 可刷新奖励次数
      rewardCount: rewardCount,
      // 每次刷新奖励所需观看的时间
      rewardDownTime: rewardDownTime,
    );

    /// 释放广告
    _videoContentLoader.release();
```

### 安卓测试id

| appkey     | E6097975B89E83D6 |
|------------|-----------|
| 开屏广告位id    | 7D5239D8D88EBF9B6D317912EDAC6439 |
| 插屏广告位id    | 1D273967F51868AF2C4E080D496D06D0 |
| banner广告位id | 107EB50EDFE65EA3306C8318FD57D0B3 |
| 激励视频广告位id  | 09A177D681D6FB81241C3DCE963DCB46 |
| 全屏视频广告位id  | D879C3DED01D5CE319CD2751474BA8E4 |
| 模版信息流广告位id | 89FEEA66F9228ED3F6420294B89A902B |
| 短视频内容模块id  | C5F4F13C421B10664D9D21EDB52C8C5D |


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
