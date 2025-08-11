#import "FlutterPluginAdPlugin.h"
#import <AppTrackingTransparency/AppTrackingTransparency.h>
#import <AdSupport/AdSupport.h>
#import "IOSFlutterPlatformViewFactory.h"
#import "IOSFlutterNativeViewFactory.h"

#import "OSETAdModel.h"
#import "OSETFSplashAdManager.h"
#import "OSETFRewardVideoAdManager.h"
#import "OSETFInterstitialAdManager.h"
#import "OSETFFullscreenVideoAdManager.h"

#import "OSETFBannerAdManager.h"
#import "OSETFNativeAdManager.h"


#import "OSETFAdEventManager.h"

// 未知
#define  unknown  @"unknown"
// 广告加载完毕
#define  onAdLoaded  @"onAdLoaded"
// 广告错误
#define  onAdError  @"onAdError"
// 广告展示
#define onAdExposure  @"onAdExposure"
// 广告关闭
#define onAdClosed  @"onAdClosed"
// 广告点击
#define onAdClicked  @"onAdClicked"
// 获得奖励
#define onAdReward  @"onReward"
// 跳过广告
#define onAdSkip  @"onAdSkip"
// 超过广告时间
#define onAdTimeOver  @"onAdTimeOver"


static FlutterPluginAdPlugin *manager = nil;

