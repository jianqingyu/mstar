//
//  SaveDataTool.m
//  MillenniumStarERP
//
//  Created by 余建清 on 2018/1/19.
//  Copyright © 2018年 com.millenniumStar. All rights reserved.
//

#import "SaveDataTool.h"

@implementation SaveDataTool
//单例
+ (instancetype)shared
{
    static dispatch_once_t once = 0;
    static SaveDataTool *alert;
    dispatch_once(&once, ^{
        alert = [[SaveDataTool alloc]init];
    });
    return alert;
}

@end
