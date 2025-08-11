//
//  OSETFBannerAdManager.m
//  flutter_openset_ads
//
//  Created by Shens on 7/8/2025.
//

#import "OSETFBannerAdManager.h"
#import "OSETFBannerAd.h"
@implementation OSETFBannerAdManager

+ (OSETFBannerAdManager *)getOSETFBannerAdManager {
    static OSETFBannerAdManager *osetBannerAdManager;
    if(!osetBannerAdManager) {
        osetBannerAdManager = [[OSETFBannerAdManager alloc] init];
        [osetBannerAdManager initData];
    }
    return osetBannerAdManager;
}

- (void)initData{
    if (!_bannerAdMap) {
        _bannerAdMap = [[NSMutableDictionary alloc] initWithCapacity:0];
    }
}

- (void)loadBannerAd:(OSETAdModel *)adParams isRequestIdfa:(bool)isRequestIdfa{
    OSETFBannerAd *nativeAd = [[OSETFBannerAd alloc] init];
    nativeAd.adParams = adParams;
    nativeAd.isRequestIdfa = isRequestIdfa;
    NSString *adId = adParams.adId;
    [_bannerAdMap setObject:nativeAd forKey:adId];
    [nativeAd loadBannerAd];
}

- (UIView *)getBannerAdView:(NSString*)adId{
    if (adId) {
        OSETFBannerAd *bannerAd = _bannerAdMap[adId];
        if (bannerAd) {
            return bannerAd.bannerAdView;
        }
    }
    return nil;
}

- (void)releaseAd:(NSString*)adId{
    OSETFBannerAd *bannerAd = _bannerAdMap[adId];
    if (bannerAd) {
        [bannerAd releaseAd];
        [_bannerAdMap removeObjectForKey:adId];

    }
}
@end
