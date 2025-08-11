//
//  OSETFRewardVideoAdManager.m
//  flutter_openset_ads
//
//  Created by Shens on 7/8/2025.
//

#import "OSETFRewardVideoAdManager.h"
#import "OSETFRewardVideoAd.h"
@implementation OSETFRewardVideoAdManager

/// 单例
+ (OSETFRewardVideoAdManager *)getOSETRewardVideoAdManager {
    static OSETFRewardVideoAdManager * osetRewardVideoAdManager;
    if(!osetRewardVideoAdManager) {
        osetRewardVideoAdManager = [[OSETFRewardVideoAdManager alloc] init];
        [osetRewardVideoAdManager initData];
    }
    return osetRewardVideoAdManager;
}

/// 初始化
- (void)initData {
    if (!_rewardVideoAdMap) {
        _rewardVideoAdMap = [[NSMutableDictionary alloc] initWithCapacity:0];
    }
}

/// 加载开屏广告
- (void)loadRewardVideoAd:(OSETAdModel *)adParams isRequestIdfa:(bool)isRequestIdfa {
    OSETFRewardVideoAd *rewardVideoAd = [OSETFRewardVideoAd alloc];
    rewardVideoAd.adParams = adParams;
    rewardVideoAd.isRequestIdfa = isRequestIdfa;
    
    NSString *adId = adParams.adId;
    [_rewardVideoAdMap setObject:rewardVideoAd forKey:adId];
    
    [rewardVideoAd loadRewardVideoAd];
}

/// 释放开屏广告
- (void)releaseAd:(NSString*)adId {
    if (adId) {
        OSETFRewardVideoAd *rewardVideoAd = _rewardVideoAdMap[adId];
        if (rewardVideoAd) {
            [_rewardVideoAdMap removeObjectForKey:adId];
        }
    }
}
@end
