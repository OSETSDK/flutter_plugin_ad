import 'package:flutter_openset_ads/OSETAdSDK.dart';
import 'package:flutter_openset_ads/loader/OSETAdLoader.dart';
import 'package:flutter_openset_ads/widget/banner/OSETBannerAd.dart';
import 'package:flutter_openset_ads/widget/banner/OSETBannerWidget.dart';

class OSETBannerAdLoader extends OSETAdLoader<OSETBannerAd> {
  /// 加载banner广告
  loadAd({
    required String posId,
    required double adWidth,
    required double adHeight,
  }) {
    load(posId: posId, methodName: OSETAdSDK.methodLoadBannerAd, arguments: {
      OSETAdSDK.keyPosId: posId,
      OSETAdSDK.keyAdWidth: adWidth,
    });
  }

  @override
  OSETBannerAd createOSETAd(
      {required String adId, required Map<String, dynamic>? arguments}) {
    return OSETBannerAd(
      adId: adId,
      posId: arguments?[OSETAdSDK.keyPosId],
      adWidth: arguments?[OSETAdSDK.keyAdWidth] ?? double.infinity,
      adHeight: arguments?[OSETAdSDK.keyAdHeight] ?? double.infinity,
    );
  }

  @override
  onAdLoadCallback(OSETBannerAd osetAd) {
    osetAd.bannerWidget = OSETBannerWidget(
      osetBannerAd: osetAd,
    );
    return super.onAdLoadCallback(osetAd);
  }
}
