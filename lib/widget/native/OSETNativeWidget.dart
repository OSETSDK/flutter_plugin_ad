import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_openset_ads/OSETAdSDK.dart';
import 'package:flutter_openset_ads/widget/native/OSETNativeAd.dart';

/// 原生信息流广告组件
class OSETNativeWidget extends StatefulWidget {
  final OSETNativeAd osetNativeAd;
  final String viewType;

  const OSETNativeWidget(
      {super.key, required this.osetNativeAd, required this.viewType});

  @override
  _NativeAdWidgetState createState() => _NativeAdWidgetState();
}

class _NativeAdWidgetState extends State<OSETNativeWidget> {
  @override
  Widget build(BuildContext context) {
    var creationParams = {
      OSETAdSDK.keyPosId: widget.osetNativeAd.posId,
      OSETAdSDK.keyAdId: widget.osetNativeAd.adId,
      OSETAdSDK.keyAdWidth: widget.osetNativeAd.adWidth,
      OSETAdSDK.keyAdHeight: widget.osetNativeAd.adHeight,
    };
    return Container(
      width: widget.osetNativeAd.adWidth,
      height: widget.osetNativeAd.adHeight,
      constraints: BoxConstraints(maxWidth: widget.osetNativeAd.adWidth),
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
