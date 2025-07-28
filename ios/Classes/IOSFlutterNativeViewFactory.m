//
//  IOSFlutterNativeViewFactory.m
//  flutter_openset_ads
//
//  Created by Shens on 28/7/2025.
//

#import "IOSFlutterNativeViewFactory.h"
#import "IOSFlutterNativeView.h"
@implementation IOSFlutterNativeViewFactory

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
        CGFloat height = 300;
        if(dict[@"height"]){
            height = [dict[@"height"] floatValue];
        }
        return [[IOSFlutterNativeView alloc] initWithAdId:dict[@"adId"] withFrame:CGRectMake(0, 0, 0,height)];
    }
    return [[IOSFlutterNativeView alloc]initWithAdId:@"" withFrame:CGRectMake(0, 0, 0,0)];
}

//如果需要使用args传参到ios，需要实现这个方法，返回协议。否则会失败。
- (NSObject<FlutterMessageCodec> *)createArgsCodec{
    return [FlutterStandardMessageCodec sharedInstance];
}
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar> *)registrar{
    [registrar registerViewFactory:[[IOSFlutterNativeViewFactory alloc] init] withId:@"flutter_plugin_ad_native"];
}
@end
