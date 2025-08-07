import 'package:flutter_openset_ads/OSETAd.dart';
import 'package:flutter_openset_ads/OSETAdSDK.dart';
import 'package:flutter_openset_ads/loader/OSETAdLoader.dart';
import 'package:flutter_openset_ads/widget/OSETRewardAd.dart';

class OSETRewardVideoAdLoader extends OSETAdLoader<OSETAd> {
  /// 加载激励视频广告
  loadAd({required String posId, String userId = ''}) {
    load(
        posId: posId,
        methodName: OSETAdSDK.methodLoadRewardVideoAd,
        arguments: {OSETAdSDK.keyUserId: userId});
  }

  /// 预加载激励广告
  startLoadAd({required String posId, String userId = ''}) {
    load(
        posId: posId,
        methodName: OSETAdSDK.methodStartLoadRewardVideoAd,
        arguments: {OSETAdSDK.keyUserId: userId});
  }

  @override
  OSETAd createOSETAd(
      {required String adId, required Map<String, dynamic>? arguments}) {
    return OSETRewardVideoAd(
        adId: adId, userId: arguments?[OSETAdSDK.keyUserId]);
  }
}
