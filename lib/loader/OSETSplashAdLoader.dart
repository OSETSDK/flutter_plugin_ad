import 'package:flutter_openset_ads/OSETAd.dart';
import 'package:flutter_openset_ads/OSETAdSDK.dart';
import 'package:flutter_openset_ads/loader/OSETAdLoader.dart';

class OSETSplashAdLoader extends OSETAdLoader<OSETAd> {
  loadAd({
    required String posId,
    String userId = '',
  }) {
    load(posId: posId, methodName: OSETAdSDK.methodLoadSplashAd, arguments: {
      OSETAdSDK.keyUserId: userId,
    });
  }

  @override
  OSETAd createOSETAd(
      {required String adId, required Map<String, dynamic>? arguments}) {
    return OSETAd(adId: adId);
  }
}
