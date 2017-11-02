//
//  DetailTypeInfo.m
//  MillenniumStarERP
//
//  Created by yjq on 16/10/9.
//  Copyright © 2016年 com.millenniumStar. All rights reserved.
//

#import "DetailTypeInfo.h"

@implementation DetailTypeInfo

- (DetailTypeInfo *)newInfo{
    DetailTypeInfo *new = [DetailTypeInfo new];
    new.title = self.title;
    new.id = self.id;
    new.isSel = self.isSel;
    new.price = self.price;
    new.pic = self.pic;
    new.pic1 = self.pic1;
    return new;
}

- (id)copyWithZone:(NSZone *)zone
{
    DetailTypeInfo *new = [[DetailTypeInfo allocWithZone:zone] init];
    new.title = self.title;
    new.id = self.id;
    new.isSel = self.isSel;
    new.price = self.price;
    new.pic = self.pic;
    new.pic1 = self.pic1;
    return new;
}

- (id)mutableCopyWithZone:(NSZone *)zone{
    DetailTypeInfo *new = [[DetailTypeInfo allocWithZone:zone] init];
    new.title = self.title;
    new.id = self.id;
    new.isSel = self.isSel;
    new.price = self.price;
    new.pic = self.pic;
    new.pic1 = self.pic1;
    return new;
}

@end
