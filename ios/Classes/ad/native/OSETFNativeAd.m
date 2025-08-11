//
//  OSETFNativeAd.m
//  flutter_openset_ads
//
//  Created by Shens on 7/8/2025.
//

#import "OSETFNativeAd.h"
#import <AppTrackingTransparency/AppTrackingTransparency.h>
#import <AdSupport/AdSupport.h>

@interface OSETFNativeAd ()<OSETNativeAdDelegate>
@property (nonatomic) bool isAdExposed;
@property (nonatomic) bool isAdClosed;
@property (nonatomic) OSETNativeAd *nativeExpressAd;

@end

@implementation OSETFNativeAd

/// 接到Flutter消息，开始加载信息流广告
- (void)loadNativeAd {
    if (self.nativeExpressAd) {
        return;
    }
    if ( @available(iOS 14, *)) {
        if (_isRequestIdfa) {
            [ATTrackingManager requestTrackingAuthorizationWithCompletionHandler:^(ATTrackingManagerAuthorizationStatus status) {
                if ([NSThread isMainThread]) {
                    [self innerLoadNativeExpressAd ];
                } else {
                    dispatch_sync(dispatch_get_main_queue(), ^{
                        // 非主线程，将UI操作切换到主线程进行，请求广告
                        [self innerLoadNativeExpressAd ];
                    });
                }
            }];
        } else {
            // Fallback on earlier versions
            [self innerLoadNativeExpressAd];
        }
    } else {
        [self innerLoadNativeExpressAd];
    }
}

/// 真正的请求信息流广告
- (void) innerLoadNativeExpressAd {
    if (!self.nativeExpressAd) {
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        UIViewController *rvc = window.rootViewController;
        if([_adParams.adHeight floatValue] <=100){
            _adParams.adHeight = @(100);
        }
        self.nativeExpressAd = [[OSETNativeAd alloc] initWithSlotId:_adParams.posId size:CGSizeMake([_adParams.adWidth floatValue],[_adParams.adHeight floatValue]) rootViewController:rvc];
        self.nativeExpressAd.delegate = self;
    }
    [self.nativeExpressAd loadAdData];
}
/// 接到Flutter消息，释放插屏广告
- (void)releaseAd {
    if (self.nativeExpressAd) {
        self.nativeExpressAd = nil;
        if(_nativeAdView){
            [_nativeAdView removeFromSuperview];
        }
        _nativeAdView = nil;
    }
}

- (void)nativeExpressAdLoadSuccessWithNative:(id)native nativeExpressViews:(NSArray *)nativeExpressViews{
    if(nativeExpressViews.firstObject){
        _nativeAdView = nativeExpressViews.firstObject;
        /// 通知Flutter端
        OSETFAdEventManager *osetAdEventManager = [OSETFAdEventManager sharedManager];
        NSMutableDictionary *extras = [[NSMutableDictionary alloc] initWithCapacity:0];
        [extras setObject:@(_nativeAdView.frame.size.width) forKey:@"adWidth"];
        [extras setObject:@(_nativeAdView.frame.size.height) forKey:@"adHeight"];
        [osetAdEventManager postOnAdMeasuredEvent:_adParams extras: extras];
        [osetAdEventManager postOnAdLoadEvent:_adParams ];
    }
}

- (void)nativeExpressAdRenderSuccess:(id)nativeExpressView{
    if(nativeExpressView && [nativeExpressView isKindOfClass:[UIView class]]){
        UIView * view  =nativeExpressView;
        OSETFAdEventManager *osetAdEventManager = [OSETFAdEventManager sharedManager];
        [osetAdEventManager postOnAdRenderEvent:_adParams];
    }else{
        
    }
}
- (void)nativeExpressAdFailedToLoad:(nonnull id)nativeExpressAd error:(nonnull NSError *)error {
    OSETFAdEventManager *osetAdEventManager = [OSETFAdEventManager sharedManager];
    [osetAdEventManager postOnAdLoadFailedEvent:_adParams message:error.domain];
}
- (void)nativeExpressAdFailedToRender:(nonnull id)nativeExpressView {
//    OSETFAdEventManager *osetAdEventManager = [OSETFAdEventManager sharedManager];
//    [osetAdEventManager postOnAdExposeEvent:_adParams];

}
- (void)nativeExpressAdDidClick:(id)nativeExpressView{
    OSETFAdEventManager *osetAdEventManager = [OSETFAdEventManager sharedManager];
    [osetAdEventManager postOnAdClickEvent:_adParams];
}
- (void)nativeExpressAdDidClose:(nonnull id)nativeExpressView {
    OSETFAdEventManager *osetAdEventManager = [OSETFAdEventManager sharedManager];
    [osetAdEventManager postOnAdCloseEvent:_adParams];

}




@end
