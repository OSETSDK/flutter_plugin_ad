package com.sskj.flutter_plugin_ad;

import android.Manifest;
import android.annotation.TargetApi;
import android.app.Activity;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.os.Build;
import android.text.TextUtils;
import android.view.ViewGroup;
import android.widget.FrameLayout;

import com.jiagu.sdk.OSETSDKProtected;
import com.kc.openset.VideoContentConfig;
import com.kc.openset.ad.full.OSETFullAd;
import com.kc.openset.ad.full.OSETFullVideo;
import com.kc.openset.ad.intestitial.OSETInterstitial;
import com.kc.openset.ad.intestitial.OSETInterstitialAd;
import com.kc.openset.ad.listener.OSETFullAdLoadListener;
import com.kc.openset.ad.listener.OSETFullVideoListener;
import com.kc.openset.ad.listener.OSETInterstitialAdLoadListener;
import com.kc.openset.ad.listener.OSETInterstitialListener;
import com.kc.openset.ad.listener.OSETRewardAdLoadListener;
import com.kc.openset.ad.listener.OSETRewardListener;
import com.kc.openset.ad.listener.OSETSplashAdLoadListener;
import com.kc.openset.ad.listener.OSETSplashListener;
import com.kc.openset.ad.reward.OSETRewardAd;
import com.kc.openset.ad.reward.OSETRewardVideo;
import com.kc.openset.ad.splash.OSETSplash;
import com.kc.openset.ad.splash.OSETSplashAd;
import com.kc.openset.config.OSETSDK;
import com.kc.openset.listener.OSETInitListener;
import com.kc.openset.video.OSETVideoContent;
import com.kc.openset.video.OSETVideoContentTaskListener;
import com.sskj.flutter_plugin_ad.callback.ClickItem;
import com.sskj.flutter_plugin_ad.entity.AdEvent;
import com.sskj.flutter_plugin_ad.entity.AdType;
import com.sskj.flutter_plugin_ad.entity.EventType;

import java.util.ArrayList;
import java.util.List;

import io.flutter.Log;
import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.EventChannel;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.PluginRegistry;


public class PluginAdSetDelegate implements PluginRegistry.ActivityResultListener, EventChannel.StreamHandler, PluginRegistry.RequestPermissionsResultListener {

    private final String TAG = PluginAdSetDelegate.class.getSimpleName();
    public FlutterPlugin.FlutterPluginBinding bind;
    public Activity activity;

    private MethodChannel.Result pendingResult;
    private EventChannel.EventSink eventSink;
    // 请求权限 code
    private static final int PERMISSIONS_REQUEST_CODE = 1024;
    // 开屏广告 code
    private static final int SHOW_SPLASH_AD_REQUEST_CODE = 1025;
    // 广告参数
    public static final String AD_ID = "adId";
    public static final String USER_ID = "userId";
    private static PluginAdSetDelegate _instance;

    public static PluginAdSetDelegate getInstance() {
        return _instance;
    }

    public PluginAdSetDelegate(Activity activity, FlutterPlugin.FlutterPluginBinding bind) {
        this.bind = bind;
        this.activity = activity;
        _instance = this;
    }

    /**
     * 初始化
     *
     * @param call   MethodCall
     * @param result Result
     */
    public void initAd(MethodCall call, MethodChannel.Result result) {
        // 一定要在 Application 中初始化 sdk，第一个参数需要填入 Application，否则无 法正常使用 sdk
        String appKey = call.argument("appKey");
        if (TextUtils.isEmpty(appKey)) {
            result.error("-200", "参数错误，appKey 不能为空", new Exception("参数错误，appKey 不能为空"));
            return;
        }
        boolean isDebug = call.argument("isDebug");

        try {
            OSETSDKProtected.install(activity.getApplication());
            OSETSDK.getInstance().init(activity.getApplication(), appKey, new OSETInitListener() {
                @Override
                public void onError(String s) {

                }

                @Override
                public void onSuccess() {

                }
            });
//            OSETSDK.getInstance().setIsDebug(isDebug);

            result.success(true);
            Log.d(TAG, "初始化完成");
        } catch (Exception e) {
            Log.d(TAG, "初始化失败 error:" + e.getMessage());
            result.error("-100", "初始化失败", e);
        }
    }

