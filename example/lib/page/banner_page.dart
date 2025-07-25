import 'package:flutter/material.dart';
import 'package:flutter_openset_ads/view/banner_ad_widget.dart';

/// Banner 广告页面
class BannerPage extends StatefulWidget {
  BannerPage() : super();

  @override
  _BannerPageState createState() => _BannerPageState();
}

class _BannerPageState extends State<BannerPage> {
  //横幅
  String posIdBanner = "107EB50EDFE65EA3306C8318FD57D0B3";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Banner 广告'),
      ),
        body: SizedBox(height: 200, child: BannerAdWidget(adId: posIdBanner)));
  }
}
