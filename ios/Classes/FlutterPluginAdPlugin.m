#import "FlutterPluginAdPlugin.h"
#import <AppTrackingTransparency/AppTrackingTransparency.h>
#import <AdSupport/AdSupport.h>
#import "IOSFlutterPlatformViewFactory.h"
#import "IOSFlutterNativeViewFactory.h"
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
    NSLog(@"self = %@",self);
        UIViewController *currentVC = [FlutterPluginAdPlugin getCurrentViewController];
        NSLog(@"当前控制器: %@", currentVC);
    if(currentVC && [currentVC isKindOfClass:[FlutterViewController class]]){
        self.rootVC = (FlutterViewController*)currentVC;
    }
    // Note: this method is invoked on the UI thread.
      if ([@"getPlatformVersion" isEqualToString:call.method]) {
          result([OSETManager version]);
      }else if ([@"initAd" isEqualToString:call.method]) {
        if (call.arguments) {
            NSDictionary * dict = [NSDictionary dictionaryWithDictionary:call.arguments];
            if (dict[@"isDebug"]) {
                [OSETManager openDebugLog];
            }
            [OSETManager configure:dict[@"appKey"]];
            result(@(YES));
        }else{
            result(@(NO));
        }
    }else if([@"showSplashAd" isEqualToString:call.method]) {
        if (call.arguments) {
            NSDictionary * dict = [NSDictionary dictionaryWithDictionary:call.arguments];
            if ([self isNotNull:dict[@"adId"]]) {
                self.splashAd = [[OSETSplashAd alloc] initWithSlotId:dict[@"adId"] window:self.rootVC.view.window bottomView:[UIView new]];
                self.splashAd.delegate = self;
                [self.splashAd loadSplashAd];
                result(@(YES));
            }else{
                result(@(NO));
                self.eventSink(@{@"eventType":onAdError,@"msg":@"广告位 ID 为空"});
            }
        }else{
            result(@(NO));
        }
    }else if([@"showInterstitialAd" isEqualToString:call.method]) {
        if (call.arguments) {
            NSDictionary * dict = [NSDictionary dictionaryWithDictionary:call.arguments];
            if ([self isNotNull:dict[@"adId"]]) {
                self.interstitialAd = [[OSETInterstitialAd alloc] initWithSlotId:dict[@"adId"]];
                self.interstitialAd.delegate = self;
                [self.interstitialAd loadInterstitialAdData];
                result(@(YES));
            }else{
                result(@(NO));
                self.eventSink(@{@"eventType":onAdError,@"msg":@"广告位 ID 为空"});
            }
        }else{
            result(@(NO));
        }
    }else if([@"showFullscreenVideoAd" isEqualToString:call.method]) {
        if (call.arguments) {
            NSDictionary * dict = [NSDictionary dictionaryWithDictionary:call.arguments];
            if ([self isNotNull:dict[@"adId"]]) {
                self.fullscreenVideoAd = [[OSETFullscreenVideoAd alloc] initWithSlotId:dict[@"adId"]];
                self.fullscreenVideoAd.delegate = self;
                [self.fullscreenVideoAd loadAdData];
                result(@(YES));
            }else{
                result(@(NO));
                self.eventSink(@{@"eventType":onAdError,@"msg":@"广告位 ID 为空"});
                
            }
        }else{
            result(@(NO));
        }
    }else if([@"showRewardVideoAd" isEqualToString:call.method]) {
        if (call.arguments) {
            NSDictionary * dict = [NSDictionary dictionaryWithDictionary:call.arguments];
            if ([self isNotNull:dict[@"adId"]]) {
                NSString * userId = @"";
                if ([self isNotNull:dict[@"userId"]]) {
                    userId = dict[@"userId"];
                }
                if(self.rewardVideoAd){
                    self.rewardVideoAd.userId =userId;
                    self.rewardVideoAd.delegate = self;
                    [self.rewardVideoAd loadRewardAdData];
                }else{
                    self.rewardVideoAd = [[OSETRewardVideoAd alloc] initWithSlotId:dict[@"adId"] withUserId:dict[@"userId"]];
                    self.rewardVideoAd.delegate = self;
                    [self.rewardVideoAd loadRewardAdData];
                }
                result(@(YES));
            }else{
                result(@(NO));
                self.eventSink(@{@"eventType":onAdError,@"msg":@"广告位 ID 为空"});
            }
        }else{
            result(@(NO));
        }
    }else if([@"checkAndReqPermission" isEqualToString:call.method]) {
        if (@available(iOS 14, *)) {
            [ATTrackingManager requestTrackingAuthorizationWithCompletionHandler:^(ATTrackingManagerAuthorizationStatus status) {
                // Tracking authorization completed. Start loading ads here.
            }];
        } else {
            // Fallback on earlier versions
        }
        result(@(YES));
    }else if([@"showRewardVideoAdFromRootViewController" isEqualToString:call.method]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if(self.rewardVideoAd){
                [self.rewardVideoAd loadRewardAdData];
                result(@(YES));
            }else{
                result(@(NO));
            }
        });
    }else if ([@"getPlatformVersion" isEqualToString:call.method]) {
    result([@"iOS " stringByAppendingString:[[UIDevice currentDevice] systemVersion]]);
  } else {
    result(FlutterMethodNotImplemented);
      NSLog(@"OC没有找到方法%@",call.method);
  }
}
// 获取当前显示的 UIViewController（兼容导航控制器、模态窗口等）
+ (UIViewController *)getCurrentViewController {
    UIViewController *rootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
    return [self findTopViewController:rootVC];
}

