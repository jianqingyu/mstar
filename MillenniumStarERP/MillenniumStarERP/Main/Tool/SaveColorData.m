//
//  SaveColorData.m
//  MillenniumStarERP
//
//  Created by 余建清 on 2018/3/5.
//  Copyright © 2018年 com.millenniumStar. All rights reserved.
//

#import "SaveColorData.h"

@implementation SaveColorData
//单例
+ (instancetype)shared
{
    static dispatch_once_t once = 0;
    static SaveColorData *alert;
    dispatch_once(&once, ^{
        alert = [[SaveColorData alloc]init];
    });
    return alert;
}

@end
