//
//  OSETFBannerAdManager.h
//  flutter_openset_ads
//
//  Created by Shens on 7/8/2025.
//

#import <Foundation/Foundation.h>
#import "OSETAdModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface OSETFBannerAdManager : NSObject
@property (nonatomic) NSMutableDictionary *bannerAdMap;

+ (OSETFBannerAdManager *)getOSETFBannerAdManager;
- (void)loadBannerAd:(OSETAdModel *)adParams isRequestIdfa:(bool)isRequestIdfa;

- (UIView *)getBannerAdView:(NSString*)adId;

- (void)releaseAd:(NSString*)adId;
@end

NS_ASSUME_NONNULL_END
