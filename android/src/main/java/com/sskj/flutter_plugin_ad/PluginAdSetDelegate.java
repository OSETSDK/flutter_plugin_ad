package com.sskj.flutter_plugin_ad;

import android.Manifest;
import android.annotation.TargetApi;
import android.app.Activity;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.location.Location;
import android.location.LocationManager;
import android.os.Build;
import android.text.TextUtils;
import android.util.Log;
import android.view.ViewGroup;
import android.widget.FrameLayout;
import android.widget.Toast;

import androidx.annotation.NonNull;

import com.jiagu.sdk.OSETSDKProtected;
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
import com.kc.openset.config.controller.OSETCustomController;
import com.kc.openset.listener.OSETInitListener;
import com.sskj.flutter_plugin_ad.config.OSETAdEvent;
import com.sskj.flutter_plugin_ad.factory.AdBannerViewFactory;
import com.sskj.flutter_plugin_ad.factory.AdNativeViewFactory;
import com.sskj.flutter_plugin_ad.listener.OnAdReleaseListener;
import com.sskj.flutter_plugin_ad.manager.OSETBannerAdManager;
import com.sskj.flutter_plugin_ad.manager.OSETNativeAdManager;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.EventChannel;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.PluginRegistry;
import io.flutter.plugin.common.MethodChannel.Result;


public class PluginAdSetDelegate implements PluginRegistry.ActivityResultListener, EventChannel.StreamHandler, PluginRegistry.RequestPermissionsResultListener {

    private final String TAG = "adset_plugin";
    public FlutterPlugin.FlutterPluginBinding bind;
    public Activity activity;

    private EventChannel.EventSink _eventChannel;
    private AdBannerViewFactory bannerAdFactory;
    private AdNativeViewFactory nativeAdFactory;
    private final List<OnAdReleaseListener> onAdReleaseListenerList = new ArrayList<>();

    // 请求权限 code
    private static final int PERMISSIONS_REQUEST_CODE = 1024;
    // 开屏广告 code
    private static final int SHOW_SPLASH_AD_REQUEST_CODE = 1025;
    // 广告参数
    ///  广告位ID
    public static final String POS_ID = "posId";
    ///  广告唯一ID
    public static final String AD_ID = "adId";
    public static final String USER_ID = "userId";
    public static final String AD_EVENT = "adEvent";
    public static final String AD_MSG = "adMsg";
    ///  隐私合规配置
    public static final String PRIVACY_CONFIG = "privacyConfig";

    private static volatile PluginAdSetDelegate instance;

    private PluginAdSetDelegate() {
    }

    public static PluginAdSetDelegate getInstance() {
        if (instance == null) {
            synchronized (PluginAdSetDelegate.class) {
                if (instance == null) {
                    instance = new PluginAdSetDelegate();
                }
            }
        }
        return instance;
    }

    public void init(Activity activity, FlutterPlugin.FlutterPluginBinding bind) {
        this.bind = bind;
        this.activity = activity;
        registerViewFactory();
    }

    /**
     * 注册广告被释放监听
     */
    public void registerOnAdReleaseListener(@NonNull OnAdReleaseListener listener) {
        onAdReleaseListenerList.add(listener);
    }

    /**
     * 注销广告释放监听
     */
    public void unregisterOnAdReleaseListener(@NonNull OnAdReleaseListener listener) {
        onAdReleaseListenerList.remove(listener);
    }

    /**
     * 遍历找到指定广告，并释放
     *
     * @param adId 广告ID
     */
    public void loopNotifyOnAdRelease(String adId) {
        Log.d(TAG, "开始释放广告, adId: " + adId);
        for (OnAdReleaseListener listener : onAdReleaseListenerList) {
            listener.onAdRelease(adId);
        }
    }

