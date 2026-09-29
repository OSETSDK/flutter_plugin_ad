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
                  buildCommonButton('初始化（默认隐私配置）', callback: initAd),
                  buildCommonButton('初始化（自定义隐私合规配置）',
                      callback: initAdWithPrivacyConfig),
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
                ],
              )),
        ));
  }

  /// 初始化广告 SDK
  void initAd() async {
    await _initAd();
  }

  /// 初始化广告 SDK（Android 自定义隐私合规配置）
  ///
  /// 隐私合规配置必须在用户同意 App 隐私政策之后再下发，并且只在初始化时生效，
  /// 因此需要在 initAd 中一次性传入。iOS 端会忽略该配置。
  void initAdWithPrivacyConfig() async {
    final privacyConfig = OSETPrivacyConfig(
      // 关闭个性化广告
      canUsePersonalizedAd: false,
      // 禁止 SDK 主动采集硬件参数（imei/meid/imsi/iccid）
      canUsePhoneState: false,
      // 禁止 SDK 主动读取 androidId
      canUseAndroidId: false,
      // 禁止 SDK 主动获取 oaid
      canUseOaid: false,
      // 禁止 SDK 主动获取地理位置
      canReadLocation: false,
      // 禁止 SDK 主动读取 App 安装列表
      canReadInstalledPackages: false,
      // 禁止 SDK 主动使用传感器
      canUseSensor: false,
    );
    await _initAd(privacyConfig: privacyConfig);
  }

  Future<void> _initAd({OSETPrivacyConfig? privacyConfig}) async {
    try {
      final InitAdResult result = await OSETAdSDK.initAd(
          appKey: Platform.isAndroid ? Common.androidAppId : Common.iosAppId,
          debug: true,
          privacyConfig: privacyConfig);
      _result = result.success
          ? "广告SDK 初始化成功"
          : "广告SDK 初始化失败 code:${result.code} msg:${result.msg}";
    } on PlatformException catch (e) {
      _result =
      "广告SDK 初始化失败 code:${e.code} msg:${e.message} details:${e.details}";
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
