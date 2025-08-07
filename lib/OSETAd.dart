import 'package:flutter_openset_ads/OSETAdManager.dart';

class OSETAd {
  final String adId;

  OSETAd({
    required this.adId,
  });

  /// 释放广告
  release() {
    OSETAdManager.releaseAd(osetAd: this);
  }
}
