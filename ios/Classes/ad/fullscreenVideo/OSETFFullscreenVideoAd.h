//
//  OSETFFullscreenVideoAd.h
//  flutter_openset_ads
//
//  Created by Shens on 8/8/2025.
//

#import <Foundation/Foundation.h>
#import "OSETFAdEventManager.h"
#import "OSETAdModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface OSETFFullscreenVideoAd : NSObject
@property(nonatomic) OSETAdModel *adParams;
@property(nonatomic) bool isRequestIdfa;

- (void)loadFullscreenVideoAd;
@end

NS_ASSUME_NONNULL_END
