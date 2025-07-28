----------
# AdSetSDK Flutter对接文档
----------


## 集成插件

*   配置 `pubspec.yaml` 集成插件

```
dependencies:
  flutter_openset_ads: ^1.0.2
```

*   或通过下载 `flutter_plugin_ad` 拷贝插件到 `lib/plugins` 目录下(其他位置也都可以)

```
flutter_plugin_ad:
  path: lib/plugins/flutter_plugin_ad # 本地引入
```


* 导入
```
在您的 Dart 代码中，您可以使用：
import 'package:flutter_openset_ads/entity/ad_event.dart';
import 'package:flutter_openset_ads/flutter_plugin_ad.dart';
import 'package:flutter_openset_ads/view/banner_ad_widget.dart';
import 'package:flutter_openset_ads/view/native_ad_widget.dart';
```


## Android配置
## 接入前注意事项（请先阅读注意事项再进行sdk对接）
**_安卓SDK目前默认推荐maven对接方式_**


### 对接方式：maven接入（推荐）
#### 1、在您的android项目模块根目录的build.gradle文件中引入 adset、荣耀和gromore仓库
``` java
buildscript {
    repositories {
       .
       .
       .
        // GroMore
        maven { url "https://artifact.bytedance.com/repository/Volcengine/" }
        maven { url "https://artifact.bytedance.com/repository/pangle" }
//        荣耀
        maven { url 'https://developer.hihonor.com/repo' }
//        adset
        maven {
            allowInsecureProtocol = true
            url "http://maven.shenshiads.com/nexus/repository/adset/"
        }
    }
}

allprojects {
    repositories {
        // GroMore
        maven { url "https://artifact.bytedance.com/repository/Volcengine/" }
        maven { url "https://artifact.bytedance.com/repository/pangle" }
//        荣耀
        maven { url 'https://developer.hihonor.com/repo' }
//        adset
        maven {
            allowInsecureProtocol = true
            url "http://maven.shenshiads.com/nexus/repository/adset/"
        }
    }
}

```
#### 2、在您的android项目模块app目录中的的build.gradle中引入sdk和第三方ADN
``` java
android {
    ...
    defaultConfig {
        ...
        multiDexEnabled true
    }
}
dependencies {
    
    //基础包 start
    implementation("com.shenshi:ad-openset-sdk:6.5.2.5")
    //基础包 end
    
    //    百度 start
    // 注意百度9.373版本开始，强制使用Androidx，如果使用这个版本以上的百度sdk，请将项目改为Androidx
    implementation 'com.shenshi:ad-baidu-adapter:9.391.1'
    //    百度 end
    
//    穿山甲&GroMore start
    implementation("com.shenshi:ad-gromore-ad-adapter:6.8.4.0.1")// 纯广告SDK

    //因为tanx会依赖第三方库 implementation 'org.jetbrains.kotlin:kotlin-stdlib:1.8.0' 会和 gromore短剧的依赖库冲突，如果不使用tanx，请按照这个对接
//    implementation("com.shenshi:ad-gromore-ct-adapter:6.8.4.0.1") // 包括广告和短剧内容SDK

    //因为tanx会依赖第三方库 implementation 'org.jetbrains.kotlin:kotlin-stdlib:1.8.0' 会和 gromore短剧的依赖库冲突，如果使用tanx，请按照这个对接
//    implementation("com.shenshi:ad-gromore-ct-adapter:6.8.4.0.1") {
//        exclude group: 'org.jetbrains.kotlin', module: 'kotlin-stdlib-jdk7'
//    }// 包括广告和短剧内容SDK
    
    //注意！！! 穿山甲短剧依赖okhttp，如果没有会闪退，如果已经添加请忽略，没有添加请添加okhttp，
    //另外，tanx默认依赖okhttp，如果 已经依赖了tanx，也不需要再添加okhttp
//    implementation 'com.squareup.okhttp3:okhttp:4.12.0'
//    穿山甲&GroMore end

    //sigmob start
    implementation("com.shenshi:ad-sigmob-adapter:4.23.0.1")
    //sigmob end

    //快手 start
    implementation 'com.shenshi:ad-kuaishou-ad-adapter:4.4.20.1.2'// 快手-纯广告SDK
//    implementation 'com.shenshi:ad-kuaishou-ct-adapter:3.3.76.5.2'// 快手-包括广告和内容SDK
    //快手 end

    //广点通 start
    implementation 'com.shenshi:ad-guangdiantong-adapter:4.640.1510.1'
    //广点通 end

    //倍孜 start
    implementation 'com.shenshi:ad-beizi-adapter:5.2.1.6.1'
    //倍孜 end

    //tanx start
    implementation 'com.shenshi:ad-tanx-adapter:3.7.13.1'
    //tanx end

    //海量 start
    implementation 'com.shenshi:ad-hailiang-adapter:3.470.13.436.1'
    //海量 end

    //章鱼 start
    implementation 'com.shenshi:ad-zhangyu-adapter:1.6.3.6.1'
    //章鱼 end

    // 京东 start
    //京东 androidx环境请使用
    implementation 'com.shenshi:ad-jingdong-androidx-adapter:2.6.32.1'

    //京东 support环境请使用
//    implementation 'com.shenshi:ad-jingdong-support-adapter:2.6.32.1'
    // 京东 end

    //multidex 64K问题，如果已添加请忽略
    implementation 'com.android.support:multidex:1.0.3'
    
    //微信小程序广告预算相关，引入可提升ecpm。强烈建议引入
    /**
     * 1，进入微信开放平台创建移动应用;
     * 2，应用创建完成后，获取到相应的微信ApplD;
     * 3.在移动端嵌入最新版OpenSDK，并确认版本为5.3.1及以上;
     * 4.在优量汇开发者平台，将微信开放平台填写的AppID与当前应用进行关联;
     * 第四步联系我们运营帮你们配置
     */
    implementation 'com.tencent.mm.opensdk:wechat-sdk-android:6.8.28'
    
}
```



