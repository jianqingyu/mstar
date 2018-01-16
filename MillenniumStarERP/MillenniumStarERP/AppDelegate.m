//
//  AppDelegate.m
//  MillenniumStarERP
//
//  Created by yjq on 16/9/5.
//  Copyright © 2016年 com.millenniumStar. All rights reserved.
//

#import "AppDelegate.h"
#import "WXApi.h"
#import "ShareSDKTool.h"
#import "CommonUtils.h"
#import "Reachability.h"
#import "UIWindow+Extension.h"
#import <AlipaySDK/AlipaySDK.h>

@interface AppDelegate ()<WXApiDelegate>{
    Reachability *hostReach;
}

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    [self.window switchRootViewController];
    [self.window makeKeyAndVisible];
    // 监听网络状态改变的通知
    [self addNetNotification];
    [self setNavigation];
    [WXApi registerApp:@"wx303dc6296f3aed55"];
    [ShareSDKTool registerShareSDK];
    return YES;
}

- (void)addNetNotification{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reachabilityChanged:)
                                                 name: kReachabilityChangedNotification object: nil];
    hostReach = [Reachability reachabilityWithHostName:@"www.google.com"];
    [hostReach startNotifier];
}

- (void)setNavigation{
    UIImage *backImg = [CommonUtils createImageWithColor:CUSTOM_COLOR(245, 245, 247)];
    [[UINavigationBar appearance] setBackgroundImage:backImg forBarMetrics:UIBarMetricsDefault];
    [[UINavigationBar appearance] setTintColor:CUSTOM_COLOR(50, 50, 50)];
    NSDictionary *attbutes = @{NSForegroundColorAttributeName:CUSTOM_COLOR(50, 50, 50)};
    [[UINavigationBar appearance]setTitleTextAttributes:attbutes];
}
// 9.0以前调用
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication  annotation:(id)annotation {
    [self loadAliPaySDK:url];
    return [WXApi handleOpenURL:url delegate:self];
}
// 9.0以后使用新API接口
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString*, id> *)options{
    [self loadAliPaySDK:url];
    return [WXApi handleOpenURL:url delegate:self];
}
// 统一调取支付宝
- (void)loadAliPaySDK:(NSURL *)url{
    if ([url.host isEqualToString:@"safepay"]) {
        // 支付跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            BOOL isSuccess = NO;
            if ([resultDic[@"resultStatus"]intValue]==9000) {
                isSuccess = YES;
            }
            [MBProgressHUD showError:resultDic[@"memo"]];
            if (self.aliPayCallBack) {
                self.aliPayCallBack(isSuccess);
            }
        }];
        // 授权跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processAuth_V2Result:url standbyCallback:^(NSDictionary *resultDic) {
            // 解析 auth code
            NSString *result = resultDic[@"result"];
//            NSString *authCode = nil;
            if (result.length>0) {
                NSArray *resultArr = [result componentsSeparatedByString:@"&"];
                for (NSString *subResult in resultArr) {
                    if (subResult.length > 10 && [subResult hasPrefix:@"auth_code="]) {
                        //   authCode = [subResult substringFromIndex:10];
                        break;
                    }
                }
            }
        }];
    }
}

- (void)onResp:(BaseResp*)resp{
    NSString *resultMsg;
    NSString *strTitle = nil;
    if([resp isKindOfClass:[PayResp class]]){
        //支付返回结果，实际支付结果需要去微信服务器端查询
        strTitle = [NSString stringWithFormat:@"支付结果"];
        switch (resp.errCode) {
            case WXSuccess:
                if (self.weChatPayBlock) {
                    self.weChatPayBlock(YES);
                }
                break;
            default:
                resultMsg = [NSString stringWithFormat:@"支付结果：失败！retcode = %d, retstr = %@", resp.errCode,resp.errStr];
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle message:resultMsg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [alert show];
                break;
        }
    }
}

- (void)reachabilityChanged:(NSNotification *)note {
    Reachability* curReach = [note object];
    NetworkStatus status = [curReach currentReachabilityStatus];
    BOOL isYes = !(status == NotReachable);
    if (self.loadBack) {
        self.loadBack(isYes);
    }
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
