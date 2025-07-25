import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:flutter/services.dart';

/// 原生信息流广告组件
class NativeAdWidget extends StatefulWidget {
  NativeAdWidget({Key? key, this.adId}) : super(key: key);
  // 广告 id
  final String? adId;

  @override
  _NativeAdWidgetState createState() => _NativeAdWidgetState();
}

class _NativeAdWidgetState extends State<NativeAdWidget> {
  final String viewType = 'flutter_plugin_ad_native';

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> creationParams = <String, dynamic>{
      "adId": widget.adId
    };
    if (Platform.isIOS) {
      return UiKitView(
        viewType: viewType,
        creationParams: creationParams,
        creationParamsCodec: const StandardMessageCodec(),
      );
    } else {
      return AndroidView(
        viewType: viewType,
        creationParams: creationParams,
        creationParamsCodec: const StandardMessageCodec(),
      );
    }
  }
}
