//
//  IOSFlutterNativeView.m
//  flutter_openset_ads
//
//  Created by Shens on 28/7/2025.
//

#import "IOSFlutterNativeView.h"
#import "FlutterPluginAdPlugin.h"
#import "OSETFNativeAdManager.h"
@implementation IOSFlutterNativeView

-(instancetype)initWithWithFrame:(CGRect)frame viewIdentifier:(int64_t)viewId arguments:(id)args binaryMessenger:(NSObject<FlutterBinaryMessenger> *)messenger{
    if ([args isKindOfClass:[NSDictionary class]]) {
        NSDictionary *params = args;
        NSString *adId = params[@"adId"];
        if (adId) {
            OSETFNativeAdManager *nativeExpressAdManager = [OSETFNativeAdManager getOSETFNativeAdManager];
            _nativeView = [nativeExpressAdManager getNativeAdView:adId];
        }
    }
    return self;
}
- (nonnull UIView *)view {
    if (_nativeView) {
        return _nativeView;
    }
    return [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
}
@end
