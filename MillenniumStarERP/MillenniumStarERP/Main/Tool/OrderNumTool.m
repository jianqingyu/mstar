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
//数字显示
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
//float小数点显示
+ (NSString *)strWithPrice:(float)price
{
    return [NSString stringWithFormat:@"￥%0.0f",price];
}
//打印网络链接
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
//最上层window
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
//设置圆角
+ (void)setCircularWithPath:(UIView *)view size:(CGSize)size{
    UIBezierPath*maskPath = [UIBezierPath bezierPathWithRoundedRect:view.bounds byRoundingCorners:UIRectCornerAllCorners cornerRadii:size];
    CAShapeLayer*maskLayer = [[CAShapeLayer alloc]init];
    //设置大小
    maskLayer.frame = view.bounds;
    //设置图形样子
    maskLayer.path  = maskPath.CGPath;
    view.layer.mask = maskLayer;
    //获取上下文对象
//    CGContextRef ctx = UIGraphicsGetCurrentContext();
//    //创建路径对象
//    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:view.bounds cornerRadius:size.width];
//    //将路径对象加入上下文对象中
//    [[UIColor greenColor] setStroke];
//    //2.1.2 设置线宽
//    CGContextSetLineWidth(ctx, 10);
//    CGContextAddPath(ctx, path.CGPath);
//    //渲染
//    CGContextStrokePath(ctx);
}

@end
