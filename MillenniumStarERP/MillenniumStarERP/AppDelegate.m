//
//  AppDelegate.m
//  MillenniumStarERP
//
//  Created by yjq on 16/9/5.
//  Copyright © 2016年 com.millenniumStar. All rights reserved.
//

#import "AppDelegate.h"
#import "WXApi.h"
#import "WeiboSDK.h"
#import "CommonUtils.h"
#import "Reachability.h"
#import "ShowLoginViewTool.h"
#import "UIWindow+Extension.h"
#import <ShareSDK/ShareSDK.h>
#import <AlipaySDK/AlipaySDK.h>
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import <ShareSDKConnector/ShareSDKConnector.h>
#import <LocalAuthentication/LocalAuthentication.h>

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
    [[NSNotificationCenter defaultCenter] addObserver:self
                 selector:@selector(reachabilityChanged:)
                            name: kReachabilityChangedNotification object: nil];
    hostReach = [Reachability reachabilityWithHostName:@"www.google.com"];
    [hostReach startNotifier];
    
    UIImage *backImg = [CommonUtils createImageWithColor:CUSTOM_COLOR(245, 245, 247)];
    [[UINavigationBar appearance] setBackgroundImage:backImg forBarMetrics:UIBarMetricsDefault];
    [[UINavigationBar appearance] setTintColor:CUSTOM_COLOR(50, 50, 50)];
    NSDictionary *attbutes = @{NSForegroundColorAttributeName:CUSTOM_COLOR(50, 50, 50)};
    [[UINavigationBar appearance]setTitleTextAttributes:attbutes];
    [self setShareSDK];
    [WXApi registerApp:@"wx303dc6296f3aed55"];
    return YES;
}

- (void)setShareSDK{
    [ShareSDK registerApp:@"1e74aa44eb1e0"
          activePlatforms:@[@(SSDKPlatformTypeSinaWeibo),
                            @(SSDKPlatformTypeWechat),
                            @(SSDKPlatformTypeQQ)]
                 onImport:^(SSDKPlatformType platformType)
     {
         switch (platformType)
         {
             case SSDKPlatformTypeWechat:
                 [ShareSDKConnector connectWeChat:[WXApi class]];
                 break;
             case SSDKPlatformTypeQQ:
                 [ShareSDKConnector connectQQ:[QQApiInterface class] tencentOAuthClass:[TencentOAuth class]];
                 break;
             case SSDKPlatformTypeSinaWeibo:
                 [ShareSDKConnector connectWeibo:[WeiboSDK class]];
                 break;
             default:
                 break;
         }
     }
          onConfiguration:^(SSDKPlatformType platformType, NSMutableDictionary *appInfo)
     {
         switch (platformType)
         {
             case SSDKPlatformTypeSinaWeibo:
                 //设置新浪微博应用信息,其中authType设置为使用SSO＋Web形式授权
                 [appInfo SSDKSetupSinaWeiboByAppKey:@"2196544773"
                                           appSecret:@"1123259b9fb76e7ad9daeb05b53c07bc"
                                         redirectUri:@"http://www.sharesdk.cn"
                                            authType:SSDKAuthTypeBoth];
                 break;
             case SSDKPlatformTypeWechat:
                 [appInfo SSDKSetupWeChatByAppId:@"wx303dc6296f3aed55"
                                       appSecret:@"2cb13f5188eea61860b7a62067785d92"];
                 break;
             case SSDKPlatformTypeQQ:
                 [appInfo SSDKSetupQQByAppId:@"1105719784"
                                      appKey:@"aRie3uZpITCKy65H"
                                    authType:SSDKAuthTypeBoth];
                 break;
             default:
                 break;
         }
     }];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication  annotation:(id)annotation {
    
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
            NSString *result = resultDic[@"result"];
            // 解析 auth code
            NSString *authCode = nil;
            if (result.length>0) {
                NSArray *resultArr = [result componentsSeparatedByString:@"&"];
                for (NSString *subResult in resultArr) {
                    if (subResult.length > 10 && [subResult hasPrefix:@"auth_code="]) {
//                        authCode = [subResult substringFromIndex:10];
                        break;
                    }
                }
            }
        }];
    }
    return [WXApi handleOpenURL:url delegate:self];
}

// NOTE: 9.0以后使用新API接口
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString*, id> *)options
{
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
            NSString *authCode = nil;
            if (result.length>0) {
                NSArray *resultArr = [result componentsSeparatedByString:@"&"];
                for (NSString *subResult in resultArr) {
                    if (subResult.length > 10 && [subResult hasPrefix:@"auth_code="]) {
//                        authCode = [subResult substringFromIndex:10];
                        break;
                    }
                }
            }
        }];
    }
    return [WXApi handleOpenURL:url delegate:self];
}

- (void) onResp:(BaseResp*)resp{
    NSString *resultMsg;
    //    NSString *resultMsg = [NSString stringWithFormat:@"errcode:%d", resp.errCode];
    NSString *strTitle = nil;
    if([resp isKindOfClass:[PayResp class]]){
        //支付返回结果，实际支付结果需要去微信服务器端查询
        strTitle = [NSString stringWithFormat:@"支付结果"];
        switch (resp.errCode) {
            case WXSuccess:
                NSLog(@"支付成功－PaySuccess，retcode = %d", resp.errCode);
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
//    NSParameterAssert([curReach isKindOfClass: [Reachability class]]);
    NetworkStatus status = [curReach currentReachabilityStatus];
    BOOL isYes = !(status == NotReachable);
    if (self.loadBack) {
        self.loadBack(isYes);
    }
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
