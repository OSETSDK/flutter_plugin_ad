//
//  OSETFFullscreenVideoAd.m
//  flutter_openset_ads
//
//  Created by Shens on 8/8/2025.
//

#import "OSETFFullscreenVideoAd.h"
#import <OSETSDK/OSETSDK.h>
#import <AppTrackingTransparency/AppTrackingTransparency.h>
#import <AdSupport/AdSupport.h>

@interface OSETFFullscreenVideoAd () <OSETFullscreenVideoAdDelegate>

@property(nonatomic, strong) OSETFullscreenVideoAd * fullscreenVideoAd;


@end
@implementation OSETFFullscreenVideoAd
- (void)loadFullscreenVideoAd {
    if (self.fullscreenVideoAd) {
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
    if (self.fullscreenVideoAd) {
        return;
    }

    self.fullscreenVideoAd = [[OSETFullscreenVideoAd alloc] initWithSlotId:_adParams.posId];
    self.fullscreenVideoAd.delegate = self;
    /// 加载开屏广告
    [self.fullscreenVideoAd loadAdData];
}
#pragma mark OSETSplashAdDelegate

- (void)fullscreenVideoDidReceiveSuccess:(nonnull id)fullscreenVideoAd slotId:(nonnull NSString *)slotId {
    OSETFAdEventManager *osetAdEventManager = [OSETFAdEventManager sharedManager];
    [osetAdEventManager postOnAdLoadEvent:_adParams];
    if([OSETFAdEventManager getCurrentViewController]){
        [self.fullscreenVideoAd showFromRootViewController:[OSETFAdEventManager getCurrentViewController]];
    }
}

- (void)fullscreenVideoLoadToFailed:(nonnull id)fullscreenVideoAd error:(nonnull NSError *)error{
    OSETFAdEventManager *osetAdEventManager = [OSETFAdEventManager sharedManager];
    [osetAdEventManager postOnAdLoadFailedEvent:_adParams message:error.domain];
}

- (void)fullscreenVideoDidClick:(nonnull id)fullscreenVideoAd  {
    OSETFAdEventManager *osetAdEventManager = [OSETFAdEventManager sharedManager];
    [osetAdEventManager postOnAdClickEvent:_adParams];
}

- (void)fullscreenVideoDidClose:(nonnull id)fullscreenVideoAd {
    OSETFAdEventManager *osetAdEventManager = [OSETFAdEventManager sharedManager];
    [osetAdEventManager postOnAdCloseEvent:_adParams];
}
- (void)fulllscreenVideoPlayStart:(id)fullscreenVideoAd{
    OSETFAdEventManager *osetAdEventManager = [OSETFAdEventManager sharedManager];
    [osetAdEventManager postOnAdExposeEvent:_adParams];
}

-(void)dealloc{
//    NSLog(@"dealloc-%@",self);
    self.fullscreenVideoAd.delegate = nil;
    self.fullscreenVideoAd = nil;
}

@end
