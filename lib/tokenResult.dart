class TokenResult {
  TokenResult(
      {this.resultType,
        this.resultCode,
        this.accessToken,
        this.mobile,
        this.operatorType,
        this.gwAuth,
        this.platform,
        this.originResult});

  int? resultType; //回调类型，0: 预取号结果 1: 一键登录结果
  int? resultCode; // 结果状态码，6666为成功，其他状态码为失败
  String? accessToken; // 运营商返回的token
  String? mobile; // 脱敏手机号
  String? operatorType; // CM: 中国移动 CU: 中国联通 CT: 中国电信 XX: 未知
  String? gwAuth; // 一键登录或号码认证 auth，电信返回
  String? platform; // 系统标识，0：iOS 1: Android
  String? originResult; // 运营商返回的原始信息

  @override
  String toString() {
    // TODO: implement toString
    return 'resultType:$resultType, resultCode:$resultCode, accessToken:$accessToken, mobile:$mobile, operatorType:$operatorType, gwAuth:$gwAuth, platform:$platform, originResult:$originResult';
  }
}