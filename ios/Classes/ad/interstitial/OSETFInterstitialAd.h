//
//  OSETFInterstitialAd.h
//  flutter_openset_ads
//
//  Created by Shens on 7/8/2025.
//

#import <Foundation/Foundation.h>
#import "OSETFAdEventManager.h"
#import "OSETAdModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface OSETFInterstitialAd : NSObject
@property(nonatomic) OSETAdModel *adParams;
@property(nonatomic) bool isRequestIdfa;

- (void)loadInterstitialAd;
@end

NS_ASSUME_NONNULL_END
