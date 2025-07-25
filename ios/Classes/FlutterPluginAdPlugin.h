#import <Flutter/Flutter.h>
#import <OSETSDK/OSETSDK.h>
@interface FlutterPluginAdPlugin : NSObject<FlutterPlugin,OSETSplashAdDelegate,OSETInterstitialAdDelegate,OSETRewardVideoAdDelegate,FlutterStreamHandler,OSETFullscreenVideoAdDelegate>

@property (nonatomic,strong) OSETSplashAd *splashAd;
@property (nonatomic,strong) OSETInterstitialAd *interstitialAd;
@property (nonatomic,strong) OSETRewardVideoAd *rewardVideoAd;
@property (nonatomic,strong) OSETFullscreenVideoAd *fullscreenVideoAd;
@property (nonatomic,strong) FlutterViewController * rootVC;
@property (nonatomic, copy) FlutterEventSink eventSink;
+ (instancetype)shareInstance;
@end