    public static boolean sFirst = true;

    /**
     * 展示开屏广告
     *
     * @param call   MethodCall
     * @param result Result
     */
    public void showSplashAd(MethodCall call, MethodChannel.Result result) {
        String adId = call.argument(AD_ID);
        if (TextUtils.isEmpty(adId)) {
            result.error("-300", "参数错误，posId 不能为空", new Exception("参数错误，posId 不能为空"));
            return;
        }
        ViewGroup decorView = (ViewGroup) activity.getWindow().getDecorView();
        ViewGroup fl = decorView.findViewById(android.R.id.content);
        FrameLayout frameLayout = new FrameLayout(activity);
        FrameLayout.LayoutParams params = new FrameLayout.LayoutParams(FrameLayout.LayoutParams.MATCH_PARENT, FrameLayout.LayoutParams.MATCH_PARENT);
        frameLayout.setLayoutParams(params);
        fl.addView(frameLayout);
        OSETSplash.getInstance().setContext(activity).setPosId(adId).loadAd(new OSETSplashAdLoadListener() {
            @Override
            public void onLoadSuccess(OSETSplashAd osetSplashAd) {
                osetSplashAd.showAd(activity, frameLayout, new OSETSplashListener() {
                    @Override
                    public void onAdDetailViewClosed() {

                    }

                    @Override
                    public void onClick() {
                        PluginAdSetDelegate.getInstance().addEvent(new AdEvent(EventType.onAdClicked, "", AdType.SPLASH));
                    }

                    @Override
                    public void onClose() {
                        PluginAdSetDelegate.getInstance().addEvent(new AdEvent(EventType.onAdClosed, "", AdType.SPLASH));
                        fl.removeView(frameLayout);
                        osetSplashAd.destroy();
                    }

                    @Override
                    public void onShow() {
                        PluginAdSetDelegate.getInstance().addEvent(new AdEvent("onAdShow", "", AdType.SPLASH));
                    }

                    @Override
                    public void onError(String s, String s1) {
                        PluginAdSetDelegate.getInstance().addEvent(new AdEvent(EventType.onAdClicked, "错误：" + s + ", " + s1, AdType.SPLASH));
                        fl.removeView(frameLayout);
                    }
                });
            }

            @Override
            public void onLoadFail(String s, String s1) {
                PluginAdSetDelegate.getInstance().addEvent(new AdEvent(EventType.onAdError, "", AdType.SPLASH));
                fl.removeView(frameLayout);
            }
        });
    }

    public void showInterstitialAd(MethodCall call, MethodChannel.Result result) {
        String adId = call.argument(AD_ID);
        if (TextUtils.isEmpty(adId)) {
            result.error("-300", "参数错误，posId 不能为空", new Exception("参数错误，posId 不能为空"));
            return;
        }
        //在首页中OnCreate调用以下代码可以开始加载广告并缓存
        OSETInterstitial.getInstance()
                .setContext(activity)
                .setPosId(adId)
                .loadAd(new OSETInterstitialAdLoadListener() {


                    @Override
                    public void onLoadFail(String s, String s1) {

                    }

                    @Override
                    public void onLoadSuccess(OSETInterstitialAd osetInterstitialAd) {
                        osetInterstitialAd.showAd(activity, new OSETInterstitialListener() {
                            @Override
                            public void onShow() {
                                addEvent(new AdEvent(EventType.onAdExposure, "", AdType.INTERSTITIAL));
                            }

                            @Override
                            public void onError(String s, String s1) {
                                addEvent(new AdEvent(EventType.onAdError, "", AdType.INTERSTITIAL));
                            }

                            @Override
                            public void onClick() {
                                addEvent(new AdEvent(EventType.onAdClicked, "", AdType.INTERSTITIAL));
                            }

                            @Override
                            public void onClose() {
                                addEvent(new AdEvent(EventType.onAdClosed, "", AdType.INTERSTITIAL));
                            }
                        });
                    }
                });
        result.success(true);
    }