@implementation FlutterPluginAdPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
 
  FlutterMethodChannel* channel = [FlutterMethodChannel
      methodChannelWithName:@"flutter_plugin_ad"
            binaryMessenger:[registrar messenger]];
  FlutterPluginAdPlugin * instance = [FlutterPluginAdPlugin shareInstance];
  [registrar addMethodCallDelegate:instance channel:channel];
    // 1. 注册事件通道
    FlutterEventChannel* eventChannel = [FlutterEventChannel
        eventChannelWithName:@"flutter_plugin_ad_event"
        binaryMessenger:[registrar messenger]];
    // 2. 设置事件处理为单例管理器
    [eventChannel setStreamHandler:[OSETFAdEventManager sharedManager]];

    [registrar registerViewFactory:[[IOSFlutterPlatformViewFactory alloc] init] withId:@"flutter_plugin_ad_banner"];
    [registrar registerViewFactory:[[IOSFlutterNativeViewFactory alloc] init] withId:@"flutter_plugin_ad_native"];
}
+ (instancetype)shareInstance{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[FlutterPluginAdPlugin alloc] init];
    });
    return manager;
}
- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
//    NSLog(@"flutter调用原生 %@ - %@",call.method,call.arguments);
    OSETAdModel * adParams = [OSETAdModel new];
    NSDictionary *arguments = call.arguments;
    [adParams handleInit:arguments];
    // Note: this method is invoked on the UI thread.
      if ([@"getPlatformVersion" isEqualToString:call.method]) {
          result([OSETManager version]);
      }else if ([@"initAd" isEqualToString:call.method]) {
        if (call.arguments) {
            NSDictionary * dict = [NSDictionary dictionaryWithDictionary:call.arguments];
            [OSETManager configure:dict[@"appKey"]];
            result(@(YES));
        }else{
            result(@(NO));
        }
    }else if([@"showSplashAd" isEqualToString:call.method]) {
        if (call.arguments) {
            OSETFSplashAdManager *osetSplashAdManager = [OSETFSplashAdManager getOSETSplashAdManager];
            [osetSplashAdManager loadSplashAd:adParams isRequestIdfa:1];
        }else{
            result(@(NO));
        }
    }else if([@"showInterstitialAd" isEqualToString:call.method]) {
        if (call.arguments) {
            OSETFInterstitialAdManager *osetSplashAdManager = [OSETFInterstitialAdManager getOSETInterstitialAdManager];
            [osetSplashAdManager loadInterstitialAd:adParams isRequestIdfa:1];
        }else{
            result(@(NO));
        }
    }else if([@"showFullscreenVideoAd" isEqualToString:call.method]) {
        if (call.arguments) {
            OSETFFullscreenVideoAdManager *osetSplashAdManager = [OSETFFullscreenVideoAdManager getOSETFullscreenVideoAdManager];
            [osetSplashAdManager loadFullscreenVideoAd:adParams ];
        }else{
            result(@(NO));
        }
    }else if([@"showRewardVideoAd" isEqualToString:call.method]) {
        if (call.arguments) {
            if ([self isNotNull:adParams.posId]) {
                OSETFRewardVideoAdManager *osetRewardVideoAdManager = [OSETFRewardVideoAdManager getOSETRewardVideoAdManager];
                [osetRewardVideoAdManager loadRewardVideoAd:adParams isRequestIdfa:1];
                result(@(YES));
            }else{
                result(@(NO));
            }
        }else{
            result(@(NO));
        }
    }else if ([@"loadNativeAd" isEqualToString:call.method]) {
        /// 加载信息流模板广告
        OSETFNativeAdManager *osetNativeExpressAdManager = [OSETFNativeAdManager getOSETFNativeAdManager];
        [osetNativeExpressAdManager loadNativeAd:adParams isRequestIdfa:1];
    }else if ([@"loadBannerAd" isEqualToString:call.method]) {
        /// 加载Banner广告
        OSETFBannerAdManager *osetBannerAdManager = [OSETFBannerAdManager getOSETFBannerAdManager];
        [osetBannerAdManager loadBannerAd:adParams isRequestIdfa:1];
    }else if([@"checkAndReqPermission" isEqualToString:call.method]) {
        if (@available(iOS 14, *)) {
            [ATTrackingManager requestTrackingAuthorizationWithCompletionHandler:^(ATTrackingManagerAuthorizationStatus status) {
                // Tracking authorization completed. Start loading ads here.
            }];
        } else {
            // Fallback on earlier versions
        }
        result(@(YES));
    }else if ([@"getPlatformVersion" isEqualToString:call.method]) {
    result([@"iOS " stringByAppendingString:[[UIDevice currentDevice] systemVersion]]);
  }else if ([@"releaseAd" isEqualToString:call.method]) {
      /// 释放广告
      OSETFSplashAdManager *osetSplashAdManager = [OSETFSplashAdManager getOSETSplashAdManager];
      [osetSplashAdManager releaseAd:adParams.adId];
      OSETFBannerAdManager *osetBannerAdManager = [OSETFBannerAdManager getOSETFBannerAdManager];
      [osetBannerAdManager releaseAd:adParams.adId];
      OSETFNativeAdManager *osetNativeAdManager = [OSETFNativeAdManager getOSETFNativeAdManager];
      [osetNativeAdManager releaseAd:adParams.adId];
      OSETFRewardVideoAdManager *osetRewardAdManager = [OSETFRewardVideoAdManager getOSETRewardVideoAdManager];
      [osetRewardAdManager releaseAd:adParams.adId];
      OSETFInterstitialAdManager *osetInterstitialAdManager = [OSETFInterstitialAdManager getOSETInterstitialAdManager];
      [osetInterstitialAdManager releaseAd:adParams.adId];
      OSETFFullscreenVideoAdManager *osetFullscreenVideoAdManager = [OSETFFullscreenVideoAdManager getOSETFullscreenVideoAdManager];
      [osetFullscreenVideoAdManager releaseAd:adParams.adId];
  }else if ([@"onToast" isEqualToString:call.method]) {
      /// 释放广告
      if (call.arguments) {
          if ([self isNotNull:call.arguments[@"toastMsg"]]) {
              NSLog(@"------ %@ -----",call.arguments[@"toastMsg"]);
          }
      }
  } else {
    result(FlutterMethodNotImplemented);
      NSLog(@"OC没有找到方法%@ 或ios暂不支持",call.method);
  }
}
//static const methodLoadBannerAd = "loadBannerAd";
//static const methodLoadNativeAd = "loadNativeAd";
//static const methodShowVideoPage = "showVideoPage";
//static const methodShowKsVideoFragment = "showKsVideoFragment";
#pragma make NULL 判断字符是否为空
-(BOOL)isNotNull:(id)velue{
    if (velue && ![velue isKindOfClass:[NSNull class]]) {
        NSString *str = [NSString stringWithFormat:@"%@",velue];
        if (str.length >0) {
            return YES;
        }
    }
    return NO;
}


@end

