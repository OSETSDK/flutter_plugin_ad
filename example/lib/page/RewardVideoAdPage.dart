import 'dart:io';

import 'package:example/common/Common.dart';
import 'package:example/widget/common_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_openset_ads/loader/OSETRewardVideoAdLoader.dart';

import '../main.dart';

class RewardVideoAdPage extends StatefulWidget {
  const RewardVideoAdPage({super.key});

  @override
  State<StatefulWidget> createState() => _RewardVideoAdState();
}

class _RewardVideoAdState extends State<RewardVideoAdPage> {
  final OSETRewardVideoAdLoader _rewardVideoAdLoader =
      OSETRewardVideoAdLoader();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("激励广告")),
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
                '展示激励广告',
                callback: () {
                  _loadRewardVideoAd();
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
    _rewardVideoAdLoader.onAdLoad = (osetAd) {
      print('$TAG 激励广告加载成功...');
    };

    // 设置广告加载失败监听
    _rewardVideoAdLoader.onAdFailed = (msg) {
      print('$TAG 激励广告加载失败, $msg');
    };

    // 设置广告展示监听
    _rewardVideoAdLoader.onAdExpose = (osetAd) {
      print('$TAG 激励广告展示成功...');
    };

    // 设置广告奖励监听
    _rewardVideoAdLoader.onAdReward = (osetAd) {
      print('$TAG 激励广告奖励发放成功...');
    };

    // 设置广告被点击监听
    _rewardVideoAdLoader.onAdClick = (osetAd) {
      print('$TAG 激励广告被点击...');
    };

    // 设置广告关闭监听
    _rewardVideoAdLoader.onAdClose = (osetAd) {
      print('$TAG 激励广告被关闭...');
    };
  }

  @override
  void dispose() {
    /// 释放广告
    _rewardVideoAdLoader.release();
    super.dispose();
  }

  /// 加载激励广告
  void _loadRewardVideoAd() {
    // 加载激励广告
    _rewardVideoAdLoader.loadAd(
      // 广告位ID，不同端的广告位ID可能不一致，需替换成自己相应端的广告位ID
      posId:
          Platform.isAndroid
              ? Common.androidPosIdRewardVideo
              : Common.iosPosIdRewardVideo,
      userId: '123',
    );
  }
}
