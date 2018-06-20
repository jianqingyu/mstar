//
//  UserOrderImgInfo.h
//  MillenniumStarERP
//
//  Created by 余建清 on 2018/5/10.
//  Copyright © 2018年 com.millenniumStar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserOrderImgInfo : NSObject
@property (nonatomic, copy)NSNumber *count;
@property (nonatomic, copy)NSNumber *mycount;
+ (NSString *)getImgData;
+ (NSArray *)getImgMonthData;
@end
