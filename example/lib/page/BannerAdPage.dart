import 'dart:io';

import 'package:example/common/Common.dart';
import 'package:example/widget/common_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_openset_ads/loader/OSETBannerAdLoader.dart';
import 'package:flutter_openset_ads/widget/banner/OSETBannerWidget.dart';

class BannerAdPage extends StatefulWidget {
  const BannerAdPage({super.key});

  @override
  State<StatefulWidget> createState() => _BannerAdState();
}

class _BannerAdState extends State<BannerAdPage> {
  final OSETBannerAdLoader _bannerAdLoader = OSETBannerAdLoader();
  OSETBannerWidget? _bannerAd;
  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Banner广告")),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(
              top: 40.0,
              left: 24.0,
              right: 24.0,
              bottom: 24.0,
            ),
            child: SizedBox(
              width: double.infinity,
              child: buildCommonButton(
                '加载Banner广告',
                callback: () {
                  _loadBannerAd();
                },
              ),
            ),
          ),

          /// banner广告容器
          SizedBox(
            width: double.infinity,
            child: _bannerAd,
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    // 设置广告加载成功监听
    _bannerAdLoader.onAdLoad = (osetAd) {
      // 将获取到广告模板广告（osetAd.bannerWidget）直接展示
      setState(() {
        _bannerAd = osetAd.bannerWidget;
      });
      _loading = false;
      print('Banner广告加载成功...');
    };

    // 设置广告加载失败监听
    _bannerAdLoader.onAdFailed = (msg) {
      _loading = false;
      print('Banner广告加载失败, $msg');
    };

    // 设置广告展示监听
    _bannerAdLoader.onAdExpose = (osetAd) {
      print('Banner广告展示成功...');
    };

    // 设置广告被点击监听
    _bannerAdLoader.onAdClick = (osetAd) {
      print('Banner广告被点击...');
    };

    // 设置广告关闭监听
    _bannerAdLoader.onAdClose = (osetAd) {
      print('Banner广告被关闭...');
    };
  }

  @override
  void dispose() {
    /// 释放广告
    _bannerAdLoader.release();
    super.dispose();
  }

  /// 加载Banner广告
  void _loadBannerAd() {
    if (_loading) return;
    _loading = true;
    _bannerAdLoader.loadAd(
      // 广告位ID，不同端的广告位ID可能不一致，需替换成自己相应端的广告位ID
      posId:
          Platform.isAndroid
              ? Common.androidPosIdBanner
              : Common.iosPosIdBanner,
      // 广告宽度
      adWidth: MediaQuery.of(context).size.width,
      adHeight: 50
    );
  }
}
