//
//  IOSFlutterPlatformViewFactory.m
//  Runner
//
//  Created by YaoHaoFei on 2022/4/21.
//

#import "IOSFlutterPlatformViewFactory.h"
#import "IOSPlatformView.h"
#import "OSETFBannerAdManager.h"
@implementation IOSFlutterPlatformViewFactory{
    NSObject<FlutterBinaryMessenger>*_messenger;
}

- (instancetype)initWithMessenger:(NSObject<FlutterBinaryMessenger> *)messager{
    self = [super init];
    if (self) {
        _messenger = messager;
    }
    return self;
}

// 设置参数的编码方式
-(NSObject<FlutterMessageCodec> *)createArgsCodec{
    return [FlutterStandardMessageCodec sharedInstance];
}

//用来创建 ios 原生view
- (nonnull NSObject<FlutterPlatformView> *)createWithFrame:(CGRect)frame viewIdentifier:(int64_t)viewId arguments:(id _Nullable)args {
    // args 为flutter 传过来的参数
    IOSPlatformView *nativeExpressAdView = [[IOSPlatformView alloc] initWithWithFrame:frame viewIdentifier:viewId arguments:args binaryMessenger:_messenger];
    return nativeExpressAdView;
}

@end
