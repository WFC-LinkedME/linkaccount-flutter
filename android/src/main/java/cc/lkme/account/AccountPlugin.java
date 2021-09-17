package cc.lkme.account;

import android.content.Context;
import android.os.Handler;
import android.os.Looper;

import java.util.HashMap;
import java.util.Map;

import cc.lkme.linkaccount.LinkAccount;
import cc.lkme.linkaccount.callback.TokenResult;
import cc.lkme.linkaccount.callback.TokenResultListener;
import io.flutter.Log;
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
    private boolean isPreLogin = true;
    private Result preLoginResult;
    private Result getTokenResult;

    @Override
    public void onAttachedToEngine(FlutterPluginBinding flutterPluginBinding) {
        context = flutterPluginBinding.getApplicationContext();
        channel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), "account");
        channel.setMethodCallHandler(this);
        handler = new Handler(Looper.getMainLooper());
    }

    @Override
    public void onMethodCall(MethodCall call, Result result) {
        if (call.method.equals("init")) {
            init(call, result);
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

    /**
     * SDK初始化
     */
    private void init(MethodCall call, final Result result) {
        String appKey = call.argument("key");
        LinkAccount.getInstance(context, appKey);
        setTokenResultListener();
    }

    /**
     * 设置debug模式
     */
    private void setDebug(MethodCall call, final Result result) {
        if (LinkAccount.getInstance() == null) {
            // 需要先初始化SDK
            Log.i("Account", "请先初始化SDK");
        } else {
            boolean isDebug = call.argument("isDebug");
            LinkAccount.getInstance().setDebug(isDebug);
        }
    }

    private void setTokenResultListener() {
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
                        if (isPreLogin && preLoginResult != null) {
                            preLoginResult.success(map);
                        }
                        if (!isPreLogin && preLoginResult != null) {
                            getTokenResult.success(map);
                        }
                    }
                });
            }

            @Override
            public void onFailed(int resultType, String info) {
                Map<String, Object> map = new HashMap<String, Object>();
                map.put("resultType", resultType);
                map.put("resultCode", 10000);
                map.put("originResult", info);
                if (isPreLogin && preLoginResult != null) {
                    preLoginResult.success(map);
                }
                if (!isPreLogin && preLoginResult != null) {
                    getTokenResult.success(map);
                }
            }
        });
    }

    /**
     * 预取号方法
     */
    private void preLogin(MethodCall call, Result result) {
        if (LinkAccount.getInstance() == null) {
            sdkNotInit(0, result);
        } else {
            isPreLogin = true;
            preLoginResult = result;
            int timeout = call.argument("timeout");
            LinkAccount.getInstance().preLogin(timeout);
        }
    }

    /**
     * 一键登录方法
     */
    private void getLoginToken(MethodCall call, final Result result) {
        if (LinkAccount.getInstance() == null) {
            sdkNotInit(1, result);
        } else {
            isPreLogin = false;
            getTokenResult = result;
            int timeout = call.argument("timeout");
            LinkAccount.getInstance().getLoginToken(timeout);
        }

    }

    @Override
    public void onDetachedFromEngine(FlutterPluginBinding binding) {
        channel.setMethodCallHandler(null);
    }

    /**
     * SDK 未初始化
     */
    private void sdkNotInit(int resultType, Result result) {
        if (LinkAccount.getInstance() == null) {
            // 需要先初始化SDK
            Map<String, Object> map = new HashMap<String, Object>();
            map.put("resultType", resultType);
            map.put("resultCode", 10001);
            map.put("originResult", "SDK未初始化，请先初始化SDK");
            result.success(map);
        }
    }
}
