#import "LinkaccountPlugin.h"
#import <LinkAccount_Lib/LinkAccount.h>

@interface LinkaccountPlugin ()

@property (nonatomic, assign, getter=isSdkInit) BOOL sdkInit;
@property (nonatomic, assign, getter=isPreLogin) BOOL preLogin;

@end

@implementation LinkaccountPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  FlutterMethodChannel* channel = [FlutterMethodChannel
      methodChannelWithName:@"linkaccount"
            binaryMessenger:[registrar messenger]];
  LinkaccountPlugin* instance = [[LinkaccountPlugin alloc] init];
  [registrar addMethodCallDelegate:instance channel:channel];
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    if ([@"init" isEqualToString:call.method]) {
        [self initializeWithMethodCall:call result:result];
    } else if ([@"setDebug" isEqualToString:call.method]) {
        [self setDebugWithMethodCall:call result:result];
    } else if ([@"preLogin" isEqualToString:call.method]) {
        [self preLoginWithMethodCall:call result:result];
    } else if ([@"getLoginToken" isEqualToString:call.method]) {
        [self getLoginTokenWithMethodCall:call result:result];
    }
}

- (void)setDebugWithMethodCall:(FlutterMethodCall *)call result:(FlutterResult)result {
    // TODO
}

// SDK 初始化
- (void)initializeWithMethodCall:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSString *appKey = [call.arguments valueForKey:@"key"];
    [LMAuthSDKManager initWithKey:appKey complete:^(NSDictionary * _Nonnull resultDic) {
        NSInteger resultCode = [[resultDic valueForKey:@"resultCode"] integerValue];
        self.sdkInit = (resultCode == 6666);
        NSMutableDictionary *dictM = [NSMutableDictionary dictionaryWithCapacity:2];
        [dictM setValue:@(resultCode) forKey:@"resultCode"];
        [dictM setValue:[LinkaccountPlugin jsonStrWithDict:resultDic] forKey:@"originResult"];
        result(dictM);
    }];
}

// 预取号
- (void)preLoginWithMethodCall:(FlutterMethodCall *)call result:(FlutterResult)result {
    if (!self.isSdkInit) {
        [self sdkNotInitWithResultType:0 completion:^(NSDictionary * _Nullable dict) {
            result(dict);
        }];
    } else {
        NSInteger timeout = [[call.arguments valueForKey:@"timeout"] integerValue];
        [LMAuthSDKManager getMobileAuthWithTimeout:timeout complete:^(NSDictionary * _Nonnull resultDic) {
            if ([[resultDic valueForKey:@"resultCode"] integerValue] == 6666) {
                NSMutableDictionary *dictM = [NSMutableDictionary dictionaryWithCapacity:8];
                NSDictionary *desc = [resultDic valueForKey:@"desc"];
                [dictM setValue:@(0) forKey:@"resultType"];
                [dictM setValue:@([[resultDic valueForKey:@"resultCode"] integerValue]) forKey:@"resultCode"];
                [dictM setValue:[desc valueForKey:@"mobile"] forKey:@"mobile"];
                [dictM setValue:[desc valueForKey:@"operatorType"] forKey:@"operatorType"];
                [dictM setValue:[desc valueForKey:@"gwAuth"] forKey:@"gwAuth"];
                [dictM setValue:@"0" forKey:@"platform"];
                self.preLogin = (1 == 1);
                result(dictM);
            } else {
                NSMutableDictionary *dictM = [NSMutableDictionary dictionaryWithCapacity:2];
                [dictM setValue:@([[resultDic valueForKey:@"resultCode"] integerValue]) forKey:@"resultCode"];
                [dictM setValue:[LinkaccountPlugin jsonStrWithDict:resultDic] forKey:@"originResult"];
                self.preLogin = (1 == 0);
                result(dictM);
            }
//            NSLog(@"😊预取号结果: %@", resultDic);
        }];
    }
}

// 一键登录
- (void)getLoginTokenWithMethodCall:(FlutterMethodCall *)call result:(FlutterResult)result {
    if (!self.isSdkInit) {
        [self sdkNotInitWithResultType:1 completion:^(NSDictionary * _Nullable dict) {
            result(dict);
        }];
    } else {
        if (!self.isPreLogin) {
            [self notPreLoginWithResultType:1 completion:^(NSDictionary * _Nullable dict) {
                result(dict);
            }];
        } else {
            NSInteger timeout = [[call.arguments valueForKey:@"timeout"] integerValue];
            [[LMAuthSDKManager sharedSDKManager] getAccessTokenWithTimeout:timeout controller:[UIApplication sharedApplication].keyWindow.rootViewController complete:^(NSDictionary * _Nonnull resultDic) {
                if ([[resultDic valueForKey:@"resultCode"] integerValue] == 6666) {
                    NSMutableDictionary *dictM = [NSMutableDictionary dictionaryWithCapacity:8];
                    [dictM setValue:@(1) forKey:@"resultType"];
                    [dictM setValue:@([[resultDic valueForKey:@"resultCode"] integerValue]) forKey:@"resultCode"];
                    [dictM setValue:[resultDic valueForKey:@"accessToken"] forKey:@"accessToken"];
                    [dictM setValue:[resultDic valueForKey:@"operatorType"] forKey:@"operatorType"];
                    [dictM setValue:[resultDic valueForKey:@"gwAuth"] forKey:@"gwAuth"];
                    [dictM setValue:[resultDic valueForKey:@"mobile"] forKey:@"mobile"];
                    [dictM setValue:@"0" forKey:@"platform"];
                    result(dictM);
                } else {
                    NSMutableDictionary *dictM = [NSMutableDictionary dictionaryWithCapacity:2];
                    [dictM setValue:@([[resultDic valueForKey:@"resultCode"] integerValue]) forKey:@"resultCode"];
                    [dictM setValue:[LinkaccountPlugin jsonStrWithDict:resultDic] forKey:@"originResult"];
                    result(dictM);
                }
//                NSLog(@"😊一键登录结果: %@", resultDic);
            }];
        }
    }
}

- (void)notPreLoginWithResultType:(NSInteger)resultType completion:(void (^)(NSDictionary * _Nullable dict))completion {
    NSMutableDictionary *dictM = [NSMutableDictionary dictionaryWithCapacity:3];
    [dictM setValue:@(resultType) forKey:@"resultType"];
    [dictM setValue:@(10000) forKey:@"resultCode"];
    [dictM setValue:@"请先预取号" forKey:@"originResult"];
    completion(dictM);
}

- (void)sdkNotInitWithResultType:(NSInteger)resultType completion:(void (^)(NSDictionary * _Nullable dict))completion {
    NSMutableDictionary *dictM = [NSMutableDictionary dictionaryWithCapacity:3];
    [dictM setValue:@(resultType) forKey:@"resultType"];
    [dictM setValue:@(10001) forKey:@"resultCode"];
    [dictM setValue:@"SDK未初始化，请先初始化SDK" forKey:@"originResult"];
    completion(dictM);
}

+ (NSString *)jsonStrWithDict:(NSDictionary *)dict {
    NSError *parseError = [[NSError alloc] init];
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&parseError];
    NSString *result = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    if (result.length) {
        return result;
    } else {
        return @"操作失败!";
    }
}

@end
