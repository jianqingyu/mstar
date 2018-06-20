//
//  SaveUserInfo.m
//  MillenniumStarERP
//
//  Created by 余建清 on 2018/5/29.
//  Copyright © 2018年 com.millenniumStar. All rights reserved.
//

#import "SaveUserInfo.h"

@implementation SaveUserInfo
//单例
+ (instancetype)shared
{
    static dispatch_once_t once = 0;
    static SaveUserInfo *alert;
    dispatch_once(&once, ^{
        alert = [[SaveUserInfo alloc]init];
    });
    return alert;
}
@end
