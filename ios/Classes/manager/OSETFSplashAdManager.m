//
//  OSETFSplashAdManager.m
//  flutter_openset_ads
//
//  Created by Shens on 7/8/2025.
//

#import "OSETFSplashAdManager.h"
#import "OSETFSplashAd.h"
@implementation OSETFSplashAdManager

/// 单例
+ (OSETFSplashAdManager *)getOSETSplashAdManager {
    static OSETFSplashAdManager * osetSplashAdManager;
    if(!osetSplashAdManager) {
        osetSplashAdManager = [[OSETFSplashAdManager alloc] init];
        [osetSplashAdManager initData];
    }
    return osetSplashAdManager;
}

/// 初始化
- (void)initData {
    if (!_splashAdMap) {
        _splashAdMap = [[NSMutableDictionary alloc] initWithCapacity:0];
    }
}

/// 加载开屏广告
- (void)loadSplashAd:(OSETAdModel *)adParams isRequestIdfa:(bool)isRequestIdfa {
    OSETFSplashAd *splashAd = [OSETFSplashAd alloc];
    splashAd.adParams = adParams;
    splashAd.isRequestIdfa = isRequestIdfa;
    
    NSString *adId = adParams.adId;
    [_splashAdMap setObject:splashAd forKey:adId];
    
    [splashAd loadSplashAd];
}

/// 释放开屏广告
- (void)releaseAd:(NSString*)adId {
    if (adId) {
        OSETFSplashAd *splashAd = _splashAdMap[adId];
        if (splashAd) {
            [_splashAdMap removeObjectForKey:adId];
        }
    }
}
@end
