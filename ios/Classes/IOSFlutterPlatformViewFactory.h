//
//  IOSFlutterPlatformViewFactory.h
//  Runner
//
//  Created by YaoHaoFei on 2022/4/21.
//

#import <Foundation/Foundation.h>
#import <Flutter/Flutter.h>
NS_ASSUME_NONNULL_BEGIN

@interface IOSFlutterPlatformViewFactory : NSObject<FlutterPlatformViewFactory>
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar> *)registrar;
@end

NS_ASSUME_NONNULL_END
