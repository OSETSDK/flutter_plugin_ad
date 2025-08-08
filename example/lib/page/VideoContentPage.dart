import 'dart:io';

import 'package:example/common/Common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_openset_ads/loader/OSETVideoContentLoader.dart';

import '../main.dart';
import '../widget/common_button.dart';

class VideoContentPage extends StatefulWidget {
  const VideoContentPage({super.key});

  @override
  State<StatefulWidget> createState() => _VideoContentState();
}

class _VideoContentState extends State<VideoContentPage> {
  final OSETVideoContentLoader _videoContentLoader = OSETVideoContentLoader();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("视频内容")),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 20.0,
              horizontal: 24.0,
            ),
            child: SizedBox(
              width: double.infinity,
              child: buildCommonButton(
                '展示视频到单独页面',
                callback: () {
                  _loadVideoContent(
                    standPage: true,
                    rewardCount: 2,
                    rewardDownTime: 5,
                  );
                },
              ),
            ),
          ),
          // Padding(
          //   padding: const EdgeInsets.symmetric(
          //     vertical: 20.0,
          //     horizontal: 24.0,
          //   ),
          //   child: SizedBox(
          //     width: double.infinity,
          //     child: buildCommonButton(
          //       '展示视频到首页',
          //       callback: () {
          //         _loadVideoContent(standPage: false);
          //       },
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _videoContentLoader.onAdLoad = (osetAd) {
      print('$TAG 短视频加载成功...');
    };
    _videoContentLoader.onAdFailed = (msg) {
      print('$TAG 短视频加载失败, $msg');
    };
    _videoContentLoader.onAdTimeOver = (osetAd) {
      print('$TAG 短视频回调奖励...');
    };
  }

  @override
  void dispose() {
    /// 释放广告
    _videoContentLoader.release();
    super.dispose();
  }

  /// 加载广告
  void _loadVideoContent({
    bool standPage = true,
    int rewardCount = 0,
    int rewardDownTime = 0,
  }) {
    _videoContentLoader.loadAd(
      // 广告位ID，不同端的广告位ID可能不一致，需替换成自己相应端的广告位ID
      posId:
          Platform.isAndroid
              ? Common.androidPosIdVideoPage
              : Common.iosPosIdVideoPage,
      standPage: standPage,
      rewardCount: rewardCount,
      rewardDownTime: rewardDownTime,
    );
  }
}
