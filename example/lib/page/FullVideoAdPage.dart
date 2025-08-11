import 'dart:io';

import 'package:example/common/Common.dart';
import 'package:example/widget/common_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_openset_ads/loader/OSETFullVideoAdLoader.dart';

class FullVideoAdPage extends StatefulWidget {
  const FullVideoAdPage({super.key});

  @override
  State<StatefulWidget> createState() => _FullVideoAdState();
}

class _FullVideoAdState extends State<FullVideoAdPage> {
  final OSETFullVideoAdLoader _fullVideoAdLoader = OSETFullVideoAdLoader();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("全屏视频")),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 40.0,
              horizontal: 24.0,
            ),
            child: SizedBox(
              width: double.infinity,
              child: buildCommonButton(
                '展示全屏广告',
                callback: () {
                  _loadFullVideoAd(loadThenShow: true);
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
    _fullVideoAdLoader.onAdLoad = (osetAd) {
      print('全屏广告加载成功...');
    };

    // 设置广告加载失败监听
    _fullVideoAdLoader.onAdFailed = (msg) {
      print('全屏广告加载失败, $msg');
    };

    // 设置广告展示监听
    _fullVideoAdLoader.onAdExpose = (osetAd) {
      print('全屏广告展示成功...');
    };

    // 设置广告被点击监听
    _fullVideoAdLoader.onAdClick = (osetAd) {
      print('全屏广告被点击...');
    };

    // 设置广告关闭监听
    _fullVideoAdLoader.onAdClose = (osetAd) {
      print('全屏广告被关闭...');
    };
  }

  @override
  void dispose() {
    /// 释放广告
    _fullVideoAdLoader.release();
    super.dispose();
  }

  /// 加载全屏广告
  void _loadFullVideoAd({required bool loadThenShow}) {
    _fullVideoAdLoader.loadAd(
      // 广告位ID，不同端的广告位ID可能不一致，需替换成自己相应端的广告位ID
      posId:
          Platform.isAndroid
              ? Common.androidPosIdFullscreenVideo
              : Common.iosPosIdFullscreenVideo,
    );
  }
}
