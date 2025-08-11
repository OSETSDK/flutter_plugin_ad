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

-(instancetype)initWithWithFrame:(CGRect)frame
                  viewIdentifier:(int64_t)viewId
                       arguments:(id _Nullable)args
                 binaryMessenger:(NSObject<FlutterBinaryMessenger>*)messenger;

@end

NS_ASSUME_NONNULL_END



