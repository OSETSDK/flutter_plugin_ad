//
//  OSETFSplashAdManager.h
//  flutter_openset_ads
//
//  Created by Shens on 7/8/2025.
//

#import <Foundation/Foundation.h>
#import "OSETAdModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface OSETFSplashAdManager : NSObject

@property (nonatomic) NSMutableDictionary *splashAdMap;

- (void)initData;

- (void)loadSplashAd:(OSETAdModel *)adParams isRequestIdfa:(bool)isRequestIdfa;

- (void)releaseAd:(NSString*)adId;

+ (OSETFSplashAdManager *)getOSETSplashAdManager;
@end

NS_ASSUME_NONNULL_END
