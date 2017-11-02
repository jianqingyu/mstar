//
//  ShowPriceHeadView.m
//  MillenniumStarERP
//
//  Created by 余建清 on 2017/10/25.
//  Copyright © 2017年 com.millenniumStar. All rights reserved.
//

#import "ShowPriceHeadView.h"

@implementation ShowPriceHeadView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self = [[NSBundle mainBundle] loadNibNamed:@"ShowPriceHeadView" owner:nil options:nil][0];
    }
    return self;
}

+ (id)view{
    return [[NSBundle mainBundle] loadNibNamed:@"ShowPriceHeadView" owner:nil options:nil][0];
}

@end
