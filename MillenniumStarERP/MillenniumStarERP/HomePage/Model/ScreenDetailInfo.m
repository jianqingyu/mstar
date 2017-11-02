//
//  ScreenDetailInfo.m
//  MillenniumStarERP
//
//  Created by yjq on 16/10/8.
//  Copyright © 2016年 com.millenniumStar. All rights reserved.
//

#import "ScreenDetailInfo.h"

@implementation ScreenDetailInfo

- (id)copyWithZone:(NSZone *)zone
{
    ScreenDetailInfo *new = [[ScreenDetailInfo allocWithZone:zone] init];
    new.isSelect = self.isSelect;
    new.id = self.id;
    new.groupKey = self.groupKey;
    new.title = self.title;
    new.value = self.value;
    return new;
}

- (id)mutableCopyWithZone:(NSZone *)zone{
    ScreenDetailInfo *new = [[ScreenDetailInfo allocWithZone:zone] init];
    new.isSelect = self.isSelect;
    new.id = self.id;
    new.groupKey = self.groupKey;
    new.title = self.title;
    new.value = self.value;
    return new;
}

@end
