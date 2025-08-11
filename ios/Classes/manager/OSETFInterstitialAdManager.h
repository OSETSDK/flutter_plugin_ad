//
//  OSETFInterstitialAdManager.h
//  flutter_openset_ads
//
//  Created by Shens on 7/8/2025.
//

#import <Foundation/Foundation.h>
#import "OSETAdModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface OSETFInterstitialAdManager : NSObject
@property (nonatomic) NSMutableDictionary *interstitialAdMap;

- (void)initData;

- (void)loadInterstitialAd:(OSETAdModel *)adParams isRequestIdfa:(bool)isRequestIdfa;

- (void)releaseAd:(NSString*)adId;

+ (OSETFInterstitialAdManager *)getOSETInterstitialAdManager;
@end

NS_ASSUME_NONNULL_END
