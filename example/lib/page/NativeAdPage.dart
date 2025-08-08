import 'dart:io';

import 'package:example/common/Common.dart';
import 'package:example/widget/common_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_openset_ads/loader/OSETNativeAdLoader.dart';
import 'package:flutter_openset_ads/widget/native/OSETNativeWidget.dart';

import '../main.dart';

class NativeAdPage extends StatefulWidget {
  const NativeAdPage({super.key});

  @override
  State<StatefulWidget> createState() => _NativeState();
}

class _NativeState extends State<NativeAdPage> {
  final OSETNativeAdLoader _nativeAdLoader = OSETNativeAdLoader();
  OSETNativeWidget? _nativeAd;
  bool _loading = false;
  bool _visible = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("信息流广告")),
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
                '加载原生信息流',
                callback: () {
                  _loadNativeAd();
                },
              ),
            ),
          ),

          /// 信息流模板广告
          Visibility(
            visible: _visible,
            child: Container(
              width: double.infinity,
              height: 350,
              margin: const EdgeInsets.only(top: 24),
              child: _nativeAd,
            ),
          ),
        ],
      ),
    );
  }

  /// 加载信息流广告
  /// loadThenShow 广告加载成功后是否立即展示
  void _loadNativeAd() {
    if (_loading) return;
    _loading = true;
    // 加载信息流广告
    _nativeAdLoader.loadAd(
      // 广告位ID，不同端的广告位ID可能不一致，需替换成自己相应端的广告位ID
      posId:
      Platform.isAndroid
          ? Common.androidPosIdNative
          : Common.iosPosIdNative,
      // 广告宽度
      adWidth: MediaQuery.of(context).size.width,
    );
  }

  @override
  void initState() {
    super.initState();

    // 设置广告加载成功监听
    _nativeAdLoader.onAdLoad = (osetAd) {
      setState(() {
        _nativeAd = osetAd.nativeWidget;
      });
      _loading = false;
      print('$TAG 信息流广告加载成功...');
    };

    // 设置广告加载失败监听
    _nativeAdLoader.onAdFailed = (msg) {
      _loading = false;
      print('$TAG 信息流广告加载失败, $msg');
    };

    // 设置广告展示监听
    _nativeAdLoader.onAdExpose = (osetAd) {
      print('$TAG 信息流广告展示成功...');
    };

    // 设置广告被点击监听
    _nativeAdLoader.onAdClick = (osetAd) {
      print('$TAG 信息流广告被点击...');
    };

    // 设置广告关闭监听
    _nativeAdLoader.onAdClose = (osetAd) {
      print('$TAG 信息流广告被关闭...');
    };
  }

  @override
  void dispose() {
    /// 释放广告
    _nativeAdLoader.release();
    super.dispose();
  }
}
