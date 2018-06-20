//
//  UserOrderImgInfo.m
//  MillenniumStarERP
//
//  Created by 余建清 on 2018/5/10.
//  Copyright © 2018年 com.millenniumStar. All rights reserved.
//

#import "UserOrderImgInfo.h"
#import "StrWithIntTool.h"
@implementation UserOrderImgInfo
+ (NSString *)getImgData{
    NSArray *arr = [self getDataArr:NO];
    return [StrWithIntTool strWithArr:arr With:@"|"];
}

+ (NSArray *)getImgMonthData{
    return [self getDataArr:YES];
}

+ (NSArray *)getDataArr:(BOOL)isMonth{
    NSDate *now = [NSDate date];
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSTimeInterval time1970 = [now timeIntervalSince1970];
    NSRange range = [cal rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:[NSDate date]];
    NSUInteger number = range.length;
    NSMutableArray *mutA = @[].mutableCopy;
    for (int i=0; i<6; i++) {
        NSDate *datetime = [NSDate dateWithTimeIntervalSince1970:time1970-(86400*number*i)];
        NSDateFormatter *dateFor = [[NSDateFormatter alloc]init];
        dateFor.dateFormat = @"yyyy-MM";
        NSString *str = [dateFor stringFromDate:datetime];
        NSString *day = [self getMaxDayWith:datetime];
        NSString *seaStr = [NSString stringWithFormat:@"%@-01,%@-%@",str,str,day];
        if (isMonth) {
            [mutA addObject:str];
        }else{
            [mutA addObject:seaStr];
        }
    }
    return mutA;
}

+ (NSString *)getMaxDayWith:(NSDate *)curDate{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSRange range = [calendar rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:curDate];
    NSUInteger numberOfDaysInMonth = range.length;
    return [NSString stringWithFormat:@"%lu",(unsigned long)numberOfDaysInMonth];
}

@end
