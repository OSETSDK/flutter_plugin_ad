//
//  IOSPlatformView.m
//  Runner
//
//  Created by YaoHaoFei on 2022/4/21.

#import "IOSPlatformView.h"
#import "FlutterPluginAdPlugin.h"

@implementation IOSPlatformView

-(id)initWithAdId:(NSString *)adId withFrame:(CGRect)frame{
    self = [super init];
    if (self) {
        self = [super init];
        self.bannerFrame = frame;
        if (adId && ![adId isKindOfClass:[NSNull class]] && adId.length>0) {
            self.bannerAd = [[OSETBannerAd alloc] initWithSlotId:adId rootViewController:[UIApplication sharedApplication].delegate.window.rootViewController rect:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.width*90/600)];
            self.bannerAd.delegate = self;
            [self.bannerAd loadAdData];
        }
    }
    return self;
}

- (UIView *)bannerView{
    if(_bannerView == nil){
        _bannerView = [[UIView alloc]initWithFrame:self.bannerFrame];
    }
    return _bannerView;
}

- (UIView *)view{
    return [self bannerView];
}
- (void)bannerDidReceiveSuccess:(id)bannerView slotId:(NSString *)slotId{
    FlutterPluginAdPlugin * delegate = [FlutterPluginAdPlugin shareInstance];
    CGFloat height = 0;
    if([bannerView isKindOfClass:[UIView class]]){
        UIView * banner = bannerView;
        banner.frame = CGRectMake(0,0, banner.frame.size.width, banner.frame.size.height);
        height = banner.frame.size.height;
    }
    if(delegate.eventSink) delegate.eventSink(@{@"eventType":@"onAdLoaded",@"adType":@"banner",@"msg":@"",@"height":@(height)});
}
/// banner加载失败
- (void)bannerLoadToFailed:(id)bannerView error:(NSError *)error{
    FlutterPluginAdPlugin * delegate = [FlutterPluginAdPlugin shareInstance];
    if(delegate.eventSink) delegate.eventSink(@{@"eventType":@"onAdError",@"adType":@"banner",@"msg":[NSString stringWithFormat:@"code = %ld",(long)error.code]});
}
- (void)bannerDidClose:(id)bannerView{
    UIView *view = (UIView *)bannerView;
    [view removeFromSuperview];
    FlutterPluginAdPlugin * delegate = [FlutterPluginAdPlugin shareInstance];
    if(delegate.eventSink) delegate.eventSink(@{@"eventType":@"onAdClosed",@"adType":@"banner",@"msg":@""});

}
/// banner点击
- (void)bannerDidClick:(id)bannerView{
    FlutterPluginAdPlugin * delegate = [FlutterPluginAdPlugin shareInstance];
    if(delegate.eventSink) delegate.eventSink(@{@"eventType":@"onAdClick",@"adType":@"banner",@"msg":@""});
}
@end
