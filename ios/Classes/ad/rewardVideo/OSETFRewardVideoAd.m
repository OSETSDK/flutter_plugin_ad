//
//  OSETFRewardVideoAd.m
//  flutter_openset_ads
//
//  Created by Shens on 7/8/2025.
//

#import "OSETFRewardVideoAd.h"
#import <OSETSDK/OSETSDK.h>
#import <AppTrackingTransparency/AppTrackingTransparency.h>
#import <AdSupport/AdSupport.h>

@interface OSETFRewardVideoAd () <OSETRewardVideoAdDelegate>

@property(nonatomic, strong) OSETRewardVideoAd * rewardAd;


@end
@implementation OSETFRewardVideoAd
- (void)loadRewardVideoAd {
    if (self.rewardAd) {
        return;
    }
    if ( @available(iOS
    14, *)) {
        [ATTrackingManager requestTrackingAuthorizationWithCompletionHandler:^(
                ATTrackingManagerAuthorizationStatus status) {
            if ([NSThread isMainThread]) {
                [self innerLoadRewardVideoAd];
            } else {
                dispatch_sync(dispatch_get_main_queue(), ^{
                    // 非主线程，将UI操作切换到主线程进行，请求广告
                    [self innerLoadRewardVideoAd];
                });
            }
        }];
    } else {
        [self innerLoadRewardVideoAd];
    }
}

- (void)innerLoadRewardVideoAd {
    if (self.rewardAd) {
        return;
    }

    self.rewardAd = [[OSETRewardVideoAd alloc] initWithSlotId:_adParams.posId withUserId:_adParams.userId];
    self.rewardAd.delegate = self;
    /// 加载开屏广告
    [self.rewardAd loadRewardAdData];
}
#pragma mark OSETSplashAdDelegate

- (void)rewardVideoDidReceiveSuccess:(nonnull id)rewardVideoAd slotId:(nonnull NSString *)slotId {
    OSETFAdEventManager *osetAdEventManager = [OSETFAdEventManager sharedManager];
    [osetAdEventManager postOnAdLoadEvent:_adParams];
    if([OSETFAdEventManager getCurrentViewController]){
        [self.rewardAd showRewardFromRootViewController:[OSETFAdEventManager getCurrentViewController]];
    }
}

- (void)rewardVideoLoadToFailed:(nonnull id)rewardVideoAd error:(nonnull NSError *)error {
    OSETFAdEventManager *osetAdEventManager = [OSETFAdEventManager sharedManager];
    [osetAdEventManager postOnAdLoadFailedEvent:_adParams message:error.domain];
}

- (void)rewardVideoDidClick:(nonnull id)rewardVideoAd {
    OSETFAdEventManager *osetAdEventManager = [OSETFAdEventManager sharedManager];
    [osetAdEventManager postOnAdClickEvent:_adParams];
}

- (void)rewardVideoDidClose:(id)rewardVideoAd checkString:(NSString *)checkString{
    OSETFAdEventManager *osetAdEventManager = [OSETFAdEventManager sharedManager];
    [osetAdEventManager postOnAdCloseEvent:_adParams];
}
//激励视频播放结束
- (void)rewardVideoPlayEnd:(id)rewardVideoAd  checkString:(NSString *)checkString{
}

//激励视频开始播放
- (void)rewardVideoPlayStart:(id)rewardVideoAd checkString:(NSString *)checkString{
    OSETFAdEventManager *osetAdEventManager = [OSETFAdEventManager sharedManager];
    [osetAdEventManager postOnAdExposeEvent:_adParams];
}
//激励视频奖励
- (void)rewardVideoOnReward:(id)rewardVideoAd checkString:(NSString *)checkString{
    OSETFAdEventManager *osetAdEventManager = [OSETFAdEventManager sharedManager];
    [osetAdEventManager postOnAdRewardEvent:_adParams];

}
-(void)rewardVideoRequestOnReward:(id)rewardVideoAd checkString:(NSString *)checkString withRequsetData:(NSDictionary *)requsetData{

}
//激励视频播放出错
- (void)rewardVideoPlayError:(id)rewardVideoAd error:(NSError *)error{
}

-(void)dealloc{
//    NSLog(@"dealloc-%@",self);
    self.rewardAd.delegate = nil;
    self.rewardAd = nil;
}
@end
