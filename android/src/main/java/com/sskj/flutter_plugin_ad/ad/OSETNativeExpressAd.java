package com.sskj.flutter_plugin_ad.ad;

import android.app.Activity;
import android.util.Log;
import android.view.View;

import com.kc.openset.ad._native.OSETNative;
import com.kc.openset.ad._native.OSETNativeAd;
import com.kc.openset.ad.listener.OSETNativeAdLoadListener;
import com.kc.openset.ad.listener.OSETNativeListener;
import com.sskj.flutter_plugin_ad.config.OSETAdEvent;
import com.sskj.flutter_plugin_ad.PluginAdSetDelegate;

/**
 * @author Nnnn
 * @date 2025/8/7
 */
public class OSETNativeExpressAd implements OSETNativeListener {
    private final String posId;
    private final String adId;
    private final Activity activity;
    private OSETNativeAd osetNativeAd;
    private View expressAdView;

    public OSETNativeExpressAd(String posId, String adId, Activity activity) {
        this.posId = posId;
        this.adId = adId;
        this.activity = activity;
    }

    public void loadAd() {
        OSETNative.getInstance().setContext(activity).setPosId(posId).loadAd(new OSETNativeAdLoadListener() {
            @Override
            public void onLoadSuccess(OSETNativeAd osetNativeAd) {
                OSETNativeExpressAd.this.osetNativeAd = osetNativeAd;
                postEvent(adId, "", OSETAdEvent.onAdLoaded);
                osetNativeAd.render(activity, OSETNativeExpressAd.this);
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
        PluginAdSetDelegate.getInstance().loopNotifyOnAdRelease(adId);
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

    public OSETNativeAd getNativeAd() {
        return osetNativeAd;
    }

    public View getExpressAdView() {
        return expressAdView;
    }

    /**
     * 释放广告
     */
    public void release() {
        try {
            if (osetNativeAd != null) {
                osetNativeAd.destroy();
                osetNativeAd = null;
            }
            Log.d("adset_plugin", "广告被释放, adId: " + adId);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
