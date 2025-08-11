import 'package:flutter/cupertino.dart';
import 'package:flutter_openset_ads/OSETAd.dart';
import 'package:flutter_openset_ads/widget/banner/OSETBannerWidget.dart';

class OSETBannerAd extends OSETAd {
  GlobalKey<OSETBannerAdState>? globalKey;

  final String posId;
  final double adWidth;
  double adHeight;
  bool adClosed = false;

  OSETBannerWidget? bannerWidget;

  OSETBannerAd({
    required super.adId,
    required this.posId,
    required this.adWidth,
    required this.adHeight,
  });
  bool refreshAdHeight(double height) {
    if (adHeight != height) {
      adHeight = height;
      return true;
    }
    return false;
  }
}
