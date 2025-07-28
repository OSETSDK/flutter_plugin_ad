//
//  IOSFlutterNativeView.h
//  flutter_openset_ads
//
//  Created by Shens on 28/7/2025.
//

#import <Foundation/Foundation.h>
#import <Flutter/Flutter.h>
#import <OSETSDK/OSETSDK.h>
NS_ASSUME_NONNULL_BEGIN

@interface IOSFlutterNativeView : NSObject<FlutterPlatformView,OSETNativeAdDelegate>

@property(nonatomic,strong) UIView * nativeView;
@property (nonatomic,strong) OSETNativeAd *nativeAd;
@property (nonatomic,assign) CGRect nativeFrame;

-(id)initWithAdId:(NSString *)adId withFrame:(CGRect)frame;

@end

NS_ASSUME_NONNULL_END
