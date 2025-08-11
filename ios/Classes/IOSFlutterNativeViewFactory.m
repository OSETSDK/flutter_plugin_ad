//
//  IOSFlutterNativeViewFactory.m
//  flutter_openset_ads
//
//  Created by Shens on 28/7/2025.
//

#import "IOSFlutterNativeViewFactory.h"
#import "IOSFlutterNativeView.h"

@implementation IOSFlutterNativeViewFactory{
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
    IOSFlutterNativeView *nativeExpressAdView = [[IOSFlutterNativeView alloc] initWithWithFrame:frame viewIdentifier:viewId arguments:args binaryMessenger:_messenger];
    return nativeExpressAdView;
}

@end
