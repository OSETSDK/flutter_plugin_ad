import 'package:flutter_openset_ads/OSETAd.dart';
import 'package:flutter_openset_ads/OSETAdSDK.dart';
import 'package:flutter_openset_ads/loader/OSETAdLoader.dart';
import 'package:flutter_openset_ads/loader/OSETNativeAdLoader.dart';
import 'package:flutter_openset_ads/widget/native/OSETNativeAd.dart';

class OSETAdManager {
  static const _eventOnAdLoaded = 'onAdLoaded';
  static const _eventOnAdLoadFail = 'onAdError';
  static const _eventOnRenderSuccess = 'onAdRenderSuccess';
  static const _eventOnAdExpose = 'onAdExposure';
  static const _eventOnAdClick = 'onAdClicked';
  static const _eventOnAdClose = 'onAdClosed';
  static const _eventOnAdReward = 'onReward';
  static const _eventOnAdTimeOver = 'onAdTimeOver';
  static const _eventOnAdMeasured = 'onAdMeasured';

  static final List<OSETAdLoader> _adLoaderList = [];

  OSETAdManager._();

  /// 加载广告
  static loadAd({
    required OSETAdLoader osetLoader,
    required String posId,
    required String methodName,
    Map<String, dynamic>? arguments,
  }) async {
    if (!OSETAdSDK.initialized()) {
      // 未初始化SDK，请先初始化广告SDK
      invokeMethod(
          method: OSETAdSDK.methodOnToast,
          params: {OSETAdSDK.keyToastMsg: '请先初始化广告SDK'});
      return;
    }

    var contains = _adLoaderList.contains(osetLoader);
    if (!contains) {
      _adLoaderList.add(osetLoader);
    }
    await _loadAd(
      posId: posId,
      methodName: methodName,
      osetLoader: osetLoader,
      arguments: arguments,
    );
  }

  /// 释放广告
  static releaseAd({required OSETAd osetAd}) async {
    await _releaseAd(adId: osetAd.adId);

    var adLoader = _findOSETAdLoader(osetAd.adId);
    adLoader?.adList.remove(osetAd);
  }

  /// 释放广告加载
  static releaseAdLoader({required OSETAdLoader osetAdLoader}) {
    for (var osetAd in osetAdLoader.adList) {
      osetAd.release();
    }
    _adLoaderList.remove(osetAdLoader);
  }

  /// 原生调用flutter广告事件
  static onAdEvent({required Map<dynamic, dynamic> arguments}) {
    var adId = arguments[OSETAdSDK.keyAdId];
    var osetAdLoader = _findOSETAdLoader(adId);
    if (osetAdLoader == null) return;

    var adEvent = arguments[OSETAdSDK.keyAdEvent];
    if (adEvent == null) return;

    var osetAd = osetAdLoader.findOSETAd(adId: adId);
    if (osetAd == null) return;

    print("adset_plugin 原生调用flutter方法：$adEvent");
    switch (adEvent) {
      case _eventOnAdLoaded:
        osetAdLoader.onAdLoadCallback(osetAd);
        break;
      case _eventOnAdLoadFail:
        osetAdLoader.onAdFailedCallback(arguments[OSETAdSDK.keyAdMsg]);
        break;
      case _eventOnRenderSuccess:
        osetAdLoader.onAdRenderSuccessCallBack(osetAd);
        break;
      case _eventOnAdExpose:
        osetAdLoader.onAdExposeCallback(osetAd);
        break;
      case _eventOnAdClick:
        osetAdLoader.onAdClickCallback(osetAd);
        break;
      case _eventOnAdClose:
        osetAdLoader.onAdCloseCallback(osetAd);
        releaseAd(osetAd: osetAd);
        break;
      case _eventOnAdReward:
        osetAdLoader.onAdRewardCallback(osetAd);
        break;
      case _eventOnAdTimeOver:
        osetAdLoader.onAdTimeOverCallback(osetAd);
        break;
      case _eventOnAdMeasured:
        double adWidth = arguments[OSETAdSDK.keyAdWidth] ?? 0;
        double adHeight = arguments[OSETAdSDK.keyAdHeight] ?? 0;
        if (osetAdLoader is OSETNativeAdLoader && osetAd is OSETNativeAd) {
          osetAdLoader.onAdMeasured(osetAd, adWidth, adHeight);
        }
        break;
    }
  }

  /// 加载广告
  static Future<bool> _loadAd({
    required String posId,
    required OSETAdLoader osetLoader,
    required String methodName,
    Map<String, dynamic>? arguments,
  }) async {
    var osetAd = osetLoader.createOSETAd(
      adId: osetLoader.adId,
      arguments: arguments,
    );
    osetLoader.adList.add(osetAd);

    var params = arguments ?? <String, dynamic>{};
    params[OSETAdSDK.keyPosId] = posId;
    params[OSETAdSDK.keyAdId] = osetAd.adId;
    return invokeMethod(method: methodName, params: params);
  }

  /// 加载广告
  static Future<bool> invokeMethod({
    required String method,
    required Map<String, dynamic> params,
  }) async {
    return OSETAdSDK.invokeMethod(method: method, params: params);
  }

  /// 根据adId查找OSETAdLoader
  static OSETAdLoader? _findOSETAdLoader(adId) {
    for (var value in _adLoaderList) {
      if (value.adId == adId) return value;
    }
    return null;
  }

  /// 释放广告
  static Future<bool> _releaseAd({
    required String adId,
  }) async {
    return OSETAdSDK.invokeMethod(method: OSETAdSDK.methodReleaseAd, params: {
      OSETAdSDK.keyAdId: adId,
    });
  }
}