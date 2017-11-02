//
//  StorageDataTool.m
//  MillenniumStarERP
//
//  Created by yjq on 17/8/14.
//  Copyright © 2017年 com.millenniumStar. All rights reserved.
//

#import "StorageDataTool.h"

@implementation StorageDataTool
//单例
+ (instancetype)shared
{
    static dispatch_once_t once = 0;
    static StorageDataTool *alert;
    dispatch_once(&once, ^{
        alert = [[StorageDataTool alloc]init];
    });
    return alert;
}

@end
