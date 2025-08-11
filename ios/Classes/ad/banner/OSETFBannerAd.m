//
//  OSETFBannerAd.m
//  flutter_openset_ads
//
//  Created by Shens on 7/8/2025.
//

#import "OSETFBannerAd.h"
#import <AppTrackingTransparency/AppTrackingTransparency.h>
#import <AdSupport/AdSupport.h>

@interface OSETFBannerAd ()<OSETBannerAdDelegate>
@property (nonatomic) bool isAdExposed;
@property (nonatomic) bool isAdClosed;
@property (nonatomic) OSETBannerAd *bannerAd;

@end


@implementation OSETFBannerAd

/// 接到Flutter消息，开始加载信息流广告
- (void)loadBannerAd {
    if (self.bannerAd) {
        return;
    }
    if ( @available(iOS 14, *)) {
        if (_isRequestIdfa) {
            [ATTrackingManager requestTrackingAuthorizationWithCompletionHandler:^(ATTrackingManagerAuthorizationStatus status) {
                if ([NSThread isMainThread]) {
                    [self innerLoadBannerExpressAd ];
                } else {
                    dispatch_sync(dispatch_get_main_queue(), ^{
                        // 非主线程，将UI操作切换到主线程进行，请求广告
                        [self innerLoadBannerExpressAd ];
                    });
                }
            }];
        } else {
            // Fallback on earlier versions
            [self innerLoadBannerExpressAd];
        }
    } else {
        [self innerLoadBannerExpressAd];
    }
}

/// 真正的请求信息流广告
- (void) innerLoadBannerExpressAd {
    if (!self.bannerAd) {
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        UIViewController *rvc = window.rootViewController;
        if([_adParams.adHeight floatValue] <=80){
            _adParams.adHeight = @(80);
        }
        self.bannerAd = [[OSETBannerAd alloc] initWithSlotId:_adParams.posId rootViewController:rvc rect:CGRectMake(0, 0,[_adParams.adWidth floatValue], [_adParams.adHeight floatValue])];
        self.bannerAd.delegate = self;
    }
    [self.bannerAd loadAdData];
}
/// 接到Flutter消息，释放插屏广告
- (void)releaseAd {
    if (self.bannerAd) {
        self.bannerAd = nil;
        if(_bannerAdView){
            [_bannerAdView removeFromSuperview];
        }
        _bannerAdView = nil;
    }
}
- (void)bannerDidReceiveSuccess:(id)bannerView slotId:(NSString *)slotId{
    if(bannerView){
        _bannerAdView = bannerView;
        /// 通知Flutter端
        OSETFAdEventManager *osetAdEventManager = [OSETFAdEventManager sharedManager];
        NSMutableDictionary *extras = [[NSMutableDictionary alloc] initWithCapacity:0];
        [extras setObject:@(_bannerAdView.frame.size.width) forKey:@"adWidth"];
        [extras setObject:@(_bannerAdView.frame.size.height) forKey:@"adHeight"];
        [osetAdEventManager postOnAdMeasuredEvent:_adParams extras: extras];
        [osetAdEventManager postOnAdLoadEvent:_adParams];
        [osetAdEventManager postOnAdRenderEvent:_adParams];
    }
    
}
/// banner加载失败
- (void)bannerLoadToFailed:(id)bannerView error:(NSError *)error{
    OSETFAdEventManager *osetAdEventManager = [OSETFAdEventManager sharedManager];
    [osetAdEventManager postOnAdLoadFailedEvent:_adParams message:error.domain];
}
- (void)bannerDidClose:(id)bannerView{
    OSETFAdEventManager *osetAdEventManager = [OSETFAdEventManager sharedManager];
    [osetAdEventManager postOnAdCloseEvent:_adParams];
}
-(void)bannerDidClick:(id)bannerView{
    OSETFAdEventManager *osetAdEventManager = [OSETFAdEventManager sharedManager];
    [osetAdEventManager postOnAdClickEvent:_adParams];
}
-(void)dealloc{
}
@end
