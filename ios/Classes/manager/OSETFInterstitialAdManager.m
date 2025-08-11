//
//  OSETFInterstitialAdManager.m
//  flutter_openset_ads
//
//  Created by Shens on 7/8/2025.
//

#import "OSETFInterstitialAdManager.h"
#import "OSETFInterstitialAd.h"
@implementation OSETFInterstitialAdManager

/// 单例
+ (OSETFInterstitialAdManager *)getOSETInterstitialAdManager {
    static OSETFInterstitialAdManager * osetInterstitialAdManager;
    if(!osetInterstitialAdManager) {
        osetInterstitialAdManager = [[OSETFInterstitialAdManager alloc] init];
        [osetInterstitialAdManager initData];
    }
    return osetInterstitialAdManager;
}

/// 初始化
- (void)initData {
    if (!_interstitialAdMap) {
        _interstitialAdMap = [[NSMutableDictionary alloc] initWithCapacity:0];
    }
}

/// 加载开屏广告
- (void)loadInterstitialAd:(OSETAdModel *)adParams isRequestIdfa:(bool)isRequestIdfa {
    OSETFInterstitialAd *interstitialAd = [OSETFInterstitialAd alloc];
    interstitialAd.adParams = adParams;
    interstitialAd.isRequestIdfa = isRequestIdfa;
    
    NSString *adId = adParams.adId;
    [_interstitialAdMap setObject:interstitialAd forKey:adId];
    
    [interstitialAd loadInterstitialAd];
}

/// 释放开屏广告
- (void)releaseAd:(NSString*)adId {
    if (adId) {
        OSETFInterstitialAd *interstitialAd = _interstitialAdMap[adId];
        if (interstitialAd) {
            [_interstitialAdMap removeObjectForKey:adId];
        }
    }
}
@end
