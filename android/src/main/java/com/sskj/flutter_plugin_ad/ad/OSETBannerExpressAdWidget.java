package com.sskj.flutter_plugin_ad.ad;

import android.content.Context;
import android.util.Log;
import android.view.Gravity;
import android.view.View;
import android.view.ViewGroup;
import android.widget.FrameLayout;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import com.sskj.flutter_plugin_ad.PluginAdSetDelegate;
import com.sskj.flutter_plugin_ad.config.OSETAdEvent;
import com.sskj.flutter_plugin_ad.manager.OSETBannerAdManager;

import java.util.HashMap;
import java.util.Map;

import io.flutter.plugin.platform.PlatformView;

/**
 * @author Nnnn
 * @date 2025/8/8
 */
public class OSETBannerExpressAdWidget implements PlatformView {
    private static final String TAG = "adset_plugin";
    private FrameLayout parent;
    private FrameLayout adContainer;

    public OSETBannerExpressAdWidget(@NonNull Context context, String adId, double adWidth) {
        float density = context.getResources().getDisplayMetrics().density;
        int width = adWidth > 0 ? (int) (density * adWidth) : ViewGroup.LayoutParams.MATCH_PARENT;
//        Log.d(TAG, "宽度: " + width + ", density: " + density);

        this.parent = new FrameLayout(context);
        this.parent.setMinimumWidth(width);
        this.parent.setLayoutParams(new ViewGroup.LayoutParams(ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.WRAP_CONTENT));

        OSETBannerExpressAd osetBannerExpressAd = OSETBannerAdManager.getInstance().getOSETBannerExpressAdByAdId(adId);
        if (osetBannerExpressAd != null && osetBannerExpressAd.getBannerAd() != null && osetBannerExpressAd.getBannerAd().isUsable()) {
            View bannerAdView = osetBannerExpressAd.getBannerAdView();
            if (bannerAdView != null) {
                // 手动测量广告View的高度
                int measureHeight = measureAdHeight(context, bannerAdView);

                // 新建广告容器并将广告填入
                adContainer = new FrameLayout(context);
                adContainer.setLayoutParams(new ViewGroup.LayoutParams(width, measureHeight));

                // 加载并渲染信息流模板广告
                if (adContainer.getChildCount() > 0) {
                    ViewGroup.LayoutParams layoutParams = adContainer.getChildAt(0).getLayoutParams();
                    if (layoutParams instanceof FrameLayout.LayoutParams) {
                        ((FrameLayout.LayoutParams) layoutParams).gravity = Gravity.TOP;
                    }
                }

                // 广告填入广告容器中
                adContainer.addView(bannerAdView);

                // 新建广告容器并将广告填入
                this.parent.addView(adContainer);

                // 回调测量后的广告布局高度给flutter容器
                Map<String, Object> extras = new HashMap<>();
                extras.put("adId", adId);
                extras.put("adEvent", OSETAdEvent.onAdMeasured);
                extras.put("adWidth", width / density);
                extras.put("adHeight", measureHeight / density);
                PluginAdSetDelegate.getInstance().postEvent(extras);
            }
        }
    }

    private int measureAdHeight(Context context, View expressAdView) {
        int widthSpec = View.MeasureSpec.makeMeasureSpec(0, View.MeasureSpec.UNSPECIFIED);
        int heightSpec = View.MeasureSpec.makeMeasureSpec(0, View.MeasureSpec.UNSPECIFIED);
        expressAdView.measure(widthSpec, heightSpec);
        int height = expressAdView.getMeasuredHeight();
        if (height == 0) {
            height = ViewGroup.LayoutParams.WRAP_CONTENT;
        }
        Log.d(TAG, "测量高度: " + height);
        return height;
    }


    @Nullable
    @Override
    public View getView() {
        return parent;
    }

    @Override
    public void dispose() {
    }

    public void release() {
        try {
            if (this.parent != null) {
                this.parent.removeAllViews();
            }
        } catch (Throwable e) {
            e.printStackTrace();
        }
    }
}
