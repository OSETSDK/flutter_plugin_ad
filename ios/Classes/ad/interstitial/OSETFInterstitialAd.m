//
//  OSETFInterstitialAd.m
//  flutter_openset_ads
//
//  Created by Shens on 7/8/2025.
//

#import "OSETFInterstitialAd.h"
#import <OSETSDK/OSETSDK.h>
#import <AppTrackingTransparency/AppTrackingTransparency.h>
#import <AdSupport/AdSupport.h>

@interface OSETFInterstitialAd () <OSETInterstitialAdDelegate>

@property(nonatomic, strong) OSETInterstitialAd * interstitialAd;


@end
@implementation OSETFInterstitialAd
- (void)loadInterstitialAd {
    if (self.interstitialAd) {
        return;
    }
    if ( @available(iOS
    14, *)) {
        [ATTrackingManager requestTrackingAuthorizationWithCompletionHandler:^(
                ATTrackingManagerAuthorizationStatus status) {
            if ([NSThread isMainThread]) {
                [self innerLoadFullscreenVideoAd];
            } else {
                dispatch_sync(dispatch_get_main_queue(), ^{
                    // 非主线程，将UI操作切换到主线程进行，请求广告
                    [self innerLoadFullscreenVideoAd];
                });
            }
        }];
    } else {
        [self innerLoadFullscreenVideoAd];
    }
}

- (void)innerLoadFullscreenVideoAd {
    if (self.interstitialAd) {
        return;
    }

    self.interstitialAd = [[OSETInterstitialAd alloc] initWithSlotId:_adParams.posId];
    self.interstitialAd.delegate = self;
    /// 加载开屏广告
    [self.interstitialAd loadInterstitialAdData];
}
#pragma mark OSETSplashAdDelegate
- (void)interstitialDidReceiveSuccess:(nonnull id)interstitialAd slotId:(nonnull NSString *)slotId  {
    OSETFAdEventManager *osetAdEventManager = [OSETFAdEventManager sharedManager];
    [osetAdEventManager postOnAdLoadEvent:_adParams];
    if([OSETFAdEventManager getCurrentViewController]){
        [self.interstitialAd showInterstitialFromRootViewController:[OSETFAdEventManager getCurrentViewController]];
    }
}

- (void)interstitialLoadToFailed:(nonnull id)interstitialAd error:(nonnull NSError *)error {
    OSETFAdEventManager *osetAdEventManager = [OSETFAdEventManager sharedManager];
    [osetAdEventManager postOnAdLoadFailedEvent:_adParams message:error.domain];
}

- (void)interstitialDidClick:(nonnull id)interstitialAd {
    OSETFAdEventManager *osetAdEventManager = [OSETFAdEventManager sharedManager];
    [osetAdEventManager postOnAdClickEvent:_adParams];
}

- (void)interstitialDidClose:(nonnull id)interstitialAd {
    OSETFAdEventManager *osetAdEventManager = [OSETFAdEventManager sharedManager];
    [osetAdEventManager postOnAdCloseEvent:_adParams];
}
-(void)dealloc{
//    NSLog(@"dealloc-%@",self);
    self.interstitialAd.delegate = nil;
    self.interstitialAd = nil;
}

@end
