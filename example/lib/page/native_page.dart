import 'package:flutter/material.dart';
import 'package:flutter_openset_ads/view/native_ad_widget.dart';

/// 原生信息流广告页面
class NativePage extends StatefulWidget {
  NativePage() : super();

  @override
  _NativePageState createState() => _NativePageState();
}

class _NativePageState extends State<NativePage> {
  //原生
  String posIdNative = "89FEEA66F9228ED3F6420294B89A902B";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('原生广告'),
        ),
        body: SizedBox(height: 200, child: NativeAdWidget(adId: posIdNative)));
  }
}
