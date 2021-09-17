import 'dart:async';

import 'package:flutter/services.dart';
import 'TokenResult.dart';

// 授权页回调
typedef TokenResultListener = void Function(TokenResult tokenResult);

class Account {
  static const MethodChannel _channel = MethodChannel('account');

  Account();

  // 初始化SDK
  init({required String key}) async {
    await _channel.invokeMethod("init", {"key": key});
  }

  // 设置Debug模式
  Future<String?> setDebug({required bool isDebug}) async {
    _channel.invokeMethod("setDebug", {"isDebug": isDebug});
  }

  // 开始预取号
  Future<TokenResult?> preLogin({required int timeout}) async {
    Map<dynamic, dynamic> result =
        await _channel.invokeMethod("preLogin", {"timeout": timeout});
    return formatResult(result);
  }

  // 获取token
  Future<TokenResult?> getLoginToken({required int timeout}) async {
    Map<dynamic, dynamic> result =
        await _channel.invokeMethod("getLoginToken", {"timeout": timeout});
    return formatResult(result);
  }

  TokenResult formatResult(Map<dynamic, dynamic> result) {
    Map<String, dynamic> newResult = Map<String, dynamic>.from(result);
    TokenResult tokenResult = TokenResult();
    tokenResult.resultType = newResult['resultType'] as int?;
    tokenResult.resultCode = newResult['resultCode'] as int?;
    tokenResult.accessToken = newResult['accessToken'] as String?;
    tokenResult.mobile = newResult['mobile'] as String?;
    tokenResult.operatorType = newResult['operatorType'] as String?;
    tokenResult.gwAuth = newResult['gwAuth'] as String?;
    tokenResult.platform = newResult['platform'] as String?;
    tokenResult.originResult = newResult['originResult'] as String?;
    return tokenResult;
  }
}
