
import 'dart:io';

import 'package:example/common/Common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_openset_ads/loader/OSETSplashAdLoader.dart';

class SplashAdLauncherPage extends StatefulWidget {
  const SplashAdLauncherPage({super.key});

  @override
  State<StatefulWidget> createState() => _SplashState();
}

class _SplashState extends State<SplashAdLauncherPage> {
  OSETSplashAdLoader? _splashAdLoader;

  @override
  Widget build(BuildContext context) {
    _showSplashAd();
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: Colors.white,);
  }

  /// 关闭当前页面
  void _closePageSafely() {
    if (mounted) {
      Navigator.of(context).pop();
    }
  }

  @override
  void dispose() {
    _splashAdLoader?.release();
    super.dispose();
  }

  /// 加载展示开屏广告
  void _showSplashAd() {
    _splashAdLoader?.release();

    // 构建开屏广告加载器
    _splashAdLoader = OSETSplashAdLoader();

    // 设置广告加载成功监听
    _splashAdLoader?.onAdLoad = (osetAd) {
      print('开屏广告加载成功...');
    };

    // 设置广告加载失败监听
    _splashAdLoader?.onAdFailed = (msg) {
      print('开屏广告加载失败, $msg');
      _closePageSafely();
    };

    // 设置广告展示监听
    _splashAdLoader?.onAdExpose = (osetAd) {
      print('开屏广告展示成功...' + osetAd.adId);
    };

    // 设置广告被点击监听
    _splashAdLoader?.onAdClick = (osetAd) {
      print('开屏广告被点击...');
    };

    // 设置广告关闭监听
    _splashAdLoader?.onAdClose = (osetAd) {
      print('开屏广告被关闭...');
      _closePageSafely();
    };

    // 加载并展示开屏广告，设置logoName和backgroundName时需确认以下两条规则
    // Android端应在drawable或mipmap中有相应文件
    // iOS端应有相应名字的imageset
    _splashAdLoader?.loadAd(
      // 广告位ID，不同端的广告位ID可能不一致，需替换成自己相应端的广告位ID
      posId: Platform.isAndroid ? Common.androidPosIdSplash : Common.iosPosIdSplash,
    );
  }
}