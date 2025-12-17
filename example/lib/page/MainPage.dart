import 'dart:io';

import 'package:example/page/BannerAdPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_openset_ads/InitAdResult.dart';
import 'package:flutter_openset_ads/OSETAdSDK.dart';

import '../common/Common.dart';
import '../widget/common_button.dart';
import 'SplashAdLauncherPage.dart';
import 'InterstitialAdPage.dart';
import 'FullVideoAdPage.dart';
import 'RewardVideoAdPage.dart';
import 'NativeAdPage.dart';
import 'VideoContentPage.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<StatefulWidget> createState() => _MainState();
}

class _MainState extends State<MainPage> {

  String _result = '';
  String _platformVersion = 'Unknown';

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  Future<void> initPlatformState() async {
    String platformVersion;
    try {
      platformVersion = await OSETAdSDK.platformVersion;
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("ADSET Demo")),
        body: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: SingleChildScrollView(
              child: Column(
                children: [
                  Text('Running on: $_platformVersion'),
                  Text('init: $_result'),
                  buildCommonButton('初始化', callback: initAd),
                  buildCommonButton('请求权限', callback: OSETAdSDK.checkAndReqPermission),
                  buildCommonButton('开屏广告', callback: () {
                    _push(context, const SplashAdLauncherPage());
                  }),
                  buildCommonButton('插屏广告', callback: () {
                    _push(context, const InterstitialAdPage());
                  }),
                  buildCommonButton('全屏视频广告', callback: () {
                    _push(context, const FullVideoAdPage());
                  }),
                  buildCommonButton('激励视频广告', callback: () {
                    _push(context, const RewardVideoAdPage());
                  }),
                  buildCommonButton('Banner广告', callback: () {
                    _push(context, const BannerAdPage());
                  }),
                  buildCommonButton('原生信息流广告', callback: () {
                    _push(context, const NativeAdPage());
                  }),
                  buildCommonButton('短视频内容', callback: () {
                    _push(context, const VideoContentPage());
                  }),
                ],
              )),
        ));
  }

  /// 初始化广告 SDK
  void initAd() async {
    final InitAdResult result = await OSETAdSDK.initAd(
        appKey: Platform.isAndroid ? Common.androidAppId : Common.iosAppId,
        debug: true);

    if (result.success) {
      _result = "广告 SDK 初始化成功";
    } else {
      _result = "广告SDK 初始化失败 code:${result.code} msg:${result.msg}";
    }

    setState(() {});
  }

  /// 跳转到指定页面
  void _push(BuildContext context, Widget widget) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return widget;
        },
      ),
    );
  }
}
