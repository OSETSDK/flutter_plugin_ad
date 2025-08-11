//
//  IOSPlatformView.m
//  Runner
//
//  Created by YaoHaoFei on 2022/4/21.

#import "IOSPlatformView.h"
#import "FlutterPluginAdPlugin.h"
#import "OSETFBannerAdManager.h"
@implementation IOSPlatformView

-(instancetype)initWithWithFrame:(CGRect)frame viewIdentifier:(int64_t)viewId arguments:(id)args binaryMessenger:(NSObject<FlutterBinaryMessenger> *)messenger{
    if ([args isKindOfClass:[NSDictionary class]]) {
        NSDictionary *params = args;
        NSString *adId = params[@"adId"];
        if (adId) {
            OSETFBannerAdManager * osetBannerAdManager = [OSETFBannerAdManager getOSETFBannerAdManager];
            _bannerView = [osetBannerAdManager getBannerAdView:adId];
        }
    }
    return self;
}
- (nonnull UIView *)view {
    if (_bannerView) {
        return _bannerView;
    }
    return [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
}

@end
