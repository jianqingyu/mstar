//
//  StaticNumInfo.m
//  MillenniumStarERP
//
//  Created by 余建清 on 2018/4/11.
//  Copyright © 2018年 com.millenniumStar. All rights reserved.
//

#import "StaticNumInfo.h"
#import "StaticImgInfo.h"
@implementation StaticNumInfo
+ (NSDictionary *)objectClassInArray
{
    return @{@"productInfos":[StaticImgInfo class]};
}
@end