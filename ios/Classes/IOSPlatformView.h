//
//  IOSPlatformView.h
//  Runner
//
//  Created by YaoHaoFei on 2022/4/21.
//

#import <Foundation/Foundation.h>
#import <Flutter/Flutter.h>
#import <OSETSDK/OSETSDK.h>
NS_ASSUME_NONNULL_BEGIN

@interface IOSPlatformView : NSObject<FlutterPlatformView,OSETBannerAdDelegate>

@property(nonatomic,strong) UIView * bannerView;
@property (nonatomic,strong) OSETBannerAd *bannerAd;
@property (nonatomic,assign) CGRect bannerFrame;

-(id)initWithAdId:(NSString *)adId withFrame:(CGRect)frame;
@end

NS_ASSUME_NONNULL_END
