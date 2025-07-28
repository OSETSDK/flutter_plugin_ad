import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:flutter/services.dart';

/// Banner 广告组件
class BannerAdWidget extends StatefulWidget {
  BannerAdWidget({Key? key, this.adId, this.height}) : super(key: key);
  // 广告 id
  final String? adId;
  final String? height;

  @override
  _BannerAdWidgetState createState() => _BannerAdWidgetState();
}

class _BannerAdWidgetState extends State<BannerAdWidget> {
  final String viewType = 'flutter_plugin_ad_banner';

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> creationParams = <String, dynamic>{
      "adId": widget.adId,
      "height": widget.height
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