// 递归查找最顶层控制器
+ (UIViewController *)findTopViewController:(UIViewController *)vc {
    if ([vc isKindOfClass:[UINavigationController class]]) {
        return [self findTopViewController:[(UINavigationController *)vc visibleViewController]];
    } else if ([vc isKindOfClass:[UITabBarController class]]) {
        return [self findTopViewController:[(UITabBarController *)vc selectedViewController]];
    } else if (vc.presentedViewController) {
        return [self findTopViewController:vc.presentedViewController];
    } else {
        return vc;
    }
}

#pragma mark OSETSplashAdDelegate
- (void)splashDidReceiveSuccess:(nonnull id)splashAd slotId:(nonnull NSString *)slotId {
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setValue:onAdLoaded forKey:@"eventType"];
    [dic setValue:@"" forKey:@"msg"];
    [dic setValue:@"splash" forKey:@"adType"];
    if (self.eventSink) self.eventSink(dic);
    [self.splashAd showSplashAd];
}

- (void)splashLoadToFailed:(nonnull id)splashAd error:(nonnull NSError *)error {
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setValue:onAdError forKey:@"eventType"];
    [dic setValue:[NSString stringWithFormat:@"code = %ld",(long)error.code] forKey:@"msg"];
    [dic setValue:@"splash" forKey:@"adType"];
    if (self.eventSink) self.eventSink(dic);
}

- (void)splashDidClick:(nonnull id)splashAd {
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setValue:onAdClicked forKey:@"eventType"];
    [dic setValue:@"" forKey:@"msg"];
    [dic setValue:@"splash" forKey:@"adType"];
    if (self.eventSink) self.eventSink(dic);
}

- (void)splashDidClose:(nonnull id)splashAd {
    self.splashAd  = nil;
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setValue:onAdClosed forKey:@"eventType"];
    [dic setValue:@"" forKey:@"msg"];
    [dic setValue:@"splash" forKey:@"adType"];
    if (self.eventSink) self.eventSink(dic);
}
#pragma mark OSETInterstitialAdDelegate
- (void)interstitialDidReceiveSuccess:(nonnull id)interstitialAd slotId:(nonnull NSString *)slotId {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.interstitialAd showInterstitialFromRootViewController:self.rootVC];
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        [dic setValue:onAdLoaded forKey:@"eventType"];
        [dic setValue:@"" forKey:@"msg"];
        [dic setValue:@"interstitial" forKey:@"adType"];
        if (self.eventSink) self.eventSink(dic);
      // Call the desired channel message here.
    });
}

- (void)interstitialLoadToFailed:(nonnull id)interstitialAd error:(nonnull NSError *)error {
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setValue:onAdError forKey:@"eventType"];
    [dic setValue:@"interstitial" forKey:@"adType"];
    [dic setValue:[NSString stringWithFormat:@"code = %ld",(long)error.code] forKey:@"msg"];
    if (self.eventSink) self.eventSink(dic);
}

- (void)interstitialDidClick:(nonnull id)interstitialAd {
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setValue:onAdClicked forKey:@"eventType"];
    [dic setValue:@"interstitial" forKey:@"adType"];
    [dic setValue:@"" forKey:@"msg"];
    if (self.eventSink) self.eventSink(dic);
}

- (void)interstitialDidClose:(nonnull id)interstitialAd {
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setValue:onAdClosed forKey:@"eventType"];
    [dic setValue:@"interstitial" forKey:@"adType"];
    [dic setValue:@"" forKey:@"msg"];
    if (self.eventSink) self.eventSink(dic);
}
#pragma mark OSETRewardVideoAdDelegate
- (void)rewardVideoDidReceiveSuccess:(nonnull id)rewardVideoAd slotId:(nonnull NSString *)slotId {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.rewardVideoAd showRewardFromRootViewController:self.rootVC];
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        [dic setValue:onAdLoaded forKey:@"eventType"];
        [dic setValue:@"rewardVideo" forKey:@"adType"];
        [dic setValue:@"" forKey:@"msg"];
        if (self.eventSink) self.eventSink(dic);
        NSLog(@"=====激励视频   触发 rewardVideoDidReceiveSuccess");
    });
}

