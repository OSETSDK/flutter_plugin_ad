package com.sskj.flutter_plugin_ad.manager;

import android.app.Activity;
import android.util.Log;

import com.sskj.flutter_plugin_ad.PluginAdSetDelegate;
import com.sskj.flutter_plugin_ad.ad.OSETNativeExpressAd;
import com.sskj.flutter_plugin_ad.config.OSETAdEvent;
import com.sskj.flutter_plugin_ad.factory.AdNativeViewFactory;
import com.sskj.flutter_plugin_ad.listener.OnAdReleaseListener;

import java.util.HashMap;
import java.util.Map;

/**
 * 模版信息摸广告管理器
 */
public class OSETNativeAdManager implements OnAdReleaseListener {
    private static final String TAG = "adset_plugin";
    private static volatile OSETNativeAdManager instance;
    private final Map<String, OSETNativeExpressAd> nativeExpressAdMap = new HashMap<>();

    private OSETNativeAdManager() {
        // 私有构造函数
        PluginAdSetDelegate.getInstance().registerOnAdReleaseListener(this);
    }

    public static OSETNativeAdManager getInstance() {
        if (instance == null) {
            synchronized (OSETNativeAdManager.class) {
                if (instance == null) {
                    instance = new OSETNativeAdManager();
                }
            }
        }
        return instance;
    }

    @Override
    public void onAdRelease(String adId) {
        release(adId);
    }

    public void loadNativeExpressAd(Activity activity, String posId, String adId) {
        Log.d(TAG, "信息流广告加载预备, posId: " + posId + ", adId=" + adId);
        if (activity == null || activity.isFinishing()) {
            Log.d(TAG, "信息流广告加载失败, posId: " + posId + ", error: 当前上下文不适合获取信息流广告!");
            PluginAdSetDelegate.getInstance().postEvent(adId, "当前上下文不适合获取信息流广告", OSETAdEvent.onAdError);
            return;
        }

        OSETNativeExpressAd osetNativeExpressAd = new OSETNativeExpressAd(posId, adId, activity);
        nativeExpressAdMap.put(adId, osetNativeExpressAd);
        osetNativeExpressAd.loadAd();
    }

    public OSETNativeExpressAd getOSETNativeExpressAdByAdId(String adId) {
        return adId == null ? null : nativeExpressAdMap.get(adId);
    }

    /**
     * 释放广告
     */
    private void release(String adId) {
        if (adId == null) return;
        try {
            OSETNativeExpressAd osetNativeExpressAd = nativeExpressAdMap.get(adId);
            if (osetNativeExpressAd != null) {
                osetNativeExpressAd.release();
                nativeExpressAdMap.remove(adId);
            }

            AdNativeViewFactory factory = PluginAdSetDelegate.getInstance().getOSETNativeAdFactory();
            if (factory != null) factory.release(adId);
        } catch (Throwable e) {
            e.printStackTrace();
        }
    }
}