    public void registerViewFactory() {
        try {
            bannerAdFactory = new AdBannerViewFactory();
            this.bind.getPlatformViewRegistry()
                    .registerViewFactory("flutter_plugin_ad_banner", bannerAdFactory);
            nativeAdFactory = new AdNativeViewFactory();
            this.bind.getPlatformViewRegistry()
                    .registerViewFactory("flutter_plugin_ad_native", nativeAdFactory);
            Log.d(TAG, "注册banner、原生信息流工厂: ");
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    /**
     * flutter调用原生方法
     */
    public void onMethodCall(MethodCall call, Result result) {
        String posId = call.argument(POS_ID);
        String adId = call.argument(AD_ID);
        Log.d(TAG, "flutter调用原生方法：" + call.method);
        switch (call.method) {
            case "getPlatformVersion":
                getPlatformVersion(call, result);
                break;
            case "initAd":
                initAd(call, result);
                break;
            case "checkAndReqPermission":
                checkAndReqPermission(call, result);
                break;
            case "showSplashAd":
                showSplashAd(call, result);
                break;
            case "showInterstitialAd":
                showInterstitialAd(call, result);
                break;
            case "showFullscreenVideoAd":
                showFullscreenVideoAd(call, result);
                break;
            case "startLoadRewardVideoAd":
                startLoadRewardVideo(call, result);
                break;
            case "showRewardVideoAd":
                showRewardVideo(call, result);
                break;
            case "loadBannerAd":
                OSETBannerAdManager.getInstance().loadBannerAd(activity, posId, adId);
                break;
            case "loadNativeAd":
                OSETNativeAdManager.getInstance().loadNativeExpressAd(activity, posId, adId);
                break;
            case "releaseAd":
                // 释放广告
                loopNotifyOnAdRelease(adId);
                result.success(true);
                break;
            case "onToast":
                // Toast 弹窗
                String toastMsg = call.argument("toastMsg");
                Toast.makeText(activity, toastMsg, Toast.LENGTH_SHORT).show();
                break;
            default:
                result.notImplemented();
                break;
        }
    }

    /**
     * 初始化
     * <p>
     * 一定要在用户同意 APP 隐私政策之后调用，第一个参数需要填入 Application，否则无法正常使用 sdk。
     *
     * @param call   MethodCall
     * @param result Result
     */
    public void initAd(MethodCall call, MethodChannel.Result result) {
        String appKey = call.argument("appKey");
        if (TextUtils.isEmpty(appKey)) {
            result.error("-200", "参数错误，appKey 不能为空", new Exception("参数错误，appKey 不能为空"));
            return;
        }
        boolean isDebug = Boolean.TRUE.equals(call.argument("isDebug"));
        String userId = call.argument(USER_ID);
        Map<String, Object> privacyConfig = call.argument(PRIVACY_CONFIG);
        Log.d(TAG, "initAd: " + appKey + ", isDebug: " + isDebug);

        try {
            OSETSDKProtected.install(activity.getApplication());
            OSETSDK sdk = OSETSDK.getInstance()
                    // 隐私合规配置
                    .setCustomController(new OSETCustomControllerImpl(privacyConfig));
            if (!TextUtils.isEmpty(userId)) {
                // 接入方的用户 Id，用于根据用户反馈排查问题，没有可不传
                sdk = sdk.setUserId(userId);
            }
            sdk.init(activity.getApplication(), appKey, new OSETInitListener() {
                @Override
                public void onError(String s) {
                    Log.d(TAG, "初始化失败：" + s);
                }

                @Override
                public void onSuccess() {
                    Log.d(TAG, "初始化成功");
                }
            });
            result.success(true);
        } catch (Exception e) {
            Log.d(TAG, "初始化失败 error:" + e.getMessage());
            result.error("-100", "初始化失败", e);
        }
    }

    /**
     * 隐私合规配置实现
     * <p>
     * Flutter 侧未传入的字段一律回落到 SDK 的默认值（开关默认允许，取值默认取 SDK 自动采集的值），
     * 因此这里全部使用 Java 侧默认值实现，不调用 native 的 super 实现，避免 SDK 尚未加载 so 时报错。
     * <p>
     * 详见 <a href="https://doc.shenshiads.com/Android.html">OpenSet Android SDK 隐私合规配置</a>
     */
    public static class OSETCustomControllerImpl extends OSETCustomController {

        private final Map<String, Object> config;

        public OSETCustomControllerImpl(Map<String, Object> config) {
            this.config = config == null ? new HashMap<String, Object>() : config;
        }

        private boolean booleanValue(String key, boolean defaultValue) {
            Object value = config.get(key);
            if (value instanceof Boolean) return (Boolean) value;
            return defaultValue;
        }

        private String stringValue(String key) {
            Object value = config.get(key);
            return value instanceof String ? (String) value : null;
        }

        private double doubleValue(String key) {
            Object value = config.get(key);
            return value instanceof Number ? ((Number) value).doubleValue() : 0d;
        }

        /// 是否允许 SDK 主动使用地理位置信息
        @Override
        public boolean canReadLocation() {
            return booleanValue("canReadLocation", true);
        }

        /// canReadLocation=false 时，SDK 使用这里传入的地理位置信息
        @Override
        public Location getLocation() {
            if (config.containsKey("latitude") && config.containsKey("longitude")) {
                Location location = new Location(LocationManager.GPS_PROVIDER);
                location.setLatitude(doubleValue("latitude"));
                location.setLongitude(doubleValue("longitude"));
                return location;
            }
            return null;
        }

        /// 是否允许 SDK 主动使用手机硬件参数，如：imei, meid, imsi, iccid
        @Override
        public boolean canUsePhoneState() {
            return booleanValue("canUsePhoneState", true);
        }

        /// canUsePhoneState=false 时，SDK 使用这里传入的 imei（原始值，无需 md5）
        @Override
        public String getImei() {
            return stringValue("imei");
        }

        /// 是否允许 SDK 主动读取 androidId
        @Override
        public boolean canUseAndroidId() {
            return booleanValue("canUseAndroidId", true);
        }

        /// canUseAndroidId=false 时，SDK 使用这里传入的 androidId
        @Override
        public String getAndroidId() {
            return stringValue("androidId");
        }

        /// 是否允许 SDK 主动使用 oaid
        @Override
        public boolean canUseOaid() {
            return booleanValue("canUseOaid", true);
        }

        /// canUseOaid=false 时，SDK 使用这里传入的 oaid（原始值，无需 md5）
        @Override
        public String getOaid() {
            return stringValue("oaid");
        }

        /// 是否允许 SDK 主动使用 ACCESS_NETWORK_STATE 权限
        @Override
        public boolean canUseNetworkState() {
            return booleanValue("canUseNetworkState", true);
        }

        /// 是否允许 SDK 主动使用存储权限
        @Override
        public boolean canUseStoragePermission() {
            return booleanValue("canUseStoragePermission", true);
        }

        /// 是否允许 SDK 主动读取 app 安装列表
        @Override
        public boolean canReadInstalledPackages() {
            return booleanValue("canReadInstalledPackages", true);
        }

        /// canReadInstalledPackages=false 时，SDK 使用这里传入的安装列表
        @Override
        public List<String> getInstalledPackages() {
            Object value = config.get("installedPackages");
            if (value instanceof List) {
                List<String> packages = new ArrayList<>();
                for (Object item : (List<?>) value) {
                    if (item instanceof String) packages.add((String) item);
                }
                return packages;
            }
            return null;
        }

        /// 是否启用个性化广告，默认开启
        @Override
        public boolean canUsePersonalizedAd() {
            return booleanValue("canUsePersonalizedAd", true);
        }

        /// 是否允许 SDK 主动使用传感器
        @Override
        public boolean canUseSensor() {
            return booleanValue("canUseSensor", true);
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
        String posId = call.argument(POS_ID);
        String adId = call.argument(AD_ID);
        if (TextUtils.isEmpty(posId)) {
            result.error("-300", "参数错误，posId 不能为空", new Exception("参数错误，posId 不能为空"));
            return;
        }
        ViewGroup decorView = (ViewGroup) activity.getWindow().getDecorView();
        ViewGroup fl = decorView.findViewById(android.R.id.content);
        FrameLayout frameLayout = new FrameLayout(activity);
        FrameLayout.LayoutParams params = new FrameLayout.LayoutParams(FrameLayout.LayoutParams.MATCH_PARENT, FrameLayout.LayoutParams.MATCH_PARENT);
        frameLayout.setLayoutParams(params);
        fl.addView(frameLayout);
        OSETSplash.getInstance().setContext(activity).setPosId(posId).loadAd(new OSETSplashAdLoadListener() {
            @Override
            public void onLoadSuccess(OSETSplashAd osetSplashAd) {
                postEvent(adId, OSETAdEvent.onAdLoaded);
                osetSplashAd.showAd(activity, frameLayout, new OSETSplashListener() {
                    @Override
                    public void onAdDetailViewClosed() {

                    }

                    @Override
                    public void onClick() {
                        postEvent(adId, OSETAdEvent.onAdClicked);
                    }

                    @Override
                    public void onClose() {
                        postEvent(adId, OSETAdEvent.onAdClosed);
                        fl.removeView(frameLayout);
                        osetSplashAd.destroy();
                    }

                    @Override
                    public void onShow() {
                        postEvent(adId, OSETAdEvent.onAdExposure);
                    }

                    @Override
                    public void onError(String s, String s1) {
                        postEvent(adId, "广告显示错误：" + s + ", " + s1, OSETAdEvent.onAdError);
                        fl.removeView(frameLayout);
                    }
                });
            }

            @Override
            public void onLoadFail(String s, String s1) {
                postEvent(adId, "广告加载失败：" + s + ", " + s1, OSETAdEvent.onAdError);
                fl.removeView(frameLayout);
            }
        });
    }

    public void showInterstitialAd(MethodCall call, MethodChannel.Result result) {
        String posId = call.argument(POS_ID);
        String adId = call.argument(AD_ID);
        if (TextUtils.isEmpty(posId)) {
            result.error("-300", "参数错误，posId 不能为空", new Exception("参数错误，posId 不能为空"));
            return;
        }
        //在首页中OnCreate调用以下代码可以开始加载广告并缓存
        OSETInterstitial.getInstance()
                .setContext(activity)
                .setPosId(posId)
                .loadAd(new OSETInterstitialAdLoadListener() {


                    @Override
                    public void onLoadFail(String s, String s1) {
                        postEvent(adId, "广告加载失败：" + s + ", " + s1, OSETAdEvent.onAdError);
                    }

                    @Override
                    public void onLoadSuccess(OSETInterstitialAd osetInterstitialAd) {
                        postEvent(adId, OSETAdEvent.onAdLoaded);
                        osetInterstitialAd.showAd(activity, new OSETInterstitialListener() {
                            @Override
                            public void onShow() {
                                postEvent(adId, OSETAdEvent.onAdExposure);
                            }

                            @Override
                            public void onError(String s, String s1) {
                                postEvent(adId, "广告显示错误：" + s + ", " + s1, OSETAdEvent.onAdError);
                            }

                            @Override
                            public void onClick() {
                                postEvent(adId, OSETAdEvent.onAdClicked);
                            }

                            @Override
                            public void onClose() {
                                postEvent(adId, OSETAdEvent.onAdClosed);
                            }
                        });
                    }
                });
        result.success(true);
    }

    public void showFullscreenVideoAd(MethodCall call, MethodChannel.Result result) {
        String posId = call.argument(POS_ID);
        String adId = call.argument(AD_ID);
        if (TextUtils.isEmpty(posId)) {
            result.error("-300", "参数错误，posId 不能为空", new Exception("参数错误，posId 不能为空"));
            return;
        }
        //在首页中OnCreate调用以下代码可以开始加载广告并缓存
        OSETFullVideo.getInstance()
                .setContext(activity)
                .setPosId(posId)
                .loadAd(new OSETFullAdLoadListener() {
                    @Override
                    public void onLoadSuccess(OSETFullAd osetFullAd) {
                        postEvent(adId, OSETAdEvent.onAdLoaded);
                        osetFullAd.showAd(activity, new OSETFullVideoListener() {

                            @Override
                            public void onVideoStart() {
                                android.util.Log.d(TAG, "onVideoStart---");
                            }

                            @Override
                            public void onError(String s, String s1) {
                                postEvent(adId, "广告显示错误：" + s + ", " + s1, OSETAdEvent.onAdError);
                            }

                            @Override
                            public void onClick() {
                                postEvent(adId, OSETAdEvent.onAdClicked);
                            }

                            @Override
                            public void onClose() {
                                postEvent(adId, OSETAdEvent.onAdClosed);
                            }

                            @Override
                            public void onShow() {
                                postEvent(adId, OSETAdEvent.onAdExposure);
                            }

                            @Override
                            public void onVideoEnd() {
                                android.util.Log.d(TAG, "onVideoEnd---key:");
                            }

                        });
                    }

                    @Override
                    public void onLoadFail(String s, String s1) {
                        postEvent(adId, "广告加载错误：" + s + ", " + s1, OSETAdEvent.onAdError);
                    }
                });
        result.success(true);
    }

    public void startLoadRewardVideo(MethodCall call, MethodChannel.Result result) {
        String posId = call.argument(POS_ID);
        String adId = call.argument(AD_ID);
        String userId = call.argument(USER_ID);
        if (TextUtils.isEmpty(posId)) {
            result.error("-300", "参数错误，posId 不能为空", new Exception("参数错误，posId 不能为空"));
            return;
        }
        //这一步建议在首页进行初始化并开启缓存,减少第一次展示广告的时间。并且在首页onDestroy里面调用destroy()方法释放资源
        OSETRewardVideo.getInstance()
                .setContext(activity)
                .setPosId(posId)
                .setUserId(userId)
                .startLoad();
        result.success(true);
    }

    public void showRewardVideo(MethodCall call, MethodChannel.Result result) {
        String posId = call.argument(POS_ID);
        String adId = call.argument(AD_ID);
        String userId = call.argument(USER_ID);
        if (TextUtils.isEmpty(posId)) {
            result.error("-300", "参数错误，posId 不能为空", new Exception("参数错误，posId 不能为空"));
            return;
        }
        //这一步建议在首页进行初始化并开启缓存,减少第一次展示广告的时间。并且在首页onDestroy里面调用destroy()方法释放资源
        OSETRewardVideo.getInstance()
                .setContext(activity)
                .setPosId(posId)
                .setUserId(userId)
                .loadAd(new OSETRewardAdLoadListener() {
                    @Override
                    public void onLoadSuccess(OSETRewardAd osetRewardAd) {
                        postEvent(adId, OSETAdEvent.onAdLoaded);
                        osetRewardAd.showAd(activity, new OSETRewardListener() {
                            @Override
                            public void onClick() {
                                postEvent(adId, OSETAdEvent.onAdClicked);
                            }

                            @Override
                            public void onClose() {
                                postEvent(adId, OSETAdEvent.onAdClosed);
                            }

                            @Override
                            public void onReward() {
                                // 获得奖励后回调
                                postEvent(adId, OSETAdEvent.onReward);
                            }

                            @Override
                            public void onServiceResponse(int i) {
                            }

                            @Override
                            public void onShow() {
                                postEvent(adId, OSETAdEvent.onAdExposure);
                            }

                            @Override
                            public void onVideoEnd() {
                            }

                            @Override
                            public void onVideoStart() {
                            }

                            @Override
                            public void onError(String s, String s1) {
                                postEvent(adId, "广告显示错误：" + s + ", " + s1, OSETAdEvent.onAdError);
                            }
                        });
                    }

                    @Override
                    public void onLoadFail(String s, String s1) {
                        postEvent(adId, "广告加载错误：" + s + ", " + s1, OSETAdEvent.onAdError);
                    }
                });
        result.success(true);
    }

    @NonNull
    public AdBannerViewFactory getOSETBannerAdFactory() {
        return bannerAdFactory;
    }

    @NonNull
    public AdNativeViewFactory getOSETNativeAdFactory() {
        return nativeAdFactory;
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

    ///  发送事件
    public void postEvent(String adId, String adEvent) {
        Map<String, Object> map = new HashMap<String, Object>();
        map.put(AD_ID, adId);
        map.put(AD_EVENT, adEvent);
        postEvent(map);
    }

    ///  发送事件
    public void postEvent(String adId, String msg, String adEvent) {
        Map<String, Object> map = new HashMap<String, Object>();
        map.put(AD_ID, adId);
        map.put(AD_MSG, msg);
        map.put(AD_EVENT, adEvent);
        postEvent(map);
    }

    /// 发送事件消息给flutter
    public void postEvent(Map<String, Object> map) {
        if (_eventChannel != null && map != null) {
//            Log.d(TAG, "调用flutter 传参 map:" + map);
            _eventChannel.success(map);
        }
    }

    @Override
    public void onListen(Object arguments, EventChannel.EventSink events) {
        _eventChannel = events;
    }

    @Override
    public void onCancel(Object arguments) {
        _eventChannel = null;
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
