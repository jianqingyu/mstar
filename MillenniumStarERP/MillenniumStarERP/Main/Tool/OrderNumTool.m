//
//  OrderNumTool.m
//  MillenniumStarERP
//
//  Created by yjq on 16/12/16.
//  Copyright © 2016年 com.millenniumStar. All rights reserved.
//

#import "OrderNumTool.h"
#import "StrWithIntTool.h"
@implementation OrderNumTool

+ (void)orderWithNum:(int)number andView:(UILabel *)sLab
{
    if (number>0&&number<=99) {
        sLab.text = [NSString stringWithFormat:@"%d",number];
        sLab.hidden = NO;
    }else if(number>99){
        sLab.text = @"99+";
        sLab.hidden = NO;
    }else{
        sLab.hidden = YES;
    }
}

+ (NSString *)strWithPrice:(float)price
{
    return [NSString stringWithFormat:@"￥%0.0f",price];
}

+ (void)NSLoginWithStr:(NSString *)str andDic:(NSDictionary *)dic
{
    NSMutableArray *mutA = @[].mutableCopy;
    [dic enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        NSString *str = [NSString stringWithFormat:@"%@=%@",key,obj];
        [mutA addObject:str];
    }];
    NSString *mes = [StrWithIntTool strWithArr:mutA With:@"&"];
    NSLog(@"%@?%@",str,mes);
}

+ (UIWindow *)lastWindow
{
    NSArray *windows = [UIApplication sharedApplication].windows;
    for(UIWindow *window in [windows reverseObjectEnumerator]) {
        if ([window isKindOfClass:[UIWindow class]] &&
            CGRectEqualToRect(window.bounds, [UIScreen mainScreen].bounds)&&[window isKindOfClass:NSClassFromString(@"UITextEffectsWindow")])
            return window;
    }
    return [UIApplication sharedApplication].keyWindow;
}

@end
