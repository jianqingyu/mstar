//
//  UIView+Extension.h
//  YQ微博
//
//  Created by tarena425 on 15/7/1.
//  Copyright (c) 2015年 ccyuqing. All rights reserved.
//

#import <UIKit/UIKit.h>
#define YQRandomColor [UIColor colorWithRed:(arc4random_uniform(256))/255.0 green:(arc4random_uniform(256))/255.0 blue:(arc4random_uniform(256))/255.0 alpha:1.0]
@interface UIView (Extension)
@property (nonatomic,assign)CGFloat x;
@property (nonatomic,assign)CGFloat y;
@property (nonatomic,assign)CGFloat centerX;
@property (nonatomic,assign)CGFloat centerY;
@property (nonatomic,assign)CGFloat width;
@property (nonatomic,assign)CGFloat height;
@property (nonatomic,assign)CGSize size;
@property (nonatomic,assign)CGPoint origin;
- (void)setLayerWithW:(CGFloat)width
             andColor:(UIColor*)backC
             andBackW:(CGFloat)backW;
@end
