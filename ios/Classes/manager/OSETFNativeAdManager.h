//
//  OSETFNativeAdManager.h
//  flutter_openset_ads
//
//  Created by Shens on 7/8/2025.
//

#import <Foundation/Foundation.h>
#import "OSETAdModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface OSETFNativeAdManager : NSObject
@property (nonatomic) NSMutableDictionary *nativeAdMap;

+ (OSETFNativeAdManager *)getOSETFNativeAdManager;
- (void)loadNativeAd:(OSETAdModel *)adParams isRequestIdfa:(bool)isRequestIdfa;

- (UIView *)getNativeAdView:(NSString*)adId;

- (void)releaseAd:(NSString*)adId;
@end

NS_ASSUME_NONNULL_END
