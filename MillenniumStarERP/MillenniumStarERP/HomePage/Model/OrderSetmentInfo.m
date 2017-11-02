//
//  OrderSetmentInfo.m
//  MillenniumStarERP
//
//  Created by yjq on 17/3/9.
//  Copyright © 2017年 com.millenniumStar. All rights reserved.
//

#import "OrderSetmentInfo.h"
#import "DelSListInfo.h"
@implementation OrderSetmentInfo
+ (NSDictionary *)objectClassInArray
{
    return @{@"moList":[DelSListInfo class]};
}
@end
