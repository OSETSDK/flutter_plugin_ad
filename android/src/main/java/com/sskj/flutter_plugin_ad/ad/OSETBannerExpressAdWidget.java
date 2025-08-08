package com.sskj.flutter_plugin_ad.ad;

import android.content.Context;
import android.util.Log;
import android.view.View;
import android.view.ViewGroup;
import android.view.ViewTreeObserver;
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
    private CstOnGlobalLayoutListener onGlobalLayoutListener;

    public OSETBannerExpressAdWidget(@NonNull Context context, String adId, double adWidth) {
        float density = context.getResources().getDisplayMetrics().density;
        int width = adWidth > 0 ? (int) (density * adWidth) : ViewGroup.LayoutParams.MATCH_PARENT;
        Log.d(TAG, "宽度: " + width + ", density: " + density);

        this.parent = new FrameLayout(context);
        this.parent.setMinimumWidth(width);
        this.parent.setLayoutParams(new ViewGroup.LayoutParams(ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.WRAP_CONTENT));

        OSETBannerExpressAd osetBannerExpressAd = OSETBannerAdManager.getInstance().getOSETBannerExpressAdByAdId(adId);
        if (osetBannerExpressAd != null && osetBannerExpressAd.getBannerAd() != null && osetBannerExpressAd.getBannerAd().isUsable()) {
            View bannerAdView = osetBannerExpressAd.getBannerAdView();
            if (bannerAdView != null) {
                // 新建广告容器并将广告填入
                this.parent.addView(bannerAdView);

                // 监听广告布局变化，通知Flutter端改变parent的大小（Flutter端默认是无限高度，所以需要计算广告高度之后让Flutter端设置确切的高度）
                ViewTreeObserver viewTreeObserver = bannerAdView.getViewTreeObserver();
                if (viewTreeObserver != null) {
                    onGlobalLayoutListener = new CstOnGlobalLayoutListener(adId, bannerAdView);
                    viewTreeObserver.addOnGlobalLayoutListener(onGlobalLayoutListener);
                }
            }
        }
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
            if (this.onGlobalLayoutListener != null) {
                this.onGlobalLayoutListener.release();
                this.onGlobalLayoutListener = null;
            }

            if (this.parent != null) {
                this.parent.removeAllViews();
            }
        } catch (Throwable e) {
            e.printStackTrace();
        }
    }

    public static class CstOnGlobalLayoutListener implements ViewTreeObserver.OnGlobalLayoutListener {
        private final String adId;
        private View bannerAdView;
        private int preWidth = -1;
        private int preHeight = -1;

        public CstOnGlobalLayoutListener(String adId, @NonNull View bannerAdView) {
            this.adId = adId;
            this.bannerAdView = bannerAdView;
        }

        @Override
        public void onGlobalLayout() {
            if (bannerAdView == null) return;
            int width = bannerAdView.getMeasuredWidth();
            int height = bannerAdView.getMeasuredHeight();

            if (width > 0 && height > 0) {
                if (width > preWidth || height > preHeight) {
                    float density = bannerAdView.getResources().getDisplayMetrics().density;
                    if (height / density < 48) return;
//                    int expectedHeight = (int) (width * (9.0 / 16.0));
//                    if (height > expectedHeight) {
//                        height = expectedHeight;
//                    }
                    Log.d(TAG, "onGlobalLayout: " + width + ", " + height);

                    Map<String, Object> extras = new HashMap<>();
                    extras.put("adId", adId);
                    extras.put("adEvent", OSETAdEvent.onAdMeasured);
                    extras.put("adWidth", width / density);
                    extras.put("adHeight", height / density);
                    PluginAdSetDelegate.getInstance().postEvent(extras);

                    preWidth = width;
                    preHeight = height;
                }
            }
        }

        public void release() {
            Log.d(TAG, "释放资源: ");
            if (bannerAdView != null) {
                ViewTreeObserver viewTreeObserver = bannerAdView.getViewTreeObserver();
                if (viewTreeObserver != null) {
                    viewTreeObserver.removeOnGlobalLayoutListener(this);
                }
                bannerAdView = null;
            }
        }
    }
}
