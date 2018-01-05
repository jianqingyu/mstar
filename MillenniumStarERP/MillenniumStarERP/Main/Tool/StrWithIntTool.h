//
//  StrWithIntTool.h
//  MillenniumStar08.07
//
//  Created by yjq on 15/8/19.
//  Copyright (c) 2015年 qxzx.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StrWithIntTool : NSObject
/**
 *  把数字数组转成字符串
 */
+ (NSString *)strWithIntArr:(NSArray *)array;
/**
 *  把字符串数组转成字符串
 */
+ (NSString *)strWithArr:(NSArray *)array With:(NSString *)str;
+ (NSString *)strWithArr:(NSArray *)array;
+ (NSString *)strWithIntOrStrArr:(NSArray *)array;
+ (NSData   *)dataWithData:(UIImage *)image;
@end