#### 3、安卓sdk版本最低21
android项目模块目录下`android/app/build.gradle`中修改`minSdkVersion 21`



####   4、混淆配置
1、拷⻉ `android/app` ⽬录下`proguard-rules.pro`混淆文件到你项目中对应的`android/app/` ⽬录下
2、配置混淆文件，在您的android模块`android/app/build.gradle`文件中增加以下内容
``` java  
     buildTypes {
            release {
                proguardFiles getDefaultProguardFile('proguard-android-optimize.txt'), 'proguard-rules.pro'
                signingConfig signingConfigs.debug
            }
            debug {
                proguardFiles getDefaultProguardFile('proguard-android-optimize.txt'), 'proguard-rules.pro'
                signingConfig signingConfigs.debug
            }
    }
```


### 安卓测试id

| appkey | E6097975B89E83D6 |
|----------|-----------|
| 开屏广告位id | 7D5239D8D88EBF9B6D317912EDAC6439 |
| 插屏广告位id | 1D273967F51868AF2C4E080D496D06D0 |
| banner广告位id | 107EB50EDFE65EA3306C8318FD57D0B3 |
| 激励视频广告位id | 09A177D681D6FB81241C3DCE963DCB46 |
| 全屏视频广告位id | D879C3DED01D5CE319CD2751474BA8E4 |
| 信息流（原生）广告位id | 89FEEA66F9228ED3F6420294B89A902B |
| 短视频内容模块id | C5F4F13C421B10664D9D21EDB52C8C5D |
| 信息流内容模块id | 4EC4251D616C69030A161A930A938596 |
| 信息流内容模块2id | EBE266AAE65F52C37A28BF2D586132EB |
| 悬浮窗模块id | C20D0FDCA88E06E6718A33279AAD2B4D |


## iOS配置

*   1、添加 NSUserTrackingUsageDescription （IDFA描述）字段和自定义文案描述。

代码示例：

```html
 <key>NSUserTrackingUsageDescription</key>
<string>该标识符将用于向您投放个性化广告</string>

} 
```
*   2、 设置允许Http连接,在工程的 Info.plist 文件中，设置 App Transport Security Settings
    选项下 Allow Arbitrary Loads 值为 YES，对应 plist 内容为:


```html
<key>NSAppTransportSecurity</key>
<dict>
    <key>NSAllowsArbitraryLoads</key>
    <true/>
</dict>

```
在您的应用的Info.plist文件中，添加一个字符串SKAdNetworkItems键，如


