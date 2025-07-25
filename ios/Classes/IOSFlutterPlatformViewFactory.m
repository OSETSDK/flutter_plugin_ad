//
//  IOSFlutterPlatformViewFactory.m
//  Runner
//
//  Created by YaoHaoFei on 2022/4/21.
//

#import "IOSFlutterPlatformViewFactory.h"
#import "IOSPlatformView.h"
@implementation IOSFlutterPlatformViewFactory

/**
 * 返回platformview实现类
 *@param frame 视图的大小
 *@param viewId 视图的唯一表示id
 *@param args 从flutter  creationParams 传回的参数
 *
 */
- (NSObject<FlutterPlatformView> *)createWithFrame:(CGRect)frame viewIdentifier:(int64_t)viewId arguments:(id)args{
    //这里可以解析args参数，根据参数进行响应的操作
    if (args) {
        NSDictionary * dict = [NSDictionary dictionaryWithDictionary:args];
        return [[IOSPlatformView alloc]initWithAdId:dict[@"adId"] withFrame:frame];
    }
    return [[IOSPlatformView alloc]initWithAdId:@"" withFrame:frame];
}

//如果需要使用args传参到ios，需要实现这个方法，返回协议。否则会失败。
- (NSObject<FlutterMessageCodec> *)createArgsCodec{
    return [FlutterStandardMessageCodec sharedInstance];
}
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar> *)registrar{
    [registrar registerViewFactory:[[IOSFlutterPlatformViewFactory alloc] init] withId:@"flutter_plugin_ad_banner"];
}
@end
