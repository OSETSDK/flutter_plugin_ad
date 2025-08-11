import 'dart:io';

import 'package:example/common/Common.dart';
import 'package:example/widget/common_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_openset_ads/loader/OSETInterstitialAdLoader.dart';

class InterstitialAdPage extends StatefulWidget {
  const InterstitialAdPage({super.key});

  @override
  State<StatefulWidget> createState() => _InterstitialState();
}

class _InterstitialState extends State<InterstitialAdPage> {
  final OSETInterstitialAdLoader _interstitialAdLoader = OSETInterstitialAdLoader();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("插屏广告")),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 40.0, horizontal: 24.0),
            child: SizedBox(
              width: double.infinity,
              child: buildCommonButton(
                '展示插屏广告',
                callback: () {
                  _loadInterstitialAd(loadThenShow: true);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    // 设置广告加载成功监听
    _interstitialAdLoader.onAdLoad = (osetAd) {
      print('插屏广告加载成功...');
    };

    // 设置广告加载失败监听
    _interstitialAdLoader.onAdFailed = (msg) {
      print('插屏广告加载失败, $msg');
    };

    // 设置广告展示监听
    _interstitialAdLoader.onAdExpose = (osetAd) {
      print('插屏广告展示成功...');
    };

    // 设置广告被点击监听
    _interstitialAdLoader.onAdClick = (osetAd) {
      print('插屏广告被点击...');
    };

    // 设置广告关闭监听
    _interstitialAdLoader.onAdClose = (osetAd) {
      print('插屏广告被关闭...');
    };
  }

  @override
  void dispose() {
    /// 释放广告
    _interstitialAdLoader.release();
    super.dispose();
  }

  /// 加载插屏广告
  void _loadInterstitialAd({required bool loadThenShow}) {
    // 加载插屏广告
    _interstitialAdLoader.loadAd(
      // 广告位ID，不同端的广告位ID可能不一致，需替换成自己相应端的广告位ID
      posId:
          Platform.isAndroid
              ? Common.androidPosIdInterstitial
              : Common.iosPosIdInterstitial,
    );
  }
}
