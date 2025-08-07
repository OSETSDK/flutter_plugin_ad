import 'package:flutter_openset_ads/OSETAd.dart';
import 'package:flutter_openset_ads/OSETAdSDK.dart';
import 'package:flutter_openset_ads/loader/OSETAdLoader.dart';

class OSETFullVideoAdLoader extends OSETAdLoader<OSETAd> {
  /// 加载广告
  loadAd({required String posId}) {
    load(posId: posId, methodName: OSETAdSDK.methodShowFullVideoAd);
  }

  @override
  OSETAd createOSETAd(
      {required String adId, required Map<String, dynamic>? arguments}) {
    return OSETAd(adId: adId);
  }
}
