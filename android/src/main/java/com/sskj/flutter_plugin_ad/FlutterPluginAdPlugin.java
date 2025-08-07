package com.sskj.flutter_plugin_ad;

import android.util.Log;

import androidx.annotation.NonNull;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.embedding.engine.plugins.activity.ActivityAware;
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;
import io.flutter.plugin.common.EventChannel;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;

/**
 * FlutterPluginAdPlugin
 */
@SuppressWarnings("unchecked")
public class FlutterPluginAdPlugin implements FlutterPlugin, MethodCallHandler, ActivityAware {
    private static final String TAG = "adset_plugin";
    private MethodChannel channel;
    private EventChannel eventChannel;

    private FlutterPluginBinding bind;

    private PluginAdSetDelegate delegate;

    @Override
    public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
        bind = flutterPluginBinding;
        channel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), "flutter_plugin_ad");
        channel.setMethodCallHandler(this);

        eventChannel = new EventChannel(flutterPluginBinding.getBinaryMessenger(), "flutter_plugin_ad_event");
    }

    @Override
    public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
        if (delegate != null) {
            delegate.onMethodCall(call, result);
        }
    }

    @Override
    public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
        channel.setMethodCallHandler(null);
        eventChannel.setStreamHandler(null);
    }

    @Override
    public void onAttachedToActivity(@NonNull ActivityPluginBinding binding) {
        delegate = PluginAdSetDelegate.getInstance();
        delegate.init(binding.getActivity(), bind);
        binding.addActivityResultListener(delegate);
        binding.addRequestPermissionsResultListener(delegate);
        eventChannel.setStreamHandler(delegate);
    }

    @Override
    public void onDetachedFromActivityForConfigChanges() {
        onDetachedFromActivity();
    }

    @Override
    public void onReattachedToActivityForConfigChanges(@NonNull ActivityPluginBinding binding) {
        onAttachedToActivity(binding);
    }

    @Override
    public void onDetachedFromActivity() {
        this.delegate = null;
    }
}
