//
//  IOSFlutterNativeView.m
//  flutter_openset_ads
//
//  Created by Shens on 28/7/2025.
//

#import "IOSFlutterNativeView.h"
#import "FlutterPluginAdPlugin.h"
@implementation IOSFlutterNativeView

-(id)initWithAdId:(NSString *)adId withFrame:(CGRect)frame{
    self = [super init];
    if (self) {
        self = [super init];
        self.nativeFrame = frame;
        if (adId && ![adId isKindOfClass:[NSNull class]] && adId.length>0) {
            self.nativeAd  = [[OSETNativeAd alloc]initWithSlotId:adId size:CGSizeMake([UIScreen mainScreen].bounds.size.width, frame.size.height) rootViewController:[FlutterPluginAdPlugin shareInstance].rootVC];
            self.nativeAd.delegate = self;
            [self.nativeAd loadAdData];
        }
    }
    return self;
}

- (UIView *)nativeView{
    if(_nativeView == nil){
        _nativeView = [[UIView alloc]initWithFrame: self.nativeFrame];
        _nativeView.userInteractionEnabled = YES;
    }
    return _nativeView;
}

- (UIView *)view{
    return [self nativeView];
}

- (void)nativeExpressAdLoadSuccessWithNative:(id)native nativeExpressViews:(NSArray *)nativeExpressViews{
    if(nativeExpressViews && [nativeExpressViews isKindOfClass:[NSArray class]] && nativeExpressViews.count > 0){
        FlutterPluginAdPlugin * delegate = [FlutterPluginAdPlugin shareInstance];
        CGFloat height = self.nativeFrame.size.height;
        OSETBaseView * nativeView =nativeExpressViews.firstObject;
        if([nativeView isKindOfClass:[UIView class]]){
            UIView * banner = nativeView;
            banner.frame = CGRectMake(0,0, banner.frame.size.width, banner.frame.size.height);
            height = banner.frame.size.height;
            self.nativeView.frame = CGRectMake(self.nativeFrame.origin.x, self.nativeFrame.origin.x, banner.frame.size.width, height);
            [self.nativeView addSubview:banner];
        }
        if(delegate.eventSink) delegate.eventSink(@{@"eventType":@"onAdLoaded",@"adType":@"native",@"msg":@"",@"height":@(height)});
    }else{
        FlutterPluginAdPlugin * delegate = [FlutterPluginAdPlugin shareInstance];
        if(delegate.eventSink) delegate.eventSink(@{@"eventType":@"onAdError",@"adType":@"native",@"msg":[NSString stringWithFormat:@"code = %ld",(long)720001]});
    }
}
- (void)nativeExpressAdRenderSuccess:(id)nativeExpressView{
 
}
- (void)nativeExpressAdFailedToLoad:(nonnull id)nativeExpressAd error:(nonnull NSError *)error {
    FlutterPluginAdPlugin * delegate = [FlutterPluginAdPlugin shareInstance];
    if(delegate.eventSink) delegate.eventSink(@{@"eventType":@"onAdError",@"adType":@"native",@"msg":[NSString stringWithFormat:@"code = %ld",(long)error.code]});
}
- (void)nativeExpressAdFailedToRender:(nonnull id)nativeExpressView {
}

- (void)nativeExpressAdDidClick:(nonnull id)nativeExpressView {
    FlutterPluginAdPlugin * delegate = [FlutterPluginAdPlugin shareInstance];
    if(delegate.eventSink) delegate.eventSink(@{@"eventType":@"onAdClick",@"adType":@"native",@"msg":@""});

}
- (void)nativeExpressAdDidClose:(nonnull id)nativeExpressView {
    if([nativeExpressView isKindOfClass:[UIView class]]){
        UIView *view = (UIView *)nativeExpressView;
        [view removeFromSuperview];
        [self.nativeView removeFromSuperview];
    }
    FlutterPluginAdPlugin * delegate = [FlutterPluginAdPlugin shareInstance];
    if(delegate.eventSink) delegate.eventSink(@{@"eventType":@"onAdClosed",@"adType":@"native",@"msg":@""});
}

@end
