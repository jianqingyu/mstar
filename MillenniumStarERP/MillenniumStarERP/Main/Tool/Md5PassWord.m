//
//  Md5PassWord.m
//  CityHousekeeper
//
//  Created by yjq on 15/12/2.
//  Copyright © 2015年 com.millenniumStar. All rights reserved.
//

#import "Md5PassWord.h"
#import "CommonCrypto/CommonDigest.h"
@implementation Md5PassWord
// 获取时间戳
+ (NSString *)genTimeStamp
{
    return [NSString stringWithFormat:@"%.0f", [[NSDate date] timeIntervalSince1970]];
}
// 随机字符串
+ (NSString *)md5:(NSString *)input
{
    NSString *inputStr = [NSString stringWithFormat:@"%@%@",input,[self genTimeStamp]];
    const char *cStr = [inputStr UTF8String];
    unsigned char digest[16];
    
    CC_MD5( cStr, strlen(cStr), digest ); // This is the md5 call
    
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    NSString *outStr = [output substringToIndex:output.length-3];
    return  outStr;
}

+ (NSString *)md5Pass:(NSString *)key{
    const char *cStr = [key UTF8String];
    unsigned char digest[16];
    
    CC_MD5( cStr, strlen(cStr), digest ); // This is the md5 call
    
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    NSString *outStr = [output substringToIndex:output.length-3];
    return  outStr;
}
@end
