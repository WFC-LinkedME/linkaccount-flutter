#import "AccountPlugin.h"
#import <LinkAccount_Lib/LinkAccount.h>

@implementation AccountPlugin

+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
    FlutterMethodChannel* channel = [FlutterMethodChannel
                                     methodChannelWithName:@"account"
                                     binaryMessenger:[registrar messenger]];
    AccountPlugin* instance = [[AccountPlugin alloc] init];
    [registrar addMethodCallDelegate:instance channel:channel];
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    if ([@"getInstance" isEqualToString:call.method]) {
        [self getInstanceWithMethodCall:call result:result];
    } else if ([@"setDebug" isEqualToString:call.method]) {
        [self setDebugWithMethodCall:call result:result];
    } else if ([@"preLogin" isEqualToString:call.method]) {
        [self preLoginWithMethodCall:call result:result];
    } else if ([@"getLoginToken" isEqualToString:call.method]) {
        [self getLoginTokenWithMethodCall:call result:result];
    }
}

- (void)setDebugWithMethodCall:(FlutterMethodCall *)call result:(FlutterResult)result {
    
}

- (void)getInstanceWithMethodCall:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSString *appKey = [call.arguments valueForKey:@"key"];
    [LMAuthSDKManager initWithKey:appKey complete:^(NSDictionary * _Nonnull resultDic) {
        NSLog(@"%@", resultDic);
        result(resultDic);
    }];
}

- (void)preLoginWithMethodCall:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSInteger timeout = [[call.arguments valueForKey:@"timeout"] integerValue];
    [LMAuthSDKManager getMobileAuthWithTimeout:timeout complete:^(NSDictionary * _Nonnull resultDic) {
        NSLog(@"%@", resultDic);
        result(resultDic);
    }];
}

- (void)getLoginTokenWithMethodCall:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSInteger timeout = [[call.arguments valueForKey:@"timeout"] integerValue];
    [[LMAuthSDKManager sharedSDKManager] getAccessTokenWithTimeout:timeout controller:[UIApplication sharedApplication].keyWindow.rootViewController complete:^(NSDictionary * _Nonnull resultDic) {
        NSLog(@"%@", resultDic);
        result(resultDic);
    }];
}

@end
