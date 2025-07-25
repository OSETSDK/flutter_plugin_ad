package com.sskj.flutter_plugin_ad;

import android.app.Activity;
import android.content.Context;
import android.graphics.Color;
import android.text.TextUtils;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.FrameLayout;
import android.widget.Toast;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import com.kc.openset.ad.banner.OSETBanner;
import com.kc.openset.ad.banner.OSETBannerAd;
import com.kc.openset.ad.listener.OSETBannerAdLoadListener;
import com.kc.openset.ad.listener.OSETBannerListener;
import com.sskj.flutter_plugin_ad.entity.AdEvent;
import com.sskj.flutter_plugin_ad.entity.AdType;
import com.sskj.flutter_plugin_ad.entity.EventType;

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

    public static final String AD_ID = "adId";


    AdBannerView(@NonNull Context context, int id, @Nullable Map<String, Object> creationParams, PluginAdSetDelegate pluginDelegate) {
        this.pluginDelegate = pluginDelegate;
        String posId = (String) creationParams.get(AD_ID);
        if(TextUtils.isEmpty(posId)){
            this.pluginDelegate.addEvent(new AdEvent(EventType.onAdError,"参数错误，posId 不能为空"));
            return;
        }
        frameLayout = new FrameLayout(context);
        FrameLayout.LayoutParams params = new FrameLayout.LayoutParams(ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.WRAP_CONTENT);
        frameLayout.setLayoutParams(params);
        frameLayout.setBackgroundColor(Color.TRANSPARENT);

        loadBannerAd(this.pluginDelegate.activity,posId);
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


    public void loadBannerAd(Activity activity,String adId) {
        OSETBanner.getInstance()
                .setContext(activity)
                .setPosId(adId)
                .loadAd(new OSETBannerAdLoadListener() {
                    @Override
                    public void onLoadSuccess(OSETBannerAd osetBannerAd) {
                        mOSETBannerAd = osetBannerAd;
                        osetBannerAd.render(activity, new OSETBannerListener() {
                            @Override
                            public void onClick(View view) {
                                pluginDelegate.addEvent(new AdEvent(EventType.onAdClicked,"", AdType.BANNER));
                            }

                            @Override
                            public void onClose(View view) {
                                if (frameLayout != null) {
                                    frameLayout.removeAllViews();
                                }
                                pluginDelegate.addEvent(new AdEvent(EventType.onAdClosed,"", AdType.BANNER));
                            }

                            @Override
                            public void onRenderSuccess(View view) {
                                if (frameLayout != null) {
                                    frameLayout.addView(view);
                                }
                            }

                            @Override
                            public void onShow(View view) {
                                pluginDelegate.addEvent(new AdEvent(EventType.onAdExposure, "", AdType.BANNER));
                            }

                            @Override
                            public void onError(String s, String s1) {
                                pluginDelegate.addEvent(new AdEvent(EventType.onAdError, "渲染banner广告失败：" + s +", " + s1, AdType.BANNER));
                            }
                        });
                    }

                    @Override
                    public void onLoadFail(String s, String s1) {
                        pluginDelegate.addEvent(new AdEvent(EventType.onAdError, "加载banner广告失败：" + s +", " + s1, AdType.BANNER));
                    }
                });
    }
}