    public void showFullscreenVideoAd(MethodCall call, MethodChannel.Result result) {
        String adId = call.argument(AD_ID);
        if (TextUtils.isEmpty(adId)) {
            result.error("-300", "参数错误，posId 不能为空", new Exception("参数错误，posId 不能为空"));
            return;
        }
        //在首页中OnCreate调用以下代码可以开始加载广告并缓存
        OSETFullVideo.getInstance()
                .setContext(activity)
                .setPosId(adId)
                .loadAd(new OSETFullAdLoadListener() {
                    @Override
                    public void onLoadSuccess(OSETFullAd osetFullAd) {
                        osetFullAd.showAd(activity, new OSETFullVideoListener() {

                            @Override
                            public void onVideoStart() {
                                android.util.Log.d(TAG, "onVideoStart---");
                            }

                            @Override
                            public void onError(String s, String s1) {
                                addEvent(new AdEvent(EventType.onAdError, "错误：" + s + ", " + s1, AdType.FULL_SCREEN_VIDEO));
                            }

                            @Override
                            public void onClick() {
                                addEvent(new AdEvent(EventType.onAdClicked, "", AdType.FULL_SCREEN_VIDEO));
                            }

                            @Override
                            public void onClose() {
                                addEvent(new AdEvent(EventType.onAdClosed, "", AdType.FULL_SCREEN_VIDEO));
                            }

                            @Override
                            public void onShow() {
                                addEvent(new AdEvent(EventType.onAdExposure, "", AdType.FULL_SCREEN_VIDEO));
                            }

                            @Override
                            public void onVideoEnd() {
                                android.util.Log.d(TAG, "onVideoEnd---key:");
                            }

                        });
                    }

                    @Override
                    public void onLoadFail(String s, String s1) {
                        addEvent(new AdEvent(EventType.onAdError, "", AdType.FULL_SCREEN_VIDEO));
                    }
                });
        result.success(true);
    }

    public void startLoadRewardVideo(MethodCall call, MethodChannel.Result result) {
        String adId = call.argument(AD_ID);
        String userId = call.argument(USER_ID);
        if (TextUtils.isEmpty(adId)) {
            result.error("-300", "参数错误，posId 不能为空", new Exception("参数错误，posId 不能为空"));
            return;
        }
        //这一步建议在首页进行初始化并开启缓存,减少第一次展示广告的时间。并且在首页onDestroy里面调用destroy()方法释放资源
        OSETRewardVideo.getInstance()
                .setContext(activity)
                .setPosId(adId)
                .setUserId(userId)
                .startLoad();
        result.success(true);
    }

    public void showRewardVideo(MethodCall call, MethodChannel.Result result) {

        String adId = call.argument(AD_ID);
        String userId = call.argument(USER_ID);
        if (TextUtils.isEmpty(adId)) {
            result.error("-300", "参数错误，posId 不能为空", new Exception("参数错误，posId 不能为空"));
            return;
        }
        //这一步建议在首页进行初始化并开启缓存,减少第一次展示广告的时间。并且在首页onDestroy里面调用destroy()方法释放资源
        OSETRewardVideo.getInstance()
                .setContext(activity)
                .setPosId(adId)
                .setUserId(userId)
                .loadAd(new OSETRewardAdLoadListener() {
                    @Override
                    public void onLoadSuccess(OSETRewardAd osetRewardAd) {
                        osetRewardAd.showAd(activity, new OSETRewardListener() {
                            @Override
                            public void onClick() {
                                addEvent(new AdEvent(EventType.onAdClicked, "", AdType.REWARD_VIDEO));
                            }

                            @Override
                            public void onClose() {
                                addEvent(new AdEvent(EventType.onAdClosed, "", AdType.REWARD_VIDEO));
                            }

                            @Override
                            public void onReward() {
                                // 获得奖励后回调
                                addEvent(new AdEvent(EventType.onReward, "", AdType.REWARD_VIDEO));
                            }

                            @Override
                            public void onServiceResponse(int i) {
                            }

                            @Override
                            public void onShow() {
                                addEvent(new AdEvent(EventType.onAdExposure, "", AdType.REWARD_VIDEO));
                            }

                            @Override
                            public void onVideoEnd() {
                            }

                            @Override
                            public void onVideoStart() {
                            }

                            @Override
                            public void onError(String s, String s1) {
                                addEvent(new AdEvent(EventType.onAdError, "错误：" + s + ", " + s1, AdType.REWARD_VIDEO));
                            }
                        });
                    }

                    @Override
                    public void onLoadFail(String s, String s1) {
                        addEvent(new AdEvent(EventType.onAdError, "错误：" + s + ", " + s1, AdType.REWARD_VIDEO));
                    }
                });
        result.success(true);
    }

