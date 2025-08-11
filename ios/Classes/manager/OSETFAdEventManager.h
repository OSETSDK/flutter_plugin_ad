//
//  OSETFAdEventManager.h
//  flutter_openset_ads
//
//  Created by Shens on 7/8/2025.
//

#import <Foundation/Foundation.h>
#import <Flutter/Flutter.h>
#import "OSETAdModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface OSETFAdEventManager : NSObject <FlutterStreamHandler>

@property (nonatomic, strong) FlutterEventSink eventSink;

+ (instancetype)sharedManager;

- (void)postOnAdLoadEvent:(OSETAdModel*)adParams;
- (void)postOnAdLoadFailedEvent:(OSETAdModel*)adParams message:(NSString*)message;
- (void)postOnAdMeasuredEvent:(OSETAdModel*)adParams extras:(NSMutableDictionary*)extras;
- (void)postOnAdExposeEvent:(OSETAdModel*)adParams;
- (void)postOnAdClickEvent:(OSETAdModel*)adParams;
- (void)postOnAdCloseEvent:(OSETAdModel*)adParams;
- (void)postOnAdRenderEvent:(OSETAdModel*)adParams;
- (void)postOnAdRewardEvent:(OSETAdModel*)adParams;
+ (UIViewController *)getCurrentViewController;
@end

NS_ASSUME_NONNULL_END
