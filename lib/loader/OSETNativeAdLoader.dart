import 'package:flutter_openset_ads/OSETAdSDK.dart';
import 'package:flutter_openset_ads/loader/OSETAdLoader.dart';
import 'package:flutter_openset_ads/widget/native/OSETNativeAd.dart';
import 'package:flutter_openset_ads/widget/native/OSETNativeWidget.dart';

class OSETNativeAdLoader extends OSETAdLoader<OSETNativeAd> {
  /// 加载广告
  loadAd({
    required String posId,
    required double adWidth,
    required double adHeight,
  }) {
    load(posId: posId, methodName: OSETAdSDK.methodLoadNativeAd,
        arguments: {
          OSETAdSDK.keyAdWidth: adWidth,
          OSETAdSDK.keyAdHeight: adHeight,
        });
  }

  @override
  onAdLoadCallback(OSETNativeAd osetAd) {
    osetAd.nativeAdWidget = OSETNativeWidget(
        osetNativeAd: osetAd, viewType: OSETAdSDK.viewTypeOSETNativeAd);
    return super.onAdLoadCallback(osetAd);
  }

  @override
  OSETNativeAd createOSETAd(
      {required String adId, required Map<String, dynamic>? arguments}) {
    return OSETNativeAd(adId: adId,
        posId: arguments?[OSETAdSDK.keyPosId],
        adWidth: arguments?[OSETAdSDK.keyAdWidth],
        adHeight: arguments?[OSETAdSDK.keyAdHeight]);
  }

}