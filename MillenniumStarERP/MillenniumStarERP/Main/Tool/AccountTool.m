//
//  AccountTool.m
//  MillenniumStar08.07
//
//  Created by yjq on 15/10/10.
//  Copyright © 2015年 qxzx.com. All rights reserved.
//

#import "AccountTool.h"

#define Accountpath [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0]stringByAppendingPathComponent:@"account.archive"]
@implementation AccountTool
//存储
+ (void)saveAccount:(Account *)account{
    [NSKeyedArchiver archiveRootObject:account toFile:Accountpath];
}
//返回
+ (Account *)account{
    Account *account = [NSKeyedUnarchiver unarchiveObjectWithFile:Accountpath];
    return account;
}

@end
