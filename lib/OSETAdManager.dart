import 'package:flutter_openset_ads/OSETAd.dart';
import 'package:flutter_openset_ads/OSETAdSDK.dart';
import 'package:flutter_openset_ads/loader/OSETAdLoader.dart';

class OSETAdManager {
  static const _eventOnAdLoaded = 'onAdLoaded';
  static const _eventOnAdLoadFail = 'onAdError';
  static const _eventOnAdExpose = 'onAdExposure';
  static const _eventOnAdClick = 'onAdClicked';
  static const _eventOnAdClose = 'onAdClosed';
  static const _eventOnAdReward = 'onReward';
  static const _eventOnAdTimeOver = 'onAdTimeOver';

  static final List<OSETAdLoader> _adLoaderList = [];

  OSETAdManager._();

  /// 加载广告
  static loadAd({
    required OSETAdLoader osetLoader,
    required String posId,
    required String methodName,
    Map<String, dynamic>? arguments,
  }) async {
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

  /// 广告事件
  static onAdEvent({required Map<dynamic, dynamic> arguments}) {
    var adId = arguments[OSETAdSDK.keyAdId];
    var OSETAdLoader = _findOSETAdLoader(adId);
    if (OSETAdLoader == null) return;

    var adEvent = arguments[OSETAdSDK.keyAdEvent];
    if (adEvent == null) return;

    var osetAd = OSETAdLoader.findOSETAd(adId: adId);
    if (osetAd == null) return;

    switch (adEvent) {
      case _eventOnAdLoaded:
        OSETAdLoader.onAdLoadCallback(osetAd);
        break;
      case _eventOnAdLoadFail:
        OSETAdLoader.onAdFailedCallback(arguments[OSETAdSDK.keyAdMsg]);
        break;
      case _eventOnAdExpose:
        OSETAdLoader.onAdExposeCallback(osetAd);
        break;
      case _eventOnAdClick:
        OSETAdLoader.onAdClickCallback(osetAd);
        break;
      case _eventOnAdClose:
        OSETAdLoader.onAdCloseCallback(osetAd);
        break;
      case _eventOnAdReward:
        OSETAdLoader.onAdRewardCallback(osetAd);
        break;
      case _eventOnAdTimeOver:
        OSETAdLoader.onAdTimeOverCallback(osetAd);
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