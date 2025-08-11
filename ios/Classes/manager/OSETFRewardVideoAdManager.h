//
//  OSETFRewardVideoAdManager.h
//  flutter_openset_ads
//
//  Created by Shens on 7/8/2025.
//

#import <Foundation/Foundation.h>
#import "OSETAdModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface OSETFRewardVideoAdManager : NSObject
@property (nonatomic) NSMutableDictionary *rewardVideoAdMap;

- (void)initData;

- (void)loadRewardVideoAd:(OSETAdModel *)adParams isRequestIdfa:(bool)isRequestIdfa;

- (void)releaseAd:(NSString*)adId;

+ (OSETFRewardVideoAdManager *)getOSETRewardVideoAdManager;
@end

NS_ASSUME_NONNULL_END
