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

import com.kc.openset.ad.banner.OSETBanner;
import com.kc.openset.ad.banner.OSETBannerAd;
import com.kc.openset.ad.listener.OSETBannerAdLoadListener;
import com.kc.openset.ad.listener.OSETBannerListener;

import java.util.Map;

import io.flutter.plugin.platform.PlatformView;

/**
 * Banner View
 */
@SuppressWarnings("unchecked")
class AdBannerView implements PlatformView {
    private FrameLayout frameLayout;
    private final PluginAdSetDelegate pluginDelegate;
    private OSETBannerAd mOSETBannerAd;

    public static final String POS_ID = "posId";
    public static final String AD_ID = "adId";


    AdBannerView(@NonNull Context context, int id, @Nullable Map<String, Object> creationParams, PluginAdSetDelegate pluginDelegate) {
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

        loadBannerAd(this.pluginDelegate.activity, posId, adId);
    }

    @NonNull
    @Override
    public View getView() {
        return frameLayout;
    }

    @Override
    public void dispose() {
        if (mOSETBannerAd != null) {
            mOSETBannerAd.destroy();
        }
    }


    public void loadBannerAd(Activity activity, String posId, String adId) {
        OSETBanner.getInstance()
                .setContext(activity)
                .setPosId(posId)
                .loadAd(new OSETBannerAdLoadListener() {
                    @Override
                    public void onLoadSuccess(OSETBannerAd osetBannerAd) {
                        mOSETBannerAd = osetBannerAd;
                        osetBannerAd.render(activity, new OSETBannerListener() {
                            @Override
                            public void onClick(View view) {
                                pluginDelegate.postEvent(adId, AdEventChannel.onAdClicked);
                            }

                            @Override
                            public void onClose(View view) {
                                if (frameLayout != null) {
                                    frameLayout.removeAllViews();
                                }
                                pluginDelegate.postEvent(adId, AdEventChannel.onAdClosed);
                            }

                            @Override
                            public void onRenderSuccess(View view) {
                                if (frameLayout != null) {
                                    frameLayout.addView(view);
                                }
                            }

                            @Override
                            public void onShow(View view) {
                                pluginDelegate.postEvent(adId, AdEventChannel.onAdExposure);
                            }

                            @Override
                            public void onError(String s, String s1) {
                                pluginDelegate.postEvent(adId, "渲染banner广告失败：" + s + ", " + s1, AdEventChannel.onAdError);
                            }
                        });
                    }

                    @Override
                    public void onLoadFail(String s, String s1) {
                        pluginDelegate.postEvent(adId, "加载banner广告失败：" + s + ", " + s1, AdEventChannel.onAdError);
                    }
                });
    }
}