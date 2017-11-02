//
//  OrderNumTool.h
//  MillenniumStarERP
//
//  Created by yjq on 16/12/16.
//  Copyright © 2016年 com.millenniumStar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OrderNumTool : NSObject
+ (void)orderWithNum:(int)number andView:(UILabel *)sLab;
+ (NSString *)strWithPrice:(float)price;
+ (void)NSLoginWithStr:(NSString *)str andDic:(NSDictionary *)dic;
+ (UIWindow *)lastWindow;
@end
