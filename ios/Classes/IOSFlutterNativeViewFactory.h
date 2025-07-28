//
//  IOSFlutterNativeViewFactory.h
//  flutter_openset_ads
//
//  Created by Shens on 28/7/2025.
//

#import <Foundation/Foundation.h>
#import <Flutter/Flutter.h>
NS_ASSUME_NONNULL_BEGIN

@interface IOSFlutterNativeViewFactory : NSObject<FlutterPlatformViewFactory>
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar> *)registrar;

@end

NS_ASSUME_NONNULL_END
