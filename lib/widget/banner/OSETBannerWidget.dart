import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_openset_ads/OSETAdSDK.dart';
import 'package:flutter_openset_ads/widget/banner/OSETBannerAd.dart';

/// Banner 广告组件
class OSETBannerWidget extends StatefulWidget {
  final OSETBannerAd osetBannerAd;
  final String viewType;

  const OSETBannerWidget(
      {super.key, required this.osetBannerAd, required this.viewType});

  @override
  _BannerAdWidgetState createState() => _BannerAdWidgetState();
}

class _BannerAdWidgetState extends State<OSETBannerWidget> {
  final String viewType = 'flutter_plugin_ad_banner';

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> creationParams = <String, dynamic>{
      OSETAdSDK.keyPosId: widget.osetBannerAd.posId,
      OSETAdSDK.keyAdId: widget.osetBannerAd.adId,
      OSETAdSDK.keyAdWidth: widget.osetBannerAd.adWidth,
      OSETAdSDK.keyAdHeight: widget.osetBannerAd.adHeight,
    };
    return Container(
      width: widget.osetBannerAd.adWidth,
      height: widget.osetBannerAd.adHeight,
      constraints: BoxConstraints(maxWidth: widget.osetBannerAd.adWidth),
      child: Platform.isAndroid
          ? AndroidView(
              viewType: widget.viewType,
              creationParams: creationParams,
              creationParamsCodec: const StandardMessageCodec(),
            )
          : UiKitView(
              viewType: widget.viewType,
              creationParams: creationParams,
              creationParamsCodec: const StandardMessageCodec(),
            ),
    );
  }
}
