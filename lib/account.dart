import 'dart:async';

import 'package:flutter/services.dart';
import 'TokenResult.dart';

// 授权页回调
typedef TokenResultListener = void Function(TokenResult tokenResult);

class Account {
  static const MethodChannel _channel = MethodChannel('account');

  final AccountHandlers _eventHanders = new AccountHandlers();

  Account() {
    _channel.setMethodCallHandler(_handlerMethod);
  }

  Future<void> _handlerMethod(MethodCall call) async {
    switch (call.method) {
      case 'tokenResult':
        Map<String, dynamic> map = Map<String, dynamic>.from(call.arguments);

        TokenResult tokenResult = TokenResult();
        tokenResult.resultType = map['resultType'] as int?;
        tokenResult.resultCode = map['resultCode'] as int?;
        tokenResult.accessToken = map['accessToken'] as String?;
        tokenResult.mobile = map['mobile'] as String?;
        tokenResult.operatorType = map['operatorType'] as String?;
        tokenResult.gwAuth = map['gwAuth'] as String?;
        tokenResult.platform = map['platform'] as String?;
        tokenResult.originResult =  map['originResult'] as String?;
        _eventHanders.tokenResultListener?.call(tokenResult);
        break;
      default:
        throw new UnsupportedError("Unrecognized Event");
    }
  }

  // 初始化SDK
  Future<String?> getInstance({required String key}) async {
    _channel.invokeMethod("getInstance", {"key": key});
    return "123";
  }

  // 设置Debug模式
  Future<String?> setDebug({required bool isDebug}) async {
    _channel.invokeMethod("setDebug", {"isDebug": isDebug});
    return "123";
  }

  // 设置监听
  setTokenResultListener(TokenResultListener callback) {
    _eventHanders.tokenResultListener = callback;
  }

  // 开始预取号
  preLogin({required int timeout}) async {
    _channel.invokeMethod("preLogin", {"timeout": timeout});
  }

  // 获取token
   getLoginToken({required int timeout}) async {
    _channel.invokeMethod("getLoginToken", {"timeout": timeout});
  }
}

class AccountHandlers {
  TokenResultListener? tokenResultListener;
}
