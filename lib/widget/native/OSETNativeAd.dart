import 'package:flutter_openset_ads/OSETAd.dart';
import 'package:flutter_openset_ads/widget/native/OSETNativeWidget.dart';

class OSETNativeAd extends OSETAd {
  final String posId;
  final double adWidth;
  final double adHeight;

  OSETNativeWidget? nativeAdWidget;

  OSETNativeAd(
      {required super.adId,
      required this.posId,
      required this.adWidth,
      required this.adHeight});
}
