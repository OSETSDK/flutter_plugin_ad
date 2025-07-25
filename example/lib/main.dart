import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_openset_ads/flutter_plugin_ad.dart';
import 'package:flutter_openset_ads_example/page/banner_page.dart';
import 'package:flutter_openset_ads_example/page/native_page.dart';

void main() async {

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: MyHome());
  }
}

class MyHome extends StatefulWidget {
  @override
  _MyHomeState createState() => _MyHomeState();
}

class _MyHomeState extends State<MyHome> {
  //广告测试id
  String appId = "E6097975B89E83D6";

  // 测试开屏id
  String posIdSplash = "7D5239D8D88EBF9B6D317912EDAC6439";

  // 测试 插屏
  String posIdInterstitial = "1D273967F51868AF2C4E080D496D06D0";

  // 全屏视频
  String posIdFullscreenVideo = "D879C3DED01D5CE319CD2751474BA8E4";

  // 测试激励视频
  String posIdRewardVideo = "09A177D681D6FB81241C3DCE963DCB46";

  // 测试 短视频内容
  String posIdVideoPage = "2A96205DFDDB8D27C784FF31F0625BA4";

  // 原生信息流
  String posIdInformation = "89FEEA66F9228ED3F6420294B89A902B";

  // Banner id
  String posIdBanner = "107EB50EDFE65EA3306C8318FD57D0B3";

  // 信息流内容
  String posIdNews = "4EC4251D616C69030A161A930A938596";

  //   //ios 广告测试id
  // String appId = "31DC084BB6B04838";
  // // 测试开屏id
  // String posIdSplash = "18666EAA65EC1969E90E982DCA2CB2DD";
  // // 测试 插屏
  // String posIdInterstitial = "351C1A89F8AE79DF62C1B1165A5EAFCC";
  // // 测试激励视频
  // String posIdRewardVideo = "E80DABEF5FD288492D4A9D05BF84E417";

  // // 测试 短视频内容
  // String posIdVideoPage = "E06C7BB2C34605B4CD777EFD590DD4BE";

  // // Banner id
  // String posIdBanner = "7B2BD37383E008B422C93486EACEA11D";

  // // 信息流内容
  // String posIdNews = "3DC16BFC019545395507ED826899B16E";

