package com.sskj.flutter_plugin_ad;

import android.os.Bundle;
import android.util.Log;
import android.view.KeyEvent;
import android.view.MenuItem;

import androidx.annotation.NonNull;
import androidx.fragment.app.FragmentActivity;

import com.google.android.material.bottomnavigation.BottomNavigationView;
import com.google.android.material.bottomnavigation.LabelVisibilityMode;
import com.kc.openset.video.OSETVideoContent;
import com.kc.openset.video.OSETVideoContentListener;
import com.kc.openset.video.VideoContentResult;
import com.sskj.flutter_plugin_ad.callback.ClickItem;

public class KsAdActivity extends FragmentActivity implements BottomNavigationView.OnNavigationItemSelectedListener {

    private static final String TAG = "ADSET";

    private static ClickItem mClickItem;

    private String adId;

    public static final String AD_ID = "adId";

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_adks);

        // 解析广告 id
        adId = getIntent().getStringExtra(AD_ID);

        BottomNavigationView navigation = findViewById(R.id.navigation);
        BottomNavigationView bottomNavigationView = findViewById(R.id.navigation);
        navigation.setOnNavigationItemSelectedListener(this);
        bottomNavigationView.setLabelVisibilityMode(LabelVisibilityMode.LABEL_VISIBILITY_LABELED);
//        FragmentManager.enableNewStateManager(false);
        getShortVideo();


    }

    @Override
    public boolean onNavigationItemSelected(@NonNull MenuItem item) {
        int itemId = item.getItemId();
        if (itemId == R.id.navigation_home) {
            getShortVideo();
            return true;
        } else if (itemId == R.id.navigation_dashboard) {
            if (mClickItem != null) {
                mClickItem.selectItem(1);
                mClickItem = null;
            }
            finish();
            this.overridePendingTransition(0, 0);
            return true;
        } else if (itemId == R.id.navigation_notifications) {
            if (mClickItem != null) {
                mClickItem.selectItem(2);
                mClickItem = null;
            }
            finish();
            this.overridePendingTransition(0, 0);
            return true;
        } else if (itemId == R.id.navigation_my) {
            if (mClickItem != null) {
                mClickItem.selectItem(3);
                mClickItem = null;
            }
            finish();
            this.overridePendingTransition(0, 0);
            return true;
        }
        return false;

    }

    public static void onClickItem(ClickItem clickItem) {
        mClickItem = clickItem;
    }

    private void getShortVideo() {
        OSETVideoContent.getInstance().setPosId(adId).loadRecommend(new OSETVideoContentListener() {
            @Override
            public void onLoadFail(String code, String e) {
                Log.d(TAG, "onLoadFail code=" + code + "、message=" + e);
            }

            @Override
            public void onLoadSuccess(VideoContentResult videoContentResult) {
                Log.d(TAG, "loadSuccess");
                getSupportFragmentManager().beginTransaction()
                        .replace(R.id.short_content, videoContentResult.getFragment())
                        .commitAllowingStateLoss();
            }


            @Override
            public void onVideoStart(int position, boolean isAd, String id) {
                Log.d(TAG, "onVideoStart position=" + position + "、isA=" + isAd + "、id=" + id);
            }

            @Override
            public void onVideoPause(int position, boolean isAd, String id) {
                Log.d(TAG, "onVideoPause position=" + position + "、isA=" + isAd + "、id=" + id);
            }

            @Override
            public void onVideoResume(int position, boolean isAd, String id) {
                Log.d(TAG, "onVideoResume position=" + position + "、isA=" + isAd + "、id=" + id);
            }

            @Override
            public void onVideoComplete(int position, boolean isAd, String id) {
                Log.d(TAG, "onVideoComplete position=" + position + "、isA=" + isAd + "、id=" + id);
            }

            @Override
            public void onVideoPlayError(int position, boolean isAd, String id, String errorCode, String errorMessage) {
                Log.d(TAG, "onVideoPlayError position=" + position + "、isA=" + isAd + "、id=" + id + "、code=" + errorCode + "、message=" + errorMessage);
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

    @Override
    protected void onDestroy() {
        mClickItem = null;
        super.onDestroy();
    }

    @Override
    public boolean onKeyUp(int keyCode, KeyEvent event) {
        setResult(999, getIntent());
        return super.onKeyUp(keyCode, event);
    }

    @Override
    public boolean onKeyDown(int keyCode, KeyEvent event) {
        if (mClickItem != null && keyCode == KeyEvent.KEYCODE_BACK) {
            mClickItem.selectItem(999);
            finish();
        }
        return false;
    }
}