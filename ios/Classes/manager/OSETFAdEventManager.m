//
//  OSETFAdEventManager.m
//  flutter_openset_ads
//
//  Created by Shens on 7/8/2025.
//

#import "OSETFAdEventManager.h"

@implementation OSETFAdEventManager

+ (instancetype)sharedManager {
    static OSETFAdEventManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

#pragma mark - FlutterStreamHandler Protocol

- (FlutterError*)onListenWithArguments:(id)arguments eventSink:(FlutterEventSink)eventSink {
    self.eventSink = eventSink;
    return nil;
}

- (FlutterError*)onCancelWithArguments:(id)arguments {
    self.eventSink = nil;
    return nil;
}

#pragma mark - Event Posting Methods

- (void)postOnAdLoadEvent:(OSETAdModel*)adParams {
    [self postAdEvent:@"onAdLoaded" adParams:adParams message:@"" extras:nil];
}

- (void)postOnAdLoadFailedEvent:(OSETAdModel*)adParams message:(NSString*)message {
    [self postAdEvent:@"onAdError" adParams:adParams message:message extras:nil];
}

- (void)postOnAdMeasuredEvent:(OSETAdModel*)adParams extras:(NSMutableDictionary*)extras {
    [self postAdEvent:@"onAdMeasured" adParams:adParams message:@"" extras:extras];
}

- (void)postOnAdExposeEvent:(OSETAdModel*)adParams {
    [self postAdEvent:@"onAdExposure" adParams:adParams message:@"" extras:nil];
}

- (void)postOnAdClickEvent:(OSETAdModel*)adParams {
    [self postAdEvent:@"onAdClicked" adParams:adParams message:@"" extras:nil];
}

- (void)postOnAdCloseEvent:(OSETAdModel*)adParams {
    [self postAdEvent:@"onAdClosed" adParams:adParams message:@"" extras:nil];
}

- (void)postOnAdRenderEvent:(OSETAdModel*)adParams {
    [self postAdEvent:@"onAdRender" adParams:adParams message:@"" extras:nil];
}

- (void)postOnAdRewardEvent:(OSETAdModel*)adParams {
    [self postAdEvent:@"onReward" adParams:adParams message:@"" extras:nil];
}

#pragma mark - Core Event Posting Method
- (void)postAdEvent:(NSString*)eventName
           adParams:(OSETAdModel*)adParams
            message:(NSString*)message
            extras:(NSDictionary*)extras {
    
    if (!self.eventSink) {
        NSLog(@"⚠️ Event sink not available. Event: %@", eventName);
        return;
    }
    // 确保在主线程发送事件
    dispatch_async(dispatch_get_main_queue(), ^{
        // 创建安全的数据字典
        NSMutableDictionary *eventData = [NSMutableDictionary dictionary];
        // 基础参数
        if (message) eventData[@"adMsg"] = message;
        if (eventName) eventData[@"adEvent"] = eventName;
        if (adParams.adId) eventData[@"adId"] = adParams.adId;
        // 添加额外参数
        if (extras) {
            [eventData addEntriesFromDictionary:extras];
        }
        // 发送事件
        NSLog(@"IOS 回调flutter %@ - %@",eventName,eventData);
        self.eventSink(eventData);
    });
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
@end
