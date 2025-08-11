//
//  OSETFNativeAdManager.m
//  flutter_openset_ads
//
//  Created by Shens on 7/8/2025.
//

#import "OSETFNativeAdManager.h"
#import "OSETFNativeAd.h"
@implementation OSETFNativeAdManager

+ (OSETFNativeAdManager *)getOSETFNativeAdManager {
    static OSETFNativeAdManager *osetNativeAdManager;
    if(!osetNativeAdManager) {
        osetNativeAdManager = [[OSETFNativeAdManager alloc] init];
        [osetNativeAdManager initData];
    }
    return osetNativeAdManager;
}

- (void)initData{
    if (!_nativeAdMap) {
        _nativeAdMap = [[NSMutableDictionary alloc] initWithCapacity:0];
    }
}

- (void)loadNativeAd:(OSETAdModel *)adParams isRequestIdfa:(bool)isRequestIdfa{
    OSETFNativeAd *nativeAd = [[OSETFNativeAd alloc] init];
    nativeAd.adParams = adParams;
    nativeAd.isRequestIdfa = isRequestIdfa;
    NSString *adId = adParams.adId;
    [_nativeAdMap setObject:nativeAd forKey:adId];
    [nativeAd loadNativeAd];
}

- (UIView *)getNativeAdView:(NSString*)adId{
    if (adId) {
        OSETFNativeAd *nativeAd = _nativeAdMap[adId];
        if (nativeAd) {
            return nativeAd.nativeAdView;
        }
    }
    return nil;
}


- (void)releaseAd:(NSString*)adId{
    OSETFNativeAd *nativeAd = _nativeAdMap[adId];
    if (nativeAd) {
        [nativeAd releaseAd];
        [_nativeAdMap removeObjectForKey:adId];

    }
}
@end
