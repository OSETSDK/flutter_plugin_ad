package com.sskj.flutter_plugin_ad;

import android.app.Activity;
import android.content.Context;
import android.graphics.Color;
import android.text.TextUtils;
import android.view.View;
import android.view.ViewGroup;
import android.widget.FrameLayout;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import com.kc.openset.ad._native.OSETNative;
import com.kc.openset.ad._native.OSETNativeAd;
import com.kc.openset.ad.listener.OSETNativeAdLoadListener;
import com.kc.openset.ad.listener.OSETNativeListener;

import java.util.Map;

import io.flutter.plugin.platform.PlatformView;

/**
 * @author Nnnn
 * @date 2025/4/16
 */
public class AdNativeView implements PlatformView {
    public static final String POS_ID = "posId";
    public static final String AD_ID = "adId";
    private PluginAdSetDelegate pluginDelegate;
    private FrameLayout frameLayout;
    private OSETNativeAd mOsetNativeAd;

    public AdNativeView(@NonNull Context context, int id, @Nullable Map<String, Object> creationParams, PluginAdSetDelegate pluginDelegate) {
        this.pluginDelegate = pluginDelegate;
        if (creationParams == null) {
            return;
        }
        String posId = (String) creationParams.get(POS_ID);
        String adId = (String) creationParams.get(AD_ID);
        if (TextUtils.isEmpty(posId)) {
            this.pluginDelegate.postEvent(adId, "参数错误，posId 不能为空", AdEventChannel.onAdError);
            return;
        }
        frameLayout = new FrameLayout(context);
        FrameLayout.LayoutParams params = new FrameLayout.LayoutParams(ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.WRAP_CONTENT);
        frameLayout.setLayoutParams(params);
        frameLayout.setBackgroundColor(Color.TRANSPARENT);

        loadNativeAd(this.pluginDelegate.activity, posId, adId);
    }

    private void sendEvent(String adId, String eventType, String msg) {
        if (AdNativeView.this.pluginDelegate != null) {
            AdNativeView.this.pluginDelegate.postEvent(adId, msg, eventType);
        }
    }

    private void loadNativeAd(Activity activity, String posId, String adId) {
        OSETNative.getInstance()
                .setContext(activity)
                .setPosId(posId)
//                .setUserId(userId)
                .loadAd(new OSETNativeAdLoadListener() {

                    @Override
                    public void onLoadFail(String s, String s1) {
                        sendEvent(adId, AdEventChannel.onAdError, "信息流广告加载失败：" + s + ", " + s1);
                    }

                    @Override
                    public void onLoadSuccess(OSETNativeAd osetNativeAd) {
                        mOsetNativeAd = osetNativeAd;
                        sendEvent(adId, AdEventChannel.onAdLoaded, "");
                        if (osetNativeAd != null) {
                            osetNativeAd.render(activity, new OSETNativeListener() {

                                @Override
                                public void onClick(View view) {
                                    sendEvent(adId, AdEventChannel.onAdClicked, "");
                                }

                                @Override
                                public void onClose(View view) {
                                    sendEvent(adId, AdEventChannel.onAdClosed, "");
                                }

                                @Override
                                public void onRenderSuccess(View view) {
                                    if (frameLayout != null) {
                                        frameLayout.addView(view);
                                        ViewGroup.LayoutParams params = frameLayout.getLayoutParams();
                                        params.height = view.getMeasuredHeight();
                                        frameLayout.setLayoutParams(params);
                                    }
                                }

                                @Override
                                public void onShow(View view) {
                                    sendEvent(adId, AdEventChannel.onAdExposure, "");
                                }

                                @Override
                                public void onError(String s, String s1) {
                                    sendEvent(adId, AdEventChannel.onAdError, "信息流广告渲染失败：" + s + ", " + s1);
                                }
                            });
                        }
                    }
                });

    }

    @Nullable
    @Override
    public View getView() {
        return frameLayout;
    }

    @Override
    public void dispose() {
        frameLayout = null;
        if (mOsetNativeAd != null) {
            mOsetNativeAd.destroy();
        }
    }
}
