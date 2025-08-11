//
//  OSETFBannerAd.h
//  flutter_openset_ads
//
//  Created by Shens on 7/8/2025.
//

#import <Foundation/Foundation.h>
#import "OSETFAdEventManager.h"
#import "OSETAdModel.h"
#import <OSETSDK/OSETSDK.h>


NS_ASSUME_NONNULL_BEGIN

@interface OSETFBannerAd : NSObject

@property (nonatomic) UIView *bannerAdView;

@property(nonatomic) OSETAdModel *adParams;
@property(nonatomic) bool isRequestIdfa;

- (void)loadBannerAd;
- (void)releaseAd;
@end

NS_ASSUME_NONNULL_END
