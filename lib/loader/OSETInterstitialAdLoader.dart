
import 'package:flutter_openset_ads/OSETAd.dart';
import 'package:flutter_openset_ads/OSETAdManager.dart';
import 'package:flutter_openset_ads/OSETAdSDK.dart';
import 'package:flutter_openset_ads/loader/OSETAdLoader.dart';

class OSETInterstitialAdLoader extends OSETAdLoader<OSETAd> {
  /// 加载广告
  loadAd({required String posId}) {
    load(
        posId: posId,
        methodName: OSETAdSDK.methodShowInterstitialAd);
  }

  /// 展示插屏广告
  showAd({required OSETAd osetAd}) async {
    await OSETAdManager.invokeMethod(
        method: OSETAdSDK.methodShowInterstitialAd,
        params: {OSETAdSDK.keyAdId: osetAd.adId});
  }

  @override
  OSETAd createOSETAd(
      {required String adId, required Map<String, dynamic>? arguments}) {
    return OSETAd(adId: adId);
  }
}
