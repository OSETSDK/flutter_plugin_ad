
import 'package:flutter/services.dart';
import 'package:flutter_openset_ads/OSETAdManager.dart';

class OSETAdSDK {
  /// 方法渠道
  static const MethodChannel _methodChannel = const MethodChannel('flutter_plugin_ad');
  /// 事件渠道
  static const EventChannel _eventChannel = const EventChannel('flutter_plugin_ad_event');

  static const keyAppKey = 'appKey';
  static const keyIsDebug = 'isDebug';
  static const keyPosId = 'posId';
  static const keyAdId = 'adId';
  static const keyAdEvent = 'adEvent';
  static const keyAdWidth = 'adWidth';
  static const keyAdHeight = 'adHeight';
  static const keyUserId = 'userId';
  static const keyAdMsg = 'adMsg';
  static const keyRewardCount = 'rewardCount';
  static const keyRewardDownTime = 'rewardDownTime';

  static const methodGetPlatformVersion = 'getPlatformVersion';
  static const methodCheckAndReqPermission = 'checkAndReqPermission';

  static const methodInit = 'initAd';
  static const methodLoadSplashAd = 'showSplashAd';
  static const methodShowInterstitialAd = 'showInterstitialAd';
  static const methodShowFullVideoAd = 'showFullscreenVideoAd';
  static const methodStartLoadRewardVideoAd = 'startLoadRewardVideoAd';
  static const methodLoadRewardVideoAd = 'showRewardVideoAd';
  static const methodLoadBannerAd = "loadBannerAd";
  static const methodLoadNativeAd = "loadNativeAd";
  static const methodShowVideoPage = "showVideoPage";
  static const methodShowKsVideoFragment = "showKsVideoFragment";

  static const methodReleaseAd = 'releaseAd';
  static const methodOnAdEvent = 'onAdEvent';

  static const viewTypeOSETNativeAd = 'flutter_plugin_ad_native';
  static const viewTypeOSETBannerAd = 'flutter_plugin_ad_banner';

  /// 获取系统版本号
  static Future<String> get platformVersion async {
    final String version = await _methodChannel.invokeMethod('getPlatformVersion');
    return version;
  }

  static bool _initialized = false;

  /// 初始化广告SDK
  /// [appKey] 广告配置 appKey
  /// [debug] 是否为测试模式
  static Future<bool> initAd({required String appKey, required bool debug}) async {
    if (_initialized) return Future.value(true);

    // _setupMethodCallHandler();
    _setupEventCallHandler();
    var success = await invokeMethod(method: methodInit, params: {
      keyAppKey: appKey,
      keyIsDebug: debug
    });
    _initialized = success;
    return Future.value(success);
  }

  /// 设置方法监听
  // static void _setupMethodCallHandler() {
  //   _methodChannel.setMethodCallHandler((MethodCall call) async {
  //     // 监听到了原生发送的事件
  //     if (methodOnAdEvent == call.method) {
  //       // 广告回调方法
  //       OSETAdManager.onAdEvent(arguments: call.arguments);
  //     }
  //   });
  // }

  /// 设置事件监听
  static void _setupEventCallHandler() {
    _eventChannel.receiveBroadcastStream().listen((data) {
      if (data != null) {
        // 广告回调方法
        OSETAdManager.onAdEvent(arguments: data);
      }
    });
  }

  /// 请求权限
  /// 仅 Android
  static void checkAndReqPermission() async {
    invokeMethod(method: methodCheckAndReqPermission);
  }

  /// Flutter通知原生端执行相应方法
  static Future<bool> invokeMethod({
    required String method,
    Map<String, dynamic>? params,
  }) async {
    try {
      return await _methodChannel.invokeMethod(method, params ?? {});
    } catch (e) {
      print(e);
    }
    return false;
  }

}