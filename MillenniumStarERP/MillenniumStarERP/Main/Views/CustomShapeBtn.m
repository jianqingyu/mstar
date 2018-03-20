//
//  CustomShapeBtn.m
//  MillenniumStarERP
//
//  Created by yjq on 17/6/6.
//  Copyright © 2017年 com.millenniumStar. All rights reserved.
//

#import "CustomShapeBtn.h"

@implementation CustomShapeBtn

- (void)drawRect:(CGRect)rect{
    //创建路径并获取句柄
    CGMutablePathRef path = CGPathCreateMutable();
    //指定矩形
    CGRect rectangle = self.bounds;
    //将矩形添加到路径中
    CGPathAddRect(path,NULL,rectangle);
    //获取上下文
    CGContextRef currentContext = UIGraphicsGetCurrentContext();
    //将路径添加到上下文
    CGContextAddPath(currentContext, path);
    //矩形边框颜色
    [BordColor setStroke];
    //边框宽度
    CGContextSetLineWidth(currentContext,0.5f);
    //绘制
    CGContextDrawPath(currentContext, kCGPathStroke);
    CGPathRelease(path);
}

@end
