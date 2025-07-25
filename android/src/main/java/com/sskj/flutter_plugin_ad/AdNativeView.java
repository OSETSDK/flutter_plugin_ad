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
import com.sskj.flutter_plugin_ad.entity.AdEvent;
import com.sskj.flutter_plugin_ad.entity.AdType;
import com.sskj.flutter_plugin_ad.entity.EventType;

import java.util.Map;

import io.flutter.plugin.platform.PlatformView;

/**
 * @author Nnnn
 * @date 2025/4/16
 */
public class AdNativeView implements PlatformView {
    public static final String AD_ID = "adId";
    private PluginAdSetDelegate pluginDelegate;
    private FrameLayout frameLayout;
    private OSETNativeAd mOsetNativeAd;

    public AdNativeView(@NonNull Context context, int id, @Nullable Map<String, Object> creationParams, PluginAdSetDelegate pluginDelegate) {
        this.pluginDelegate = pluginDelegate;
        String posId = (String) creationParams.get(AD_ID);
        if (TextUtils.isEmpty(posId)) {
            this.pluginDelegate.addEvent(new AdEvent(EventType.onAdError, "参数错误，posId 不能为空"));
            return;
        }
        frameLayout = new FrameLayout(context);
        FrameLayout.LayoutParams params = new FrameLayout.LayoutParams(ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.WRAP_CONTENT);
        frameLayout.setLayoutParams(params);
        frameLayout.setBackgroundColor(Color.TRANSPARENT);

        loadNativeAd(this.pluginDelegate.activity, posId);
    }

    private void sendEvent(String eventType, String msg) {
        if (AdNativeView.this.pluginDelegate != null) {
            AdNativeView.this.pluginDelegate.addEvent(new AdEvent(eventType, msg, AdType.NATIVE));
        }
    }

    private void loadNativeAd(Activity activity, String posId) {
        OSETNative.getInstance()
                .setContext(activity)
                .setPosId(posId)
//                .setUserId(userId)
                .loadAd(new OSETNativeAdLoadListener() {

                    @Override
                    public void onLoadFail(String s, String s1) {
                        sendEvent(EventType.onAdError, "信息流广告加载失败：" + s + ", " + s1);
                    }

                    @Override
                    public void onLoadSuccess(OSETNativeAd osetNativeAd) {
                        mOsetNativeAd = osetNativeAd;
                        sendEvent(EventType.onAdLoaded, "");
                        if (osetNativeAd != null) {
                            osetNativeAd.render(activity, new OSETNativeListener() {

                                @Override
                                public void onClick(View view) {
                                    sendEvent(EventType.onAdClicked, "");
                                }

                                @Override
                                public void onClose(View view) {
                                    sendEvent(EventType.onAdClosed, "");
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
                                    sendEvent(EventType.onAdExposure, "");
                                }

                                @Override
                                public void onError(String s, String s1) {
                                    sendEvent(EventType.onAdError, "信息流广告渲染失败：" + s + ", " + s1);
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
