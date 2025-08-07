import 'dart:math';

import 'package:flutter_openset_ads/OSETAd.dart';
import 'package:flutter_openset_ads/OSETAdManager.dart';

abstract class OSETAdLoader<T extends OSETAd> {
  final String _adId = uuid();
  final List<T> _adList = [];

  OnOSETAdEvent<T>? onAdLoad;
  OnOSETAdFailed<String>? onAdFailed;
  OnOSETAdEvent<T>? onAdExpose;
  OnOSETAdEvent<T>? onAdClick;
  OnOSETAdEvent<T>? onAdClose;
  OnOSETAdEvent<T>? onAdReward;
  OnOSETAdEvent<T>? onAdTimeOver;

  String get adId => _adId;

  List<T> get adList => _adList;

  /// 加载广告
  load({
    required String posId,
    required String methodName,
    Map<String, dynamic>? arguments,
  }) {
    OSETAdManager.loadAd(
      osetLoader: this,
      posId: posId,
      methodName: methodName,
      arguments: arguments,
    );
  }

  /// 广告加载成功回调
  onAdLoadCallback(T osetAd) {
    onAdLoad?.call(osetAd);
  }

  /// 广告加载失败回调
  onAdFailedCallback(String? error) {
    onAdFailed?.call(error ?? '');
  }

  /// 广告曝光回调
  onAdExposeCallback(T osetAd) {
    onAdExpose?.call(osetAd);
  }

  /// 广告被点击回调
  onAdClickCallback(T osetAd) {
    onAdClick?.call(osetAd);
  }

  /// 广告被关闭回调
  onAdCloseCallback(T osetAd) {
    onAdClose?.call(osetAd);
  }

  /// 广告奖励回调
  onAdRewardCallback(T osetAd) {
    onAdReward?.call(osetAd);
  }

  /// 短视频奖励回调
  onAdTimeOverCallback(T osetAd) {
    onAdTimeOver?.call(osetAd);
  }

  /// 释放广告
  release() {
    OSETAdManager.releaseAdLoader(osetAdLoader: this);
  }

  /// 根据adId找到广告对象
  T? findOSETAd({required String? adId}) {
    if (adId == null) return null;
    for (var osetAd in _adList) {
      if (osetAd.adId == adId) return osetAd;
    }
    return null;
  }

  /// 创建广告
  T createOSETAd({
    required String adId,
    required Map<String, dynamic>? arguments,
  });
}

typedef OnOSETAdEvent<T extends OSETAd> = void Function(T osetAd);
typedef OnOSETAdFailed<String> = void Function(String error);

const _alphabet = [
  'a',
  'b',
  'c',
  'd',
  'e',
  'f',
  'g',
  'h',
  'i',
  'j',
  'k',
  'l',
  'm',
  'n',
  'o',
  'p',
  'q',
  'r',
  's',
  't',
  'u',
  'v',
  'w',
  'x',
  'y',
  'z',
  '0',
  '1',
  '2',
  '3',
  '4',
  '5',
  '6',
  '7',
  '8',
  '9',
];

String uuid() {
  String uuid = '';
  for (int i = 0; i < 32; i++) {
    uuid = uuid + _alphabet[Random().nextInt(_alphabet.length)];
  }
  return uuid;
}
