//
//  OSETFFullscreenVideoAdManager.m
//  flutter_openset_ads
//
//  Created by Shens on 8/8/2025.
//

#import "OSETFFullscreenVideoAdManager.h"
#import "OSETFFullscreenVideoAd.h"

@implementation OSETFFullscreenVideoAdManager

/// 单例
+ (OSETFFullscreenVideoAdManager *)getOSETFullscreenVideoAdManager {
    static OSETFFullscreenVideoAdManager * osetFullscreenVideoAdManager;
    if(!osetFullscreenVideoAdManager) {
        osetFullscreenVideoAdManager = [[OSETFFullscreenVideoAdManager alloc] init];
        [osetFullscreenVideoAdManager initData];
    }
    return osetFullscreenVideoAdManager;
}

/// 初始化
- (void)initData {
    if (!_fullscreenVideoAdMap) {
        _fullscreenVideoAdMap = [[NSMutableDictionary alloc] initWithCapacity:0];
    }
}

/// 加载开屏广告
- (void)loadFullscreenVideoAd:(OSETAdModel *)adParams isRequestIdfa:(bool)isRequestIdfa {
    OSETFFullscreenVideoAd *fullscreenVideoAd = [OSETFFullscreenVideoAd alloc];
    fullscreenVideoAd.adParams = adParams;
    fullscreenVideoAd.isRequestIdfa = isRequestIdfa;
    
    NSString *adId = adParams.adId;
    [_fullscreenVideoAdMap setObject:fullscreenVideoAd forKey:adId];
    
    [fullscreenVideoAd loadFullscreenVideoAd];
}

/// 释放开屏广告
- (void)releaseAd:(NSString*)adId {
    if (adId) {
        OSETFFullscreenVideoAd *fullscreenVideoAd = _fullscreenVideoAdMap[adId];
        if (fullscreenVideoAd) {
            [_fullscreenVideoAdMap removeObjectForKey:adId];
        }
    }
}
@end
