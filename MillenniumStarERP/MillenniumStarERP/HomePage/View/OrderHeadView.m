//
//  OrderHeadView.m
//  MillenniumStarERP
//
//  Created by yjq on 16/10/8.
//  Copyright © 2016年 com.millenniumStar. All rights reserved.
//

#import "OrderHeadView.h"

@implementation OrderHeadView

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self = [[NSBundle mainBundle]loadNibNamed:@"OrderHeadView" owner:nil options:nil][0];
    }
    return self;
}

+ (id)view{
    return [[NSBundle mainBundle]loadNibNamed:@"OrderHeadView" owner:nil options:nil][0];
}

@end
