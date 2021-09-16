package cc.lkme.account;

import android.content.Context;
import android.os.Handler;
import android.os.Looper;

import java.util.HashMap;
import java.util.Map;

import cc.lkme.linkaccount.LinkAccount;
import cc.lkme.linkaccount.callback.TokenResult;
import cc.lkme.linkaccount.callback.TokenResultListener;
import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;

/**
 * AccountPlugin
 */
public class AccountPlugin implements FlutterPlugin, MethodCallHandler {
    /// The MethodChannel that will the communication between Flutter and native Android
    ///
    /// This local reference serves to register the plugin with the Flutter Engine and unregister it
    /// when the Flutter Engine is detached from the Activity
    private MethodChannel channel;
    private Context context;
    private Handler handler;

    @Override
    public void onAttachedToEngine(FlutterPluginBinding flutterPluginBinding) {
        context = flutterPluginBinding.getApplicationContext();
        channel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), "account");
        channel.setMethodCallHandler(this);
        handler = new Handler(Looper.getMainLooper());
    }

    @Override
    public void onMethodCall(MethodCall call, Result result) {
        if (call.method.equals("getInstance")) {
            getInstance(call, result);
        } else if (call.method.equals("setDebug")) {
            setDebug(call, result);
        } else if (call.method.equals("preLogin")) {
            preLogin(call, result);
        } else if (call.method.equals("getLoginToken")) {
            getLoginToken(call, result);
        } else {
            result.notImplemented();
        }
    }

    private void getInstance(MethodCall call, final Result result) {
        String appKey = call.argument("key");
        LinkAccount.getInstance(context, appKey);
    }

    private void setDebug(MethodCall call, final Result result) {
        boolean isDebug = call.argument("isDebug");
        LinkAccount.getInstance().setDebug(isDebug);
    }

    private void setTokenResultListener() {
        System.out.println("callback=== setTokenResultListener");
        LinkAccount.getInstance().setTokenResultListener(new TokenResultListener() {
            @Override
            public void onSuccess(final int resultType, final TokenResult tokenResult, final String originResult) {
                System.out.println("callback===" + resultType + tokenResult.toString() + originResult);
                handler.post(new Runnable() {
                    @Override
                    public void run() {
                        Map<String, Object> map = new HashMap<String, Object>();
                        map.put("resultType", resultType);
                        map.put("resultCode", tokenResult.getResultCode());
                        map.put("accessToken", tokenResult.getAccessToken());
                        map.put("mobile", tokenResult.getMobile());
                        map.put("operatorType", tokenResult.getOperatorType());
                        map.put("gwAuth", tokenResult.getGwAuth());
                        map.put("platform", tokenResult.getPlatform());
                        map.put("originResult", originResult);
                        channel.invokeMethod("tokenResult", map);
                    }
                });
            }

            @Override
            public void onFailed(int i, String s) {

            }
        });
    }

    private void preLogin(MethodCall call, final Result result) {
        setTokenResultListener();
        int timeout = call.argument("timeout");
        LinkAccount.getInstance().preLogin(timeout);
    }

    private void getLoginToken(MethodCall call, final Result result) {
        int timeout = call.argument("timeout");
        LinkAccount.getInstance().getLoginToken(timeout);
    }

    @Override
    public void onDetachedFromEngine(FlutterPluginBinding binding) {
        channel.setMethodCallHandler(null);
    }
}
