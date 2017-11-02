//
//  Account.m
//  MillenniumStar08.07
//
//  Created by yjq on 15/10/10.
//  Copyright © 2015年 qxzx.com. All rights reserved.
//

#import "Account.h"

@implementation Account

+ (instancetype)accountWithDict:(NSDictionary *)dict{
    return [[self alloc]initWithAccountDict:dict];
}

- (id)initWithAccountDict:(NSDictionary *)dict{
    if (self = [super init]) {
        self.userName = dict[@"userName"];
        self.password = dict[@"password"];
        self.tokenKey = dict[@"tokenKey"];
        self.phone    = dict[@"phone"];
        self.isNoShow = dict[@"isNoShow"];
        self.isNorm   = dict[@"isNorm"];
        self.isNoDriShow  = dict[@"isNoDriShow"];
    }
    return self;
}
/**
 *当一个对象要归档进沙盒时，就会调用这个方法
 */
- (void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:self.phone forKey:@"phone"];
    [aCoder encodeObject:self.isNorm forKey:@"isNorm"];
    [aCoder encodeObject:self.isNoShow forKey:@"isNoShow"];
    [aCoder encodeObject:self.userName forKey:@"userName"];
    [aCoder encodeObject:self.password forKey:@"password"];
    [aCoder encodeObject:self.tokenKey forKey:@"tokenKey"];
    [aCoder encodeObject:self.isNoDriShow forKey:@"isNoDriShow"];
}
/**
 *当从沙盒中解当时，就会调用这个方法
 */
- (id)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super init]) {
        self.userName = [aDecoder decodeObjectForKey:@"userName"];
        self.password = [aDecoder decodeObjectForKey:@"password"];
        self.tokenKey = [aDecoder decodeObjectForKey:@"tokenKey"];
        self.phone    = [aDecoder decodeObjectForKey:@"phone"];
        self.isNoShow = [aDecoder decodeObjectForKey:@"isNoShow"];
        self.isNorm   = [aDecoder decodeObjectForKey:@"isNorm"];
        self.isNoDriShow  = [aDecoder decodeObjectForKey:@"isNoDriShow"];
    }
    return self;
}

@end
