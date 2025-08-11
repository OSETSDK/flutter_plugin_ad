package com.sskj.flutter_plugin_ad.manager;

import android.app.Activity;
import android.util.Log;

import com.sskj.flutter_plugin_ad.PluginAdSetDelegate;
import com.sskj.flutter_plugin_ad.ad.OSETBannerExpressAd;
import com.sskj.flutter_plugin_ad.config.OSETAdEvent;
import com.sskj.flutter_plugin_ad.factory.AdBannerViewFactory;
import com.sskj.flutter_plugin_ad.listener.OnAdReleaseListener;

import java.util.HashMap;
import java.util.Map;

/**
 * Banner广告管理器
 */
public class OSETBannerAdManager implements OnAdReleaseListener {
    private static final String TAG = "adset_plugin";
    private static volatile OSETBannerAdManager instance;
    private final Map<String, OSETBannerExpressAd> bannerExpressAdMap = new HashMap<>();

    private OSETBannerAdManager() {
        // 私有构造函数
        PluginAdSetDelegate.getInstance().registerOnAdReleaseListener(this);
    }

    public static OSETBannerAdManager getInstance() {
        if (instance == null) {
            synchronized (OSETBannerAdManager.class) {
                if (instance == null) {
                    instance = new OSETBannerAdManager();
                }
            }
        }
        return instance;
    }

    @Override
    public void onAdRelease(String adId) {
        release(adId);
    }

    public void loadBannerAd(Activity activity, String posId, String adId) {
//        Log.d(TAG, "Banner广告加载预备, posId: " + posId + ", adId=" + adId);
        if (activity == null || activity.isFinishing()) {
            Log.d(TAG, "Banner广告加载失败, posId: " + posId + ", error: 当前上下文不适合获取信息流广告!");
            PluginAdSetDelegate.getInstance().postEvent(adId, "当前上下文不适合获取信息流广告", OSETAdEvent.onAdError);
            return;
        }

        OSETBannerExpressAd osetBannerExpressAd = new OSETBannerExpressAd(posId, adId, activity);
        bannerExpressAdMap.put(adId, osetBannerExpressAd);
        osetBannerExpressAd.loadAd();
    }

    public OSETBannerExpressAd getOSETBannerExpressAdByAdId(String adId) {
        return adId == null ? null : bannerExpressAdMap.get(adId);
    }

    /**
     * 释放广告
     */
    private void release(String adId) {
        if (adId == null) return;
        try {
            OSETBannerExpressAd osetBannerExpressAd = bannerExpressAdMap.get(adId);
            if (osetBannerExpressAd != null) {
                osetBannerExpressAd.release();
                bannerExpressAdMap.remove(adId);
            }

            AdBannerViewFactory factory = PluginAdSetDelegate.getInstance().getOSETBannerAdFactory();
            if (factory != null) factory.release(adId);
        } catch (Throwable e) {
            e.printStackTrace();
        }
    }
}
