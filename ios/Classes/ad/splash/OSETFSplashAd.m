//
//  OSETFSplashAd.m
//  flutter_openset_ads
//
//  Created by Shens on 7/8/2025.
//

#import "OSETFSplashAd.h"
#import <OSETSDK/OSETSDK.h>
#import <AppTrackingTransparency/AppTrackingTransparency.h>
#import <AdSupport/AdSupport.h>

@interface OSETFSplashAd () <OSETSplashAdDelegate>

@property(nonatomic, strong) OSETSplashAd *splashAd;


@end
@implementation OSETFSplashAd
- (void)loadSplashAd {
    if (self.splashAd) {
        return;
    }
    if ( @available(iOS
    14, *)) {
        [ATTrackingManager requestTrackingAuthorizationWithCompletionHandler:^(
                ATTrackingManagerAuthorizationStatus status) {
            if ([NSThread isMainThread]) {
                [self innerLoadSplashAd];
            } else {
                dispatch_sync(dispatch_get_main_queue(), ^{
                    // 非主线程，将UI操作切换到主线程进行，请求广告
                    [self innerLoadSplashAd];
                });
            }
        }];
    } else {
        [self innerLoadSplashAd];
    }
}

- (void)innerLoadSplashAd {
    if (self.splashAd) {
        return;
    }

    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    UIViewController *rvc = window.rootViewController;
    UIView *bottomView = [self getBottomView:0];

    self.splashAd = [[OSETSplashAd alloc] initWithSlotId:_adParams.posId window:window bottomView:bottomView];
    self.splashAd.delegate = self;

    // 构建底部logo控件
    if (bottomView) {
        self.splashAd.bottomView = bottomView;
    }
    /// 加载开屏广告
    [self.splashAd loadSplashAd];
    
}
#pragma mark OSETSplashAdDelegate
- (void)splashDidReceiveSuccess:(nonnull id)splashAd slotId:(nonnull NSString *)slotId {
    OSETFAdEventManager *osetAdEventManager = [OSETFAdEventManager sharedManager];
    [osetAdEventManager postOnAdLoadEvent:_adParams];
    [self.splashAd showSplashAd];
    [osetAdEventManager postOnAdExposeEvent:_adParams];
}

- (void)splashLoadToFailed:(nonnull id)splashAd error:(nonnull NSError *)error {
    OSETFAdEventManager *osetAdEventManager = [OSETFAdEventManager sharedManager];
    [osetAdEventManager postOnAdLoadFailedEvent:_adParams message:error.domain];
}

- (void)splashDidClick:(nonnull id)splashAd {
    OSETFAdEventManager *osetAdEventManager = [OSETFAdEventManager sharedManager];
    [osetAdEventManager postOnAdClickEvent:_adParams];
}

- (void)splashDidClose:(nonnull id)splashAd {
    OSETFAdEventManager *osetAdEventManager = [OSETFAdEventManager sharedManager];
    [osetAdEventManager postOnAdCloseEvent:_adParams];
}
- (UIView *)getBottomView:(CGFloat)bottomViewOffY {
    NSString *adLogo = _adParams.adLogo;

    if (adLogo) {
        UIImage *logoImage = [UIImage imageNamed:adLogo];
        if (logoImage) {
            // 开屏广告机型适配
            CGFloat bottomViewHeight = 156;

            // 底部视图设置
            UIView *bottomView = [[UIView alloc] init];
            bottomView.backgroundColor = [UIColor whiteColor];
            bottomView.frame = CGRectMake(0, bottomViewOffY,
                                          [UIScreen mainScreen].bounds.size.width,
                                          bottomViewHeight);

            CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
            CGFloat logoWidth = logoImage.size.width * 92 / logoImage.size.height;
            if (logoWidth > screenWidth - 32) {
                logoWidth = screenWidth - 32;
            }

            UIImageView *logoImageView = [[UIImageView alloc] initWithImage:logoImage];
            logoImageView.frame = CGRectMake(
                    ([UIScreen mainScreen].bounds.size.width - logoWidth) / 2,
                    (bottomViewHeight - 92) / 2, logoWidth, 92);
            [bottomView addSubview:logoImageView];

            return bottomView;
        }
    }
    return nil;
}
-(void)dealloc{
//    NSLog(@"dealloc-%@",self);
    self.splashAd.delegate = nil;
    self.splashAd = nil;
}
@end
