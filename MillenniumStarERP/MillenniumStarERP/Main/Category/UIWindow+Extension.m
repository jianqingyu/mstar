//
//  UIWindow+Extension.m
//  YQ微博
//
//  Created by tarena425 on 15/7/3.
//  Copyright (c) 2015年 ccyuqing. All rights reserved.
//

#import "UIWindow+Extension.h"
#import "MainTabViewController.h"
#import "MainNavViewController.h"
#import "LoginViewController.h"
#import "NewfeatureViewController.h"
@implementation UIWindow (Extension)

- (void)switchRootViewController{
    self.rootViewController = [[LoginViewController alloc]init];
//    NSString *key = @"CFBundleVersion";
//    //取出的版本
//    NSString *lastVersion = [[NSUserDefaults standardUserDefaults]objectForKey:key];
//    //当前的版本
//    NSString *currentVersion = [NSBundle mainBundle].infoDictionary[key];
//    if ([currentVersion isEqualToString:lastVersion]) {
//        self.rootViewController = [[LoginViewController alloc]init];
//    }else{
//        self.rootViewController = [[NewfeatureViewController alloc]init];
//        //将当前版本存入
//        [[NSUserDefaults standardUserDefaults]setObject:currentVersion forKey:key];
//        [[NSUserDefaults standardUserDefaults]synchronize];
//    }
}

@end
