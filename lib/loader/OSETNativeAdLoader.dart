import 'package:flutter/cupertino.dart';
import 'package:flutter_openset_ads/OSETAdSDK.dart';
import 'package:flutter_openset_ads/loader/OSETAdLoader.dart';
import 'package:flutter_openset_ads/widget/native/OSETNativeAd.dart';
import 'package:flutter_openset_ads/widget/native/OSETNativeWidget.dart';

class OSETNativeAdLoader extends OSETAdLoader<OSETNativeAd> {
  /// 加载广告
  loadAd({
    required String posId,
    required double adWidth,
  }) {
    load(posId: posId, methodName: OSETAdSDK.methodLoadNativeAd, arguments: {
      OSETAdSDK.keyPosId: posId,
      OSETAdSDK.keyAdWidth: adWidth,
    });
  }

  @override
  OSETNativeAd createOSETAd(
      {required String adId, required Map<String, dynamic>? arguments}) {
    return OSETNativeAd(
      adId: adId,
      posId: arguments?[OSETAdSDK.keyPosId],
      adWidth: arguments?[OSETAdSDK.keyAdWidth] ?? double.infinity,
    );
  }

  @override
  onAdLoadCallback(OSETNativeAd osetAd) {
    osetAd.globalKey = GlobalKey();
    osetAd.nativeWidget = OSETNativeWidget(
        key: osetAd.globalKey,
        osetNativeAd: osetAd);
    return super.onAdLoadCallback(osetAd);
  }

  @override
  onAdCloseCallback(OSETNativeAd osetAd) {
    if (osetAd.refreshAdClosed()) {
      _checkUpdateWidget(osetAd);
    }
    return super.onAdCloseCallback(osetAd);
  }

  /// 广告视图测量回调
  onAdMeasured(OSETNativeAd osetAd, double width, double height) {
    if (osetAd.refreshAdHeight(height)) {
      _checkUpdateWidget(osetAd);
    }
  }

  /// 尝试更新广告视图
  void _checkUpdateWidget(OSETNativeAd osetAd) {
    var mounted = osetAd.globalKey?.currentState?.mounted ?? false;
    if (mounted) {
      osetAd.globalKey?.currentState?.update();
    }
  }
}
