//
//  CommonUtils.h
//
//  Created by yjq on 15/8/27.
//  Copyright (c) 2015年 qxzx.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface CommonUtils : NSObject
+ (BOOL) validateIdentityCard: (NSString *)identityCard;
+ (BOOL)verifyIDCardNumber:(NSString *)value;
+ (NSNumber*) validateEmail:(NSString *)email;
+ (NSNumber*) isValidateMobile:(NSString *)mobile;
+ (NSNumber*) isValidateVerifyCode:(NSString *)code;
+ (NSNumber*) isvalidatePassword:(NSString *)password;
+ (UIImage *) createImageWithColor: (UIColor*) color;
+ (NSString*) ReplacingString:(NSString *)str;
+ (NSString*) urlStrWithStr:(NSString *)url andDic:(NSDictionary *)dict;
@end