  String _result = '';
  String _adEvent = '';
  String _platformVersion = 'Unknown';

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      platformVersion = await FlutterPluginAd.platformVersion;
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Adset Demo'),
        ),
        body: Container(
          width: MediaQuery.of(context).size.width,
          child: SingleChildScrollView(
              child: Column(
                children: [
                  Text('Running on: $_platformVersion'),
                  Text('Result: $_result'),
                  Text('onAdEvent: $_adEvent'),
                  ElevatedButton(
                    child: Text('初始化'),
                    onPressed: () {
                      init();
                    },
                  ),
                  ElevatedButton(
                    child: Text('添加广告监听'),
                    onPressed: () {
                      setAdEvent();
                    },
                  ),
                  ElevatedButton(
                    child: Text('请求权限'),
                    onPressed: () {
                      checkAndReqPermission();
                    },
                  ),
                  ElevatedButton(
                    child: Text('展示开屏广告'),
                    onPressed: () {
                      showSplashAd();
                    },
                  ),
                  ElevatedButton(
                    child: Text('展示插屏广告'),
                    onPressed: () {
                      showInterstitialAd();
                    },
                  ),
                  ElevatedButton(
                    child: Text('展示全屏视频广告'),
                    onPressed: () {
                      showFullscreenVideoAd();
                    },
                  ),
                  SizedBox(height: 6),
                  ElevatedButton(
                    child: Text('展示激励视频广告'),
                    onPressed: () {
                      showRewardVideoAd();
                    },
                  ),
                  ElevatedButton(
                    child: Text('展示 Banner 广告'),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BannerPage(),
                          ));
                    },
                  ),
                  ElevatedButton(
                    child: Text('展示原生信息流广告'),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => NativePage(),
                          ));
                    },
                  ),
                  ElevatedButton(
                    child: Text('短视频内容'),
                    onPressed: () {
                      showVideoPage();
                    },
                  ),
                  ElevatedButton(
                    child: Text('短视频内容首页'),
                    onPressed: () {
                      showKsVideoFragment();
                    },
                  ),
                ],
              )),
        ));
  }

  /// 初始化广告 SDK
  Future<void> init() async {
    try {
      bool result = await FlutterPluginAd.initAd(appId, isDebug: true);
      _result = "广告SDK 初始化${result ? '成功' : '失败'}";
    } on PlatformException catch (e) {
      _result =
      "广告SDK 初始化失败 code:${e.code} msg:${e.message} details:${e.details}";
    }
    setState(() {});
  }

  /// 请求权限
  Future<void> checkAndReqPermission() async {
    try {
      bool result = await FlutterPluginAd.checkAndReqPermission();
      _result = "广告SDK 权限请求${result ? '成功' : '失败'}";
    } on PlatformException catch (e) {
      _result =
      "广告SDK 权限请求失败 code:${e.code} msg:${e.message} details:${e.details}";
    }
    setState(() {});
  }

  /// 设置广告监听
  Future<void> setAdEvent() async {
    setState(() {
      _adEvent = '设置成功';
    });
    FlutterPluginAd.onEventListener((event) {
      setState(() {
        print(
            'adEvent -> adType:${event.adType} type:${event.eventType} msg:${event.msg}');
        _adEvent =
        'adType:${event.adType} type:${event.eventType} msg:${event.msg}';
        // eventType 为 KsVideoFragment， event.msg  为tab的index的值
        if (event.eventType == "KsVideoFragment" && event.msg == "999") {
          // SystemNavigator.pop(animated: true);
        } else if (event.eventType == "onAdTimeOver" &&
            event.adType == "videoContent") {
          // 短视频单次奖励回调
        }
      });
    });
  }

  /// 展示开屏广告
  Future<void> showSplashAd() async {
    try {
      bool result = await FlutterPluginAd.showSplashAd(posIdSplash);
      _result = "展示开屏广告${result ? '成功' : '失败'}";
    } on PlatformException catch (e) {
      _result = "展示开屏广告失败 code:${e.code} msg:${e.message} details:${e.details}";
    }
    setState(() {});
  }

  /// 展示插屏广告
  Future<void> showInterstitialAd() async {
    try {
      bool result = await FlutterPluginAd.showInterstitialAd(posIdInterstitial);
      _result = "插屏广告${result ? '成功' : '失败'}";
    } on PlatformException catch (e) {
      _result = "插屏广告失败 code:${e.code} msg:${e.message} details:${e.details}";
    }
    setState(() {});
  }

  /// 展示全屏视频广告
  Future<void> showFullscreenVideoAd() async {
    try {
      bool result =
      await FlutterPluginAd.showFullscreenVideoAd(posIdFullscreenVideo);
      _result = "全屏视频广告${result ? '成功' : '失败'}";
    } on PlatformException catch (e) {
      _result = "全屏视频广告失败 code:${e.code} msg:${e.message} details:${e.details}";
    }
    setState(() {});
  }

  /// 展示激励视频广告
  Future<void> showRewardVideoAd() async {
    try {
      bool result =
      await FlutterPluginAd.showRewardVideoAd(posIdRewardVideo, "userId");
      _result = "激励视频广告${result ? '成功' : '失败'}";
    } on PlatformException catch (e) {
      _result = "激励视频广告失败 code:${e.code} msg:${e.message} details:${e.details}";
    }
    setState(() {});
  }

  Future<void> showVideoPage() async {
    try {
      bool result = await FlutterPluginAd.showVideoPage(posIdVideoPage, 2, 30);
      _result = "短视频内容页${result ? '成功' : '失败'}";
    } on PlatformException catch (e) {
      _result = "短视频内容页 code:${e.code} msg:${e.message} details:${e.details}";
    }
    setState(() {});
  }

  Future<void> showKsVideoFragment() async {
    try {
      await FlutterPluginAd.showKsVideoFragment(posIdVideoPage);
    } on PlatformException catch (e) {
      _result = "短视频内容首页 code:${e.code} msg:${e.message} details:${e.details}";
    }
    setState(() {});
  }
}
