import 'dart:io';
import 'dart:math';

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_openset_ads/OSETAdSDK.dart';
import 'package:flutter_openset_ads/widget/banner/OSETBannerAd.dart';

/// Banner 广告组件
class OSETBannerWidget extends StatefulWidget {
  final OSETBannerAd osetBannerAd;
  final String viewType;

  const OSETBannerWidget(
      {super.key, required this.osetBannerAd, this.viewType = OSETAdSDK.viewTypeOSETBannerAd});

  @override
  _BannerAdWidgetState createState() => OSETBannerAdState();
}

class _BannerAdWidgetState<T extends OSETBannerWidget> extends State<T> {
  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> creationParams = <String, dynamic>{
      OSETAdSDK.keyPosId: widget.osetBannerAd.posId,
      OSETAdSDK.keyAdId: widget.osetBannerAd.adId,
      OSETAdSDK.keyAdWidth: widget.osetBannerAd.adWidth,
    };
    return widget.osetBannerAd.adClosed
        ? SizedBox(width: widget.osetBannerAd.adWidth, height: 0)
        : Container(
      width: widget.osetBannerAd.adWidth,
      height: max(widget.osetBannerAd.adHeight, 1),
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

  void update() {
    setState(() {});
  }
}

class OSETBannerAdState extends _BannerAdWidgetState<OSETBannerWidget> {}
