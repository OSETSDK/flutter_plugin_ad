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
      OSETAdSDK.keyAdHeight: adHeight,
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

  /// 广告视图测量回调
  onAdMeasured(OSETBannerAd osetAd, double width, double height) {
    print('adset_plugin 广告试图测量高度回调 $height');
    if (osetAd.refreshAdHeight(height)) {
      _checkUpdateWidget(osetAd);
    }
  }

  /// 尝试更新广告视图
  void _checkUpdateWidget(OSETBannerAd osetAd) {
    var mounted = osetAd.globalKey?.currentState?.mounted ?? false;
    if (mounted) {
      osetAd.globalKey?.currentState?.update();
    }
  }
}