    public void showVideoPage(MethodCall call, MethodChannel.Result result) {
        String adId = call.argument(AD_ID);
        int rewardCount = call.argument("rewardCount");
        int rewardDownTime = call.argument("rewardDownTime");
        if (TextUtils.isEmpty(adId)) {
            result.error("-300", "参数错误，posId 不能为空", new Exception("参数错误，posId 不能为空"));
            return;
        }

        VideoContentConfig videoContentConfig = new VideoContentConfig.Builder()
                .setNeedBack(true)
                .setRewardCount(rewardCount)
                .setRewardDownTime(rewardDownTime)
                .build();
        OSETVideoContent.getInstance().setPosId(adId).showByActivity(activity, videoContentConfig, new OSETVideoContentTaskListener() {

            @Override
            public void onClose() {
                //关闭回调
                addEvent(new AdEvent(EventType.onAdClosed, "", AdType.VIDEO_CONTENT));
            }

            @Override
            public void onLoadFail(String s, String s1) {
                Log.e(TAG, "code:" + s + "----message:" + s1);
                // 出错了
                addEvent(new AdEvent(EventType.onAdError, "code: " + s + ", msg: " + s1, AdType.VIDEO_CONTENT));
            }

            @Override
            public void onTimeOver() {
                //key用做校验
                // 验证地址 http://open-set-api.shenshiads.com/reward/check/<key>（返回数据: {"code": 0}，code为0表示验证成
                addEvent(new AdEvent(EventType.onAdTimeOver, "", AdType.VIDEO_CONTENT));
            }

            @Override
            public void onVideoComplete(int i, boolean b, String s) {
                //视频结束播放
                android.util.Log.e(TAG, "视频结束播放:" + i);
            }

            @Override
            public void onVideoPause(int i, boolean b, String s) {
                //视频暂停播放
                android.util.Log.e(TAG, "视频暂停播放:" + i);
            }

            @Override
            public void onVideoPlayError(int i, boolean b, String s, String s1, String s2) {

            }

            @Override
            public void onVideoResume(int i, boolean b, String s) {
                //视频重新播放
                android.util.Log.e(TAG, "视频重新播放:" + i);
            }

            @Override
            public void onVideoStart(int i, boolean b, String s) {
                //视频开始播放
                android.util.Log.e(TAG, "视频开始播放:" + i);
            }
        });
        result.success(true);
    }

    public void showKsVideoFragment(MethodCall call, MethodChannel.Result result) {

        String adId = call.argument(AD_ID);
        if (TextUtils.isEmpty(adId)) {
            result.error("-300", "参数错误，posId 不能为空", new Exception("参数错误，posId 不能为空"));
            return;
        }

        Intent intent = new Intent(activity, KsAdActivity.class);
        intent.putExtra(AD_ID, adId);
        activity.startActivity(intent);
        activity.overridePendingTransition(0, 0);
        KsAdActivity.onClickItem(new ClickItem() {
            @Override
            public void selectItem(int index) {
                Log.e(TAG, "index: " + index);
                result.success(index);
                AdEvent adEvent = new AdEvent("KsVideoFragment", index + "");
                addEvent(adEvent);
            }
        });
    }


    /**
     * 展示 Banner 广告
     */
    public void registerBannerView() {
        bind.getPlatformViewRegistry()
                .registerViewFactory("flutter_plugin_ad_banner", new AdBannerViewFactory("flutter_plugin_ad_banner", this));
    }