- (void)rewardVideoLoadToFailed:(nonnull id)rewardVideoAd error:(nonnull NSError *)error {
    if(error){
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        [dic setValue:onAdError forKey:@"eventType"];
        [dic setValue:@"rewardVideo" forKey:@"adType"];
        [dic setValue:[NSString stringWithFormat:@"code = %ld",(long)error.code] forKey:@"msg"];
        if (self.eventSink) self.eventSink(dic);
    }else{
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        [dic setValue:onAdError forKey:@"eventType"];
        [dic setValue:@"rewardVideo" forKey:@"adType"];
        [dic setValue:[NSString stringWithFormat:@"error 为空code = %d",-1] forKey:@"msg"];
        if (self.eventSink) self.eventSink(dic);
    }
}
- (void)rewardVideoDidClick:(nonnull id)rewardVideoAd {
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setValue:onAdClicked forKey:@"eventType"];
    [dic setValue:@"rewardVideo" forKey:@"adType"];
    [dic setValue:@"" forKey:@"msg"];
    if (self.eventSink) self.eventSink(dic);
}
- (void)rewardVideoDidClose:(id)rewardVideoAd checkString:(NSString *)checkString{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setValue:onAdClosed forKey:@"eventType"];
    [dic setValue:@"" forKey:@"msg"];
    if (self.eventSink) self.eventSink(dic);
}
//激励视频播放结束
- (void)rewardVideoPlayEnd:(id)rewardVideoAd  checkString:(NSString *)checkString{
}
-(void)rewardVideoPlayError:(id)rewardVideoAd error:(NSError *)error{
}
-(void)rewardVideoPlayStart:(id)rewardVideoAd checkString:(NSString *)checkString{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setValue:onAdExposure forKey:@"eventType"];
    [dic setValue:@"" forKey:@"msg"];
    [dic setValue:@"rewardVideo" forKey:@"adType"];
    if (self.eventSink) self.eventSink(dic);
}
//激励视频奖励
- (void)rewardVideoOnReward:(id)rewardVideoAd checkString:(NSString *)checkString{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setValue:onAdReward forKey:@"eventType"];
    [dic setValue:checkString forKey:@"msg"];
    [dic setValue:@"rewardVideo" forKey:@"adType"];
    if (self.eventSink) self.eventSink(dic);
    NSLog(@"=====激励视频    OnReward");
}

- (void)fullscreenVideoDidReceiveSuccess:(nonnull id)fullscreenVideoAd slotId:(nonnull NSString *)slotId {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.fullscreenVideoAd showFromRootViewController:self.rootVC];
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        [dic setValue:onAdLoaded forKey:@"eventType"];
        [dic setValue:@"" forKey:@"msg"];
        [dic setValue:@"fullscreenVideo" forKey:@"adType"];
        if (self.eventSink) self.eventSink(dic);
      // Call the desired channel message here.
    });
}

- (void)fullscreenVideoLoadToFailed:(nonnull id)fullscreenVideoAd error:(nonnull NSError *)error {
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setValue:onAdError forKey:@"eventType"];
    [dic setValue:@"fullscreenVideo" forKey:@"adType"];
    [dic setValue:[NSString stringWithFormat:@"code = %ld",(long)error.code] forKey:@"msg"];
    if (self.eventSink) self.eventSink(dic);
}

- (void)fullscreenVideoDidClick:(nonnull id)fullscreenVideoAd {
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setValue:onAdClicked forKey:@"eventType"];
    [dic setValue:@"fullscreenVideo" forKey:@"adType"];
    [dic setValue:@"" forKey:@"msg"];
    if (self.eventSink) self.eventSink(dic);
}

- (void)fullscreenVideoDidClose:(nonnull id)fullscreenVideoAd {
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setValue:onAdClosed forKey:@"eventType"];
    [dic setValue:@"fullscreenVideo" forKey:@"adType"];
    [dic setValue:@"" forKey:@"msg"];
    if (self.eventSink) self.eventSink(dic);
}
- (void)fulllscreenVideoPlayEnd:(id)fullscreenVideoAd{
    NSLog(@"%s",__FUNCTION__);

}
- (void)fulllscreenVideoPlayStart:(id)fullscreenVideoAd{
    NSLog(@"%s",__FUNCTION__);
}

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
#pragma make FlutterEventChannel
// 这个onListen是Flutter端开始监听这个channel时的回调，第二个参数 EventSink是用来传数据的载体。
- (FlutterError* _Nullable)onListenWithArguments:(id _Nullable)arguments
                                       eventSink:(FlutterEventSink)events {
    self.eventSink = events;
    NSLog(@"onListenWithArguments %@  == %@",arguments,events);
    return nil;
}
/// flutter不再接收
- (FlutterError* _Nullable)onCancelWithArguments:(id _Nullable)arguments {
    // arguments flutter给native的参数
    NSLog(@"lutter给native的参数 onCancelWithArguments %@",arguments);
    return nil;
}

//+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar> *)registrar{
//
//}

@end

