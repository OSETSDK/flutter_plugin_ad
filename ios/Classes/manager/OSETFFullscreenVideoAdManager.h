//
//  OSETFFullscreenVideoAdManager.h
//  flutter_openset_ads
//
//  Created by Shens on 8/8/2025.
//

#import <Foundation/Foundation.h>
#import "OSETAdModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface OSETFFullscreenVideoAdManager : NSObject
@property (nonatomic) NSMutableDictionary *fullscreenVideoAdMap;

- (void)initData;

- (void)loadFullscreenVideoAd:(OSETAdModel *)adParams;

- (void)releaseAd:(NSString*)adId;

+ (OSETFFullscreenVideoAdManager *)getOSETFullscreenVideoAdManager;
@end

NS_ASSUME_NONNULL_END
