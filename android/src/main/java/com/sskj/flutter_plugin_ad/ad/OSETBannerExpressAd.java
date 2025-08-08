package com.sskj.flutter_plugin_ad.ad;

import android.app.Activity;
import android.util.Log;
import android.view.View;

import com.kc.openset.ad.banner.OSETBanner;
import com.kc.openset.ad.banner.OSETBannerAd;
import com.kc.openset.ad.listener.OSETBannerAdLoadListener;
import com.kc.openset.ad.listener.OSETBannerListener;
import com.sskj.flutter_plugin_ad.PluginAdSetDelegate;
import com.sskj.flutter_plugin_ad.config.OSETAdEvent;

/**
 * @author Nnnn
 * @date 2025/8/8
 */
public class OSETBannerExpressAd implements OSETBannerListener {
    private final String posId;
    private final String adId;
    private final Activity activity;
    private OSETBannerAd osetBannerAd;
    private View expressAdView;

    public OSETBannerExpressAd(String posId, String adId, Activity activity) {
        this.posId = posId;
        this.adId = adId;
        this.activity = activity;
    }

    public void loadAd() {
        OSETBanner.getInstance().setContext(activity).setPosId(posId).loadAd(new OSETBannerAdLoadListener() {
            @Override
            public void onLoadSuccess(OSETBannerAd osetBannerAd) {
                OSETBannerExpressAd.this.osetBannerAd = osetBannerAd;
                postEvent(adId, "", OSETAdEvent.onAdLoaded);
                osetBannerAd.render(activity, OSETBannerExpressAd.this);
            }

            @Override
            public void onLoadFail(String s, String s1) {
                postEvent(adId, "广告加载失败：" + s + ", s1：" + s1, OSETAdEvent.onAdError);
                release();
            }
        });
    }

    @Override
    public void onClick(View view) {
        postEvent(adId, "", OSETAdEvent.onAdClicked);
    }

    @Override
    public void onClose(View view) {
        postEvent(adId, "", OSETAdEvent.onAdClosed);
        release();
    }

    @Override
    public void onRenderSuccess(View view) {
        this.expressAdView = view;
    }

    @Override
    public void onShow(View view) {
        postEvent(adId, "", OSETAdEvent.onAdExposure);
    }

    @Override
    public void onError(String s, String s1) {
        postEvent(adId, "广告渲染失败：" + s + ", s1：" + s1, OSETAdEvent.onAdError);
    }

    /**
     * 发送事件到flutter
     */
    private void postEvent(String adId, String msg, String event) {
        PluginAdSetDelegate.getInstance().postEvent(adId, msg, event);
    }

    public String getAdId() {
        return adId;
    }

    public OSETBannerAd getBannerAd() {
        return osetBannerAd;
    }

    public View getBannerAdView() {
        return expressAdView;
    }

    /**
     * 释放广告
     */
    public void release() {
        try {
            if (osetBannerAd != null) {
                osetBannerAd.destroy();
                osetBannerAd = null;
            }
            Log.d("adset_plugin", "广告被释放, adId: " + adId);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
