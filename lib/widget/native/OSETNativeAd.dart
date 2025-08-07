import 'package:flutter/cupertino.dart';
import 'package:flutter_openset_ads/OSETAd.dart';
import 'package:flutter_openset_ads/widget/native/OSETNativeWidget.dart';

class OSETNativeAd extends OSETAd {
  GlobalKey<OSETNativeAdState>? globalKey;
  OSETNativeWidget? nativeAdWidget;
  final String posId;
  final double adWidth;
  double adHeight = 0;
  bool adClosed = false;

  OSETNativeAd(
      {required super.adId,
      required this.posId,
      required this.adWidth,});

  @override
  release() {
    globalKey = null;
    return super.release();
  }

  bool refreshAdClosed() {
    if (!adClosed) {
      adClosed = true;
      return true;
    }
    return false;
  }

  bool refreshAdHeight(double height) {
    if (adHeight != height) {
      adHeight = height;
      return true;
    }
    return false;
  }
}
