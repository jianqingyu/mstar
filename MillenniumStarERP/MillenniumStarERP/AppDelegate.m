//
//  AppDelegate.m
//  MillenniumStarERP
//
//  Created by yjq on 16/9/5.
//  Copyright © 2016年 com.millenniumStar. All rights reserved.
//

#import "AppDelegate.h"
#import "WXApi.h"
// 引入JPush功能所需头文件
#import "JPUSHService.h"
#import <AdSupport/AdSupport.h>
// iOS10注册APNs所需头文件
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif
#import "SaveDataTool.h"
#import "ShareSDKTool.h"
#import "CommonUtils.h"
#import "Reachability.h"
#import "UIWindow+Extension.h"
#import <AlipaySDK/AlipaySDK.h>

@interface AppDelegate ()<WXApiDelegate,JPUSHRegisterDelegate>{
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
    [self setJPUSHService:launchOptions];
    return YES;
}

- (void)setJPUSHService:(NSDictionary *)launchOptions{
    //notice: 3.0.0及以后版本注册可以这样写，也可以继续用之前的注册方式
    JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
    entity.types = JPAuthorizationOptionAlert|JPAuthorizationOptionBadge|JPAuthorizationOptionSound;
    [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
    // 如需使用IDFA功能请添加此代码并在初始化方法的advertisingIdentifier参数中填写对应值
//    NSString *advertisingId = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    //aps 0开发 1上线
    [JPUSHService setupWithOption:launchOptions appKey:@"c562335006792772769db2a6"
                          channel:@"App Store" apsForProduction:1
            advertisingIdentifier:@""];
    if (launchOptions) {
        NSDictionary * remoteNotification = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
        //这个判断是在程序没有运行的情况下收到通知，点击通知跳转页面
        if (remoteNotification) {
            [MBProgressHUD showError:@"推送消息"];
        }
    }
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

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    NSString* newToken = [[[NSString stringWithFormat:@"%@",deviceToken]
                           stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]] stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSLog(@"nsdata:%@\n 字符串token: %@",deviceToken, newToken);// 获取device token
    [JPUSHService registerDeviceToken:deviceToken];
    //将token发送给服务器
}
#pragma mark- JPUSHRegisterDelegate
// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler {
    // Required
    NSDictionary * userInfo = notification.request.content.userInfo;
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
    }
    completionHandler(UNNotificationPresentationOptionAlert); // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以选择设置
}
// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
    // Required
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
    }
    completionHandler(); // 系统要求执行这个方法
}
//回调
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    // Required, iOS 7 Support
    [JPUSHService handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    [application setApplicationIconBadgeNumber:0];   //清除角标
    [JPUSHService setBadge:0];//同样的告诉极光角标为0了
    [application cancelAllLocalNotifications];
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
