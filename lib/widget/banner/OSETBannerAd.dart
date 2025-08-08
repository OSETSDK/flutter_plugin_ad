import 'package:flutter_openset_ads/OSETAd.dart';
import 'package:flutter_openset_ads/widget/banner/OSETBannerWidget.dart';

class OSETBannerAd extends OSETAd {
  final String posId;
  final double adWidth;
  final double adHeight;
  bool adClosed = false;

  OSETBannerWidget? bannerWidget;

  OSETBannerAd({
    required super.adId,
    required this.posId,
    required this.adWidth,
    required this.adHeight,
  });
}
