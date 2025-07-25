package com.sskj.flutter_plugin_ad;

import android.app.Activity;
import android.os.Bundle;
import android.util.Log;
import android.widget.FrameLayout;

import androidx.fragment.app.FragmentActivity;

import com.kc.openset.ad.listener.OSETSplashAdLoadListener;
import com.kc.openset.ad.listener.OSETSplashListener;
import com.kc.openset.ad.splash.OSETSplash;
import com.kc.openset.ad.splash.OSETSplashAd;
import com.sskj.flutter_plugin_ad.entity.AdEvent;
import com.sskj.flutter_plugin_ad.entity.AdType;
import com.sskj.flutter_plugin_ad.entity.EventType;

public class AdSplashActivity extends FragmentActivity {

    private static final String TAG = "ADSET";

    private FrameLayout fl;
    private Activity activity;

    public static final String AD_ID = "adId";

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_adsplash);

        activity = this;

        // 解析广告 id
        String adId = getIntent().getStringExtra(AD_ID);

        fl = findViewById(R.id.fl);
        OSETSplash.getInstance().setContext(this).setPosId(adId).loadAd(new OSETSplashAdLoadListener() {
            @Override
            public void onLoadSuccess(OSETSplashAd osetSplashAd) {
                osetSplashAd.showAd(AdSplashActivity.this, fl, new OSETSplashListener() {
                    @Override
                    public void onAdDetailViewClosed() {

                    }

                    @Override
                    public void onClick() {
                        Log.e(TAG, "onClick");
                        PluginAdSetDelegate.getInstance().addEvent(new AdEvent(EventType.onAdClicked, "", AdType.SPLASH));
                    }

                    @Override
                    public void onClose() {
                        Log.e(TAG, "onclose ");
                        PluginAdSetDelegate.getInstance().addEvent(new AdEvent(EventType.onAdClosed, "", AdType.SPLASH));
                        finish();
                    }

                    @Override
                    public void onShow() {
                        Log.e(TAG, "onShow ");
                        PluginAdSetDelegate.getInstance().addEvent(new AdEvent(EventType.onAdExposure, "", AdType.SPLASH));
                    }

                    @Override
                    public void onError(String s, String s1) {
                        Log.e(TAG, "onError——————code:" + s + "----message:" + s1);
                        PluginAdSetDelegate.getInstance().addEvent(new AdEvent(EventType.onAdClosed, "", AdType.SPLASH));
                        finish();
                    }
                });

            }

            @Override
            public void onLoadFail(String s, String s1) {
                Log.e(TAG, "code:" + s + "----message:" + s1);
//                Toast.makeText(activity, "onError", Toast.LENGTH_SHORT).show();
                PluginAdSetDelegate.getInstance().addEvent(new AdEvent(EventType.onAdError, "", AdType.SPLASH));
                finish();
            }
        });
    }

    @Override
    protected void onResume() {
        super.onResume();
        Log.e(TAG, "onResume");
    }

    @Override
    protected void onPause() {
        super.onPause();
        Log.e(TAG, "onPause");
    }
}