    /**
     * 展示原生广告
     */
    public void registerNativeView() {
        bind.getPlatformViewRegistry()
                .registerViewFactory("flutter_plugin_ad_native", new AdNativeViewFactory("flutter_plugin_ad_native", this));
    }


    /**
     * demo
     *
     * @param call   MethodCall
     * @param result Result
     */
    public void getPlatformVersion(MethodCall call, MethodChannel.Result result) {
        result.success("Android " + Build.VERSION.RELEASE);
    }

    /**
     * 检查并请求权限
     *
     * @param call   MethodCall
     * @param result Result
     */
    public void checkAndReqPermission(MethodCall call, MethodChannel.Result result) {
        // 如果targetSDKVersion >= 23，就要申请好权限。如果您的App没有适配到Android6.0（即targetSDKVersion < 23），那么只需要在这里直接调用fetchSplashAD接口。
        if (Build.VERSION.SDK_INT >= 23) {
            checkAndRequestPermission();
        }
        result.success(true);
    }

    /**
     * ----------非常重要----------
     * <p>
     * Android6.0以上的权限适配简单示例：
     * <p>
     * 如果targetSDKVersion >= 23，那么必须要申请到所需要的权限，再调用SDK，否则SDK不会工作。
     * <p>
     * Demo代码里是一个基本的权限申请示例，请开发者根据自己的场景合理地编写这部分代码来实现权限申请。
     * 注意：下面的`checkSelfPermission`和`requestPermissions`方法都是在Android6.0的SDK中增加的API，如果您的App还没有适配到Android6.0以上，则不需要调用这些方法，直接调用广点通SDK即可。
     */
    @TargetApi(Build.VERSION_CODES.M)
    private void checkAndRequestPermission() {
        List<String> lackedPermission = new ArrayList<>();
        if (!(activity.checkSelfPermission(Manifest.permission.READ_PHONE_STATE) == PackageManager.PERMISSION_GRANTED)) {
            lackedPermission.add(Manifest.permission.READ_PHONE_STATE);
        }

        if (!(activity.checkSelfPermission(Manifest.permission.WRITE_EXTERNAL_STORAGE) == PackageManager.PERMISSION_GRANTED)) {
            lackedPermission.add(Manifest.permission.WRITE_EXTERNAL_STORAGE);
        }

        if (!(activity.checkSelfPermission(Manifest.permission.ACCESS_FINE_LOCATION) == PackageManager.PERMISSION_GRANTED)) {
            lackedPermission.add(Manifest.permission.ACCESS_FINE_LOCATION);
        }
        if (!(activity.checkSelfPermission(Manifest.permission.ACCESS_COARSE_LOCATION) == PackageManager.PERMISSION_GRANTED)) {
            lackedPermission.add(Manifest.permission.ACCESS_COARSE_LOCATION);//申请经纬度坐标权限
        }

        if (lackedPermission.size() != 0) {
            // 请求所缺少的权限，在onRequestPermissionsResult中再看是否获得权限，如果获得权限就可以调用SDK，否则不要调用SDK。
            String[] requestPermissions = new String[lackedPermission.size()];
            lackedPermission.toArray(requestPermissions);
            activity.requestPermissions(requestPermissions, 1024);
        }
    }


    /**
     * 添加事件
     *
     * @param eventType
     */
    public void addEvent(String eventType) {
        Log.d(TAG, "addEvent eventType:" + eventType);
        if (eventType != null) {
            addEvent(new AdEvent(eventType));
        }
    }

    /**
     * 添加事件
     *
     * @param adEvent
     */
    public void addEvent(AdEvent adEvent) {
        if (eventSink != null && adEvent != null) {
            Log.d(TAG, "addEvent adEvent:" + adEvent.toMap());
            eventSink.success(adEvent.toMap());
        }
    }

    @Override
    public void onListen(Object arguments, EventChannel.EventSink events) {
        eventSink = events;
    }

    @Override
    public void onCancel(Object arguments) {
        eventSink = null;
    }

    @Override
    public boolean onActivityResult(int requestCode, int resultCode, Intent data) {
        return false;
    }

    @Override
    public boolean onRequestPermissionsResult(int requestCode, String[] permissions, int[] grantResults) {
        return false;
    }
}
