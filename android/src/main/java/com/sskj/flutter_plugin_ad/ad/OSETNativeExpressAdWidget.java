package com.sskj.flutter_plugin_ad.ad;

import android.content.Context;
import android.util.Log;
import android.view.Gravity;
import android.view.View;
import android.view.ViewGroup;
import android.view.ViewTreeObserver;
import android.widget.FrameLayout;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import com.sskj.flutter_plugin_ad.manager.OSETNativeAdManager;
import com.sskj.flutter_plugin_ad.PluginAdSetDelegate;
import com.sskj.flutter_plugin_ad.config.OSETAdEvent;

import java.util.HashMap;
import java.util.Map;

import io.flutter.plugin.platform.PlatformView;

/**
 * @author Nnnn
 * @date 2025/8/7
 */
public class OSETNativeExpressAdWidget implements PlatformView {
    private static final String TAG = "adset_plugin";
    private FrameLayout parent;
    private CstOnGlobalLayoutListener onGlobalLayoutListener;

    public OSETNativeExpressAdWidget(@NonNull Context context, String adId, double adWidth) {
        float density = context.getResources().getDisplayMetrics().density;
        int width = adWidth > 0 ? (int) (density * adWidth) : ViewGroup.LayoutParams.MATCH_PARENT;
        Log.d(TAG, "宽度: " + width + ", density: " + density);

        this.parent = new FrameLayout(context);
        this.parent.setMinimumWidth(width);
        this.parent.setLayoutParams(new ViewGroup.LayoutParams(ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.WRAP_CONTENT));

        OSETNativeExpressAd osetNativeExpressAd = OSETNativeAdManager.getInstance().getOSETNativeExpressAdByAdId(adId);
        if (osetNativeExpressAd != null && osetNativeExpressAd.getNativeAd() != null && osetNativeExpressAd.getNativeAd().isUsable()) {
            Log.d(TAG, "a1");
            View nativeExpressAdView = osetNativeExpressAd.getExpressAdView();
            if (nativeExpressAdView != null) {
                Log.d(TAG, "a2");
                // 将广告容器放到FlutterView中
                this.parent.addView(nativeExpressAdView);

                // 监听广告布局变化，通知Flutter端改变parent的大小（Flutter端默认是无限高度，所以需要计算广告高度之后让Flutter端设置确切的高度）
                ViewTreeObserver viewTreeObserver = nativeExpressAdView.getViewTreeObserver();
                if (viewTreeObserver != null) {
                    Log.d(TAG, "a3");
                    onGlobalLayoutListener = new CstOnGlobalLayoutListener(adId, nativeExpressAdView);
                    viewTreeObserver.addOnGlobalLayoutListener(onGlobalLayoutListener);
                }
            }
        }
        Log.d(TAG, "a4");
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
        private View nativeExpressAdView;
        private int preWidth = -1;
        private int preHeight = -1;

        public CstOnGlobalLayoutListener(String adId, @NonNull View nativeExpressAdView) {
            this.adId = adId;
            this.nativeExpressAdView = nativeExpressAdView;
        }

        @Override
        public void onGlobalLayout() {
            Log.d(TAG, "a5");
            if (nativeExpressAdView == null) return;
            int width = nativeExpressAdView.getMeasuredWidth();
            int height = nativeExpressAdView.getMeasuredHeight();

            Log.d(TAG, "a6 广告测量高度：" + width + ", " + height);
            if (width > 0 && height > 0) {
                if (width > preWidth || height > preHeight) {
                    float density = nativeExpressAdView.getResources().getDisplayMetrics().density;
//                    if (height / density < 48) return;
//                    int expectedHeight = (int) (width * (9.0 / 16.0));
//                    if (height > expectedHeight) {
//                        height = expectedHeight;
//                    }
                    Log.d(TAG, "a7: " + width + ", " + height);

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
            if (nativeExpressAdView != null) {
                ViewTreeObserver viewTreeObserver = nativeExpressAdView.getViewTreeObserver();
                if (viewTreeObserver != null) {
                    viewTreeObserver.removeOnGlobalLayoutListener(this);
                }
                nativeExpressAdView = null;
            }
        }
    }
}
