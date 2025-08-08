package com.sskj.flutter_plugin_ad.factory;

import android.content.Context;
import android.text.TextUtils;
import android.util.Log;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import com.sskj.flutter_plugin_ad.ad.OSETBannerExpressAdWidget;

import java.util.HashMap;
import java.util.Map;

import io.flutter.plugin.common.StandardMessageCodec;
import io.flutter.plugin.platform.PlatformView;
import io.flutter.plugin.platform.PlatformViewFactory;

/**
 * Banner View 工厂
 */
@SuppressWarnings("unchecked")
public class AdBannerViewFactory extends PlatformViewFactory {
    private static final String TAG = "adset_plugin";
    private final Map<String, OSETBannerExpressAdWidget> adMap = new HashMap<>();

    public AdBannerViewFactory() {
        super(StandardMessageCodec.INSTANCE);
    }

    @NonNull
    @Override
    public PlatformView create(@NonNull Context context, int id, @Nullable Object args) {
        Log.d(TAG, "创建工厂: " + args);
        String adId = "";
        double adWidth = 0;
        try {
            if (args != null) {
                adId = (String) ((Map<String, Object>) args).get("adId");
                adWidth = (double) ((Map<String, Object>) args).get("adWidth");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        if (TextUtils.isEmpty(adId)) {
            return null;
        }
        OSETBannerExpressAdWidget platformView = adMap.get(adId);
        if (platformView != null) {
            return platformView;
        }

        OSETBannerExpressAdWidget adWidget = new OSETBannerExpressAdWidget(context, adId, adWidth);
        adMap.put(adId, adWidget);
        return adWidget;
    }

    public void release(String adId) {
        OSETBannerExpressAdWidget platformView = adMap.get(adId);

        if (platformView != null) {
            platformView.release();
            adMap.remove(adId);
        }
    }
}