//
//  AppOpenTextTool.m
//  MillenniumStarERP
//
//  Created by 余建清 on 2018/3/27.
//  Copyright © 2018年 com.millenniumStar. All rights reserved.
//

#import "AppOpenTextTool.h"
#import "ShowLoginViewTool.h"
#import "MainNavViewController.h"
#import "LoginViewController.h"
#import "BulkOrderViewController.h"
@implementation AppOpenTextTool
+ (void)openTextWith:(NSURL *)url{
    if (url != nil) {
        NSString *path = [url absoluteString];
        path = [self URLDecodedString:path];
        NSMutableString *string = [[NSMutableString alloc] initWithString:path];
        if ([path hasPrefix:@"file://"]) {
            [string replaceOccurrencesOfString:@"file://" withString:@"" options:NSCaseInsensitiveSearch  range:NSMakeRange(0, path.length)];
            UIViewController *vc = [ShowLoginViewTool getCurrentVC];
            BulkOrderViewController *infoVc = [BulkOrderViewController new];
            infoVc.path = string;
            if ([vc isKindOfClass:[LoginViewController class]]) {
                infoVc.isPre = YES;
                LoginViewController *loginVc = (LoginViewController *)vc;
                loginVc.noLogin = YES;
                loginVc.back = ^(BOOL isYes){
                    MainNavViewController *navi = [[MainNavViewController alloc]initWithRootViewController:infoVc];
                    [vc presentViewController:navi animated:YES completion:nil];
                };
            }else if ([vc isKindOfClass:[BulkOrderViewController class]]){
                [vc.navigationController pushViewController:infoVc animated:YES];
                NSMutableArray *navigationArray = [[NSMutableArray alloc] initWithArray: vc.navigationController.viewControllers];
                NSInteger index = vc.navigationController.viewControllers.count;
                [navigationArray removeObjectAtIndex: index-2];
                vc.navigationController.viewControllers = navigationArray;
            }else{
                [vc.navigationController pushViewController:infoVc animated:YES];
            }
        }
        //获取在存储在本地的文件路径就可以在自己需要显示的页面加载文件显示了
    }
}
//当文件名为中文是，解决url编码问题
+ (NSString *)URLDecodedString:(NSString *)str{
    NSString *decodedString=(__bridge_transfer NSString *)CFURLCreateStringByReplacingPercentEscapesUsingEncoding(NULL, (__bridge CFStringRef)str, CFSTR(""), CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding));
    NSLog(@"decodedString = %@",decodedString);
    return decodedString;
}

@end
