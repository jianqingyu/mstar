//
//  YQObjectBool.m
//  MillenniumStarERP
//
//  Created by yjq on 16/12/5.
//  Copyright © 2016年 com.millenniumStar. All rights reserved.
//

#import "YQObjectBool.h"

@implementation YQObjectBool
+ (BOOL)boolForObject:(id)object{
    if ([object isEqual:[NSNull null]]) {
        return NO;
    }
    if(object==nil)
    {
        return NO;
    }
    if ([object isKindOfClass:[NSArray class]]) {
        return [object count];
    }
    if ([object isKindOfClass:[NSDictionary class]]) {
        return [object count];
    }
    if ([object isKindOfClass:[NSString class]]) {
        return [object length];
    }
    if ([object isKindOfClass:[NSNumber class]]) {
        return [object intValue];
    }
    return NO;
}

@end
