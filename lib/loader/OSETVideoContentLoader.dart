import 'package:flutter_openset_ads/OSETAd.dart';
import 'package:flutter_openset_ads/OSETAdSDK.dart';
import 'package:flutter_openset_ads/loader/OSETAdLoader.dart';
import 'package:flutter_openset_ads/widget/OSETVideoContentAd.dart';

class OSETVideoContentLoader extends OSETAdLoader<OSETAd> {
  /// 加载短视频广告
  loadAd({
    required String posId,
    bool standPage = true,
    int rewardCount = 0,
    int rewardDownTime = 0,
  }) {
    load(
      posId: posId,
      methodName: standPage
          ? OSETAdSDK.methodShowVideoPage
          : OSETAdSDK.methodShowKsVideoFragment,
      arguments: {
        OSETAdSDK.keyRewardCount: rewardCount,
        OSETAdSDK.keyRewardDownTime: rewardDownTime
      },
    );
  }

  @override
  OSETAd createOSETAd(
      {required String adId, required Map<String, dynamic>? arguments}) {
    return OSETVideoContentAd(
      adId: adId,
      rewardCount: arguments?[OSETAdSDK.keyRewardCount],
      rewardDownTime: arguments?[OSETAdSDK.keyRewardDownTime],
    );
  }
}