```html
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


```html
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
| ios测试_短剧内容         | A0736045CDDF718C13DFF187254EA1D0 |
| ios测试_视频内容         | E06C7BB2C34605B4CD777EFD590DD4BE |
| ios测试_互动悬浮         | 4224443B309508BE30C3B8AC7CDE87C1 |
| ios测试_draw          | C773D52F59FF5AA418CD9E2181327197 |
| ios测试_信息流          | 3DC16BFC019545395507ED826899B16E |
| ios测试_原生           | 921DE1BF1B3F06838AE04233A42B01F1 |
| ios测试_全屏           | 8FCB39267CE40245B87EF8835A853708 |
| ios测试_激励           | E80DABEF5FD288492D4A9D05BF84E417 |
| ios测试_插屏           | 351C1A89F8AE79DF62C1B1165A5EAFCC |
| ios测试_banner       | 7B2BD37383E008B422C93486EACEA11D |
| ios测试_开屏           | 18666EAA65EC1969E90E982DCA2CB2DD |


## 广告接口

可以直接参考 `lib/main.dart` 文件，默认的都是测试appkey和测试广告位id

###   初始化
```
    *   详情参考 /lib/main.dart- init()
    *   **建议一进来app的`initState` 生命周期就要初始化sdk(必须在调用广告之前)**
        /// 初始化⼴告 SDK
        /// [appId] App申请的id
        /// [isDebug] 是否为测试模式
        FlutterPluginAd.initAd(appId, isDebug: true);
```        

###   检查并请求权限（仅 Android）
``` 
    *   检查并请求权限（仅 Android）
    *   **建议app中必须调用权限，有助于提升广告收入**
    ```
    /// 检查并请求权限（仅 Android）
    FlutterPluginAd.checkAndReqPermission();
```

###   添加⼴告监听
```
    *   详情参考 /lib/main.dart- setAdEvent(),监听状态见 /flutter\_plugin\_ad/lib/entity/ad\_event.dart```
        // 添加⼴告监听
        FlutterPluginAd.onEventListener((event) {
        setState(() {
            _adEvent = 'type:${event.eventType} msg:${event.msg}';
        });
        }, (error) {
        setState(() {
            StringBuffer sb = new StringBuffer();
            sb.write(error);
            // _adEvent = 'code:${code} msg:${msg}';
            // PlatformException err = error
            _adEvent = '${sb.toString()}';
        });
        });
        
```
###   展示开屏⼴告
```
    *   详情参考 /lib/main.dart- showSplashAd()
        
        ```
        /// 展示开屏⼴告
        /// [posIdSplash] ⼴告配置 posIdSplash
        FlutterPluginAd.showSplashAd(posIdSplashsId);
```

###   展示插屏⼴告
```    
    *   详情参考 /lib/main.dart- showInterstitialAd()
        
        /// 展示插屏⼴告
        /// [posIdInterstitial] ⼴告配置 posIdInterstitial
        FlutterPluginAd.showInterstitialAd(posIdInterstitial);
```

###   展示全屏视频⼴告
```    
    *   详情参考 /lib/main.dart- showFullscreenVideoAd()
        
        /// 展示全屏视频⼴告
        /// [posIdFullVideo] ⼴告配置 posIdFullVideo
        FlutterPluginAd.showFullscreenVideoAd(posIdFullVideo);
```

###   展示激励视频⼴告
```
    *   详情参考 /lib/main.dart- showRewardVideoAd()
        
        /// 展示激励视频⼴告
        /// [posIdRewardVideo] ⼴告配置 posIdRewardVideo
        FlutterPluginAd.showRewardVideoAd(posIdRewardVideo);
```

###   Banner ⼴告
```
    *   详情参考 /lib/page/banner_page.dart 或者 lib/main.dart 中的(展示 Banner 广告)
        
        /// 这⾥ BannerAd 是⼀个 Widget ，你可以放到任何 Flutter 组件上
        /// [adId] ⼴告配置 adIdBanner
        // 注意，如果不设置高度，那么会默认填充整个父Widget
        SizedBox(height: 50, child: BannerAdWidget(adId: adIdBanner)));
```

###   原生信息流⼴告
```
    *   详情参考 /lib/page/native_page.dart 或者 lib/main.dart 中的(展示原生信息流广告)
        
        /// 这⾥ NativeAd 是⼀个 Widget ，你可以放到任何 Flutter 组件上
        /// [adId] ⼴告配置 adIdNative
        // 注意，如果不设置高度，那么会默认填充整个父Widget
        SizedBox(height: 310, child: NativeAdWidget(adId: adIdNative)));
```

###  学习天地
**接入学习天地需要适配AppCompat主题.**

    安卓项目的AndroidManifest.xml中，application 标签加入 android:theme="@style/Theme.AppCompat.Light.NoActionBar"