import 'package:flutter_openset_ads/OSETAdSDK.dart';
import 'package:flutter_openset_ads/loader/OSETAdLoader.dart';
import 'package:flutter_openset_ads/widget/banner/OSETBannerAd.dart';
import 'package:flutter_openset_ads/widget/banner/OSETBannerWidget.dart';

class OSETBannerAdLoader extends OSETAdLoader<OSETBannerAd> {
  /// 加载banner广告
  loadAd({
    required String posId,
    required int adWidth,
    required int adHeight,
  }) {
    if (adWidth <= 0 || adHeight <= 0) {
      print("广告宽度和高度必须大于0!");
      throw ArgumentError("广告宽度和高度必须大于0");
    }

    load(posId: posId, methodName: OSETAdSDK.methodLoadBannerAd, arguments: {
      OSETAdSDK.keyAdWidth: adWidth,
      OSETAdSDK.keyAdHeight: adHeight,
    });
  }

  @override
  onAdLoadCallback(OSETBannerAd osetAd) {
    osetAd.bannerWidget = OSETBannerWidget(
        osetBannerAd: osetAd, viewType: OSETAdSDK.viewTypeOSETBannerAd);
    return super.onAdLoadCallback(osetAd);
  }

  @override
  OSETBannerAd createOSETAd(
      {required String adId, required Map<String, dynamic>? arguments}) {
    return OSETBannerAd(
        adId: adId,
        posId: arguments?[OSETAdSDK.keyPosId],
        adWidth: arguments?[OSETAdSDK.keyAdWidth],
        adHeight: arguments?[OSETAdSDK.keyAdHeight]);
  }
